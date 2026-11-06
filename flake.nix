{
  description = "flixur project";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    go-overlay = {
      url = "github:purpleclay/go-overlay";
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      flake-utils,
      go-overlay,
      nixpkgs,
      nixpkgs-unstable,
      treefmt-nix,
      ...
    }:
    (flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ go-overlay.overlays.default ];
        };
        pkgs-unstable = import nixpkgs-unstable {
          inherit system;
          overlays = [ go-overlay.overlays.default ];
        };
        lib = nixpkgs.lib;

        treefmtEval = treefmt-nix.lib.evalModule pkgs {
          imports = [ ./treefmt.nix ];
          # use the new dart version that the rest of the repo uses
          settings.formatter.dart-format.command = "${pkgs-unstable.flutter.dart}/bin/dart";
        };

        flixur-flutter-linux = pkgs-unstable.callPackage ./nix/flutter.pkg.nix { };
        flixur-flutter-web = pkgs-unstable.callPackage ./nix/flutter.pkg.nix {
          targetFlutterPlatform = "web";
        };
        flixur-server = pkgs.callPackage ./nix/server.pkg.nix { frontendDir = flixur-flutter-web; };

        # util to cd to root
        setup = ''
          set -euo pipefail
          cd "$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
        '';

        commands = {
          # generators
          govendor = pkgs.writeShellApplication {
            name = "govendor";
            text = "${go-overlay.packages.${system}.govendor}/bin/govendor";
          };
          openapi =
            let
              openapi-port = "18787";
              openapi-addr = "http://127.0.0.1:${openapi-port}/api/openapi.json";
              openapi-out = "flutter/openapi/";
              openapi-cache = ".openapi-spec.cache";
              # re-applied after generation, which wipes the output dir
              analysisOptions = pkgs.writeText "openapi-analysis_options.yaml" ''
                analyzer:
                  language:
                    strict-inference: true
                    strict-raw-types: true
                    strict-casts: false
                  exclude:
                    - test/*.dart
                    - lib/**
                  errors:
                    deprecated_member_use_from_same_package: ignore
              '';
            in
            pkgs.writeShellApplication {
              name = "openapi";
              runtimeInputs = with pkgs; [
                coreutils
                curl
                diffutils
                killport
                pkgs-unstable.openapi-generator-cli
                pkgs-unstable.flutter
              ];
              text = ''
                ${setup}
                repo_root="$(pwd)"

                killport ${openapi-port}
                export FLIXUR_DEVELOPMENT_RUN_AS_GENERATOR=true
                export FLIXUR_PORT=${openapi-port}
                go run ./server &
                server_pid=$!
                # move the dart-tool dir back
                trap 'kill "$server_pid" >/dev/null 2>&1 || true; if [ -n "''${dart_tool_tmp:-}" ] && [ -d "$dart_tool_tmp/.dart_tool" ]; then mv "$dart_tool_tmp/.dart_tool" ${openapi-out} 2>/dev/null || true; fi' EXIT

                spec_tmp="$(mktemp)"
                for _ in $(seq 1 120); do
                  if curl -fsS "${openapi-addr}" > "$spec_tmp"; then
                    break
                  fi
                  echo "Waiting..."
                  sleep 1
                done

                if ! curl -fsS "${openapi-addr}" > "$spec_tmp"; then
                  echo "Server did not become ready on :${openapi-port}" >&2
                  echo "Check /tmp/flixur-openapi-server.log for details" >&2
                  exit 1
                fi

                if cmp -s "$spec_tmp" ${openapi-cache}; then
                  echo "OpenAPI unchanged, skipping client regeneration"
                  killport ${openapi-port} || true
                  exit 0
                fi

                export DART_POST_PROCESS_FILE="${pkgs-unstable.flutter.dart}/bin/dart format"

                # keep dart-tool dir
                dart_tool_tmp="$(mktemp -d)"
                mv ${openapi-out}/.dart_tool "$dart_tool_tmp" 2>/dev/null || true

                rm -rf ${openapi-out}

                openapi-generator-cli generate \
                  -i ${openapi-addr} \
                  -g dart-dio \
                  -o ${openapi-out} \
                  --enable-post-process-file

                cp ${analysisOptions} ${openapi-out}/analysis_options.yaml

                # restore dart-tool dir
                mv "$dart_tool_tmp/.dart_tool" ${openapi-out}
                rm -rf "$dart_tool_tmp"

                killport ${openapi-port} || true

                cd ${openapi-out}
                dart run build_runner build

                # only record the cache after everything succeeded
                cp "$spec_tmp" "$repo_root/${openapi-cache}"
              '';
            };
          proto =
            let
              proto-in = "./proto";
              proto-out = "./pluginkit/proto";

              # Convert camelCase to SCREAMING_SNAKE_CASE
              screamingSnake =
                let
                  go =
                    s: acc:
                    let
                      m = builtins.match "([a-z0-9]*)([A-Z])(.*)" s;
                    in
                    if m == null then
                      acc + s
                    else
                      go (builtins.elemAt m 2) (acc + (builtins.elemAt m 0) + "_" + (builtins.elemAt m 1));
                in
                s: lib.removePrefix "_" (lib.toUpper (go s ""));

              # Enums whose generated Go values double the enum name
              # `Feature_FEATURE_MUSIC_METADATA` => `Feature_MUSIC_METADATA`.
              enumNames = [
                "Feature"
                "AlbumType"
                "TrackExplicitness"
              ];
              dedupeEnums = lib.concatMapStrings (
                enumName:
                let
                  prefix = screamingSnake enumName;
                in
                "-e \"s/${enumName}_${prefix}_/${enumName}_/g\" "
              ) enumNames;
            in
            pkgs.writeShellApplication {
              name = "proto";
              runtimeInputs = with pkgs; [
                gnused
                protobuf
                protoc-gen-go
                protoc-gen-go-grpc
              ];
              text = ''
                ${setup}

                protoc -I=${proto-in} \
                  --go_out=${proto-out} --go_opt=paths=source_relative \
                  --go-grpc_out=${proto-out} --go-grpc_opt=paths=source_relative \
                  ${proto-in}/*.proto
                # remove the omitempty flag from json that isnt "optional" (with *)
                sed -i '/\*.*omitempty/!s/,omitempty//' ${proto-out}/*.pb.go
                # dedupe enum value prefixes
                sed -i ${dedupeEnums}${proto-out}/*.pb.go

                cd pluginkit
                go generate ./...
              '';
            };
          #TODO: eventually fix this and publish a js package?
          tygo = pkgs.writeShellApplication {
            name = "tygo";
            runtimeInputs = with pkgs; [ tygo ];
            text = ''
              ${setup}
              tygo generate
            '';
          };
          generate = pkgs.writeShellApplication {
            name = "generate";
            runtimeInputs = [
              pkgs-unstable.flutter
              pkgs.ent-go
              pkgs.go
              pkgs.yq
              commands.govendor
              commands.proto
              commands.tygo
              commands.openapi
            ];
            text = ''
              ${setup}
              govendor

              go generate ./server/...

              proto
              #tygo
              openapi

              # flutter stuff
              cd flutter
              # dart need to know where the flutter SDK is to work properly
              FLUTTER_ROOT=${pkgs-unstable.flutter} dart run build_runner build
              # we also need to generate the JSON file for the pubspec
              yq . pubspec.lock > pubspec.lock.json
            '';
          };
          # apply dart fixes
          dart-fix = pkgs.writeShellApplication {
            name = "dart-fix";
            runtimeInputs = [
              commands.flutter-wrapped
              pkgs-unstable.flutter.dart
            ];
            text = ''
              ${setup}
              cd flutter
              flutter pub get
              dart fix --apply
            '';
          };
          # wrapped flutter command for debug builds with libsecret included
          flutter-wrapped = pkgs.writeShellApplication {
            name = "flutter";
            runtimeInputs = with pkgs; [
              pkgs-unstable.flutter
              pkg-config # so flutter can find packages
              libsysprof-capture # flutter requires this for some reason
              libsecret.dev # for flutter_secure_storage
            ];
            text = ''
              # we arent appending to the variable because there is no variable to append to
              export PKG_CONFIG_PATH="${pkgs.lib.makeSearchPath "lib/pkgconfig" [ pkgs.libsecret.dev ]}"
              exec flutter "$@"
            '';
          };
          test-pluginkit = pkgs.writeShellApplication {
            name = "test-pluginkit";
            runtimeInputs = [ pkgs.go ];
            text = ''
              ${setup}
              cd pluginkit
              go test -coverprofile=coverage.out -coverpkg="$(go list ./... | grep -v '/ent' | tr '\n' ',' | sed 's/,$//')" ./...
              go tool cover -html=coverage.out # open coverage HTML
            '';
          };
          test-server = pkgs.writeShellApplication {
            name = "test-server";
            runtimeInputs = [ pkgs.go ];
            text = ''
              ${setup}
              cd server
              go test -coverprofile=coverage.out -coverpkg="$(go list ./... | grep -v '/ent' | tr '\n' ',' | sed 's/,$//')" ./...
              go tool cover -html=coverage.out # open coverage HTML
            '';
          };
          # clean up stale flutter caches
          flutter-clean = pkgs.writeShellApplication {
            name = "flutter-clean";
            runtimeInputs = [ commands.flutter-wrapped ];
            text = ''
              ${setup}
              rm -rf flutter/build flutter/.dart_tool
            '';
          };
        };

      in
      {
        packages = {
          inherit flixur-server flixur-flutter-linux flixur-flutter-web;
          default = flixur-server;
        };

        apps = (builtins.mapAttrs (_: drv: flake-utils.lib.mkApp { inherit drv; }) commands) // {
          default = flake-utils.lib.mkApp { drv = flixur-server; };
        };

        devShells.default = pkgs.mkShell {
          buildInputs = [
            commands.flutter-wrapped
            pkgs-unstable.flutter.dart
          ];
        };

        formatter = treefmtEval.config.build.wrapper;
        checks.format = treefmtEval.config.build.check self;
      }
    ))
    // {
      # NixOS module for the server
      nixosModules.default = import ./nix/module.nix { flake = self; };
    };
}
