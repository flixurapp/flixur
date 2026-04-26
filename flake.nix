{
  description = "flixur project";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    go-overlay = {
      url = "github:purpleclay/go-overlay";
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      flake-utils,
      go-overlay,
      nixpkgs,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ go-overlay.overlays.default ];
        };
        gopkg = pkgs.go-bin.fromGoMod ./server/go.mod;

        flixur-server = pkgs.buildGoWorkspace {
          go = gopkg;
          pname = "flixur-server";
          version = "0.0.0";
          src = ./.;
          subPackages = [ "server" ];
          modules = ./govendor.toml;
          postInstall = "mv $out/bin/flixur $out/bin/flixur-server";
        };

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
          openapi = pkgs.writeShellApplication {
            name = "openapi";
            runtimeInputs = with pkgs; [
              curl
              openapi-generator-cli
            ];
            text = ''
              ${setup}

              ${flixur-server}/bin/flixur-server >/tmp/flixur-openapi-server.log 2>&1 &
              server_pid=$!
              trap 'kill "$server_pid" >/dev/null 2>&1 || true' EXIT

              for _ in $(seq 1 60); do
                if curl -fsS "http://127.0.0.1:8787/api/openapi.json" >/dev/null; then
                  break
                fi
                sleep 0.5
              done

              if ! curl -fsS "http://127.0.0.1:8787/api/openapi.json" >/dev/null; then
                echo "Server did not become ready on :8787" >&2
                echo "Check /tmp/flixur-openapi-server.log for details" >&2
                exit 1
              fi

              openapi-generator-cli generate \
                -i http://localhost:8787/api/openapi.json \
                -g typescript-fetch \
                -o openapi/src \
                --additional-properties=supportsES6=true,useSingleRequestParameter=false
            '';
          };
          proto = pkgs.writeShellApplication {
            name = "proto";
            runtimeInputs = with pkgs; [
              gnused
              protobuf
              protoc-gen-go
              protoc-gen-go-grpc
            ];
            text = ''
              ${setup}

              protoc -I=./proto \
                --go_out=./proto/go --go_opt=paths=source_relative \
                --go-grpc_out=./proto/go --go-grpc_opt=paths=source_relative \
                ./proto/*.proto
              # remove the omitempty flag from json that isnt "optional" (with *)
              sed -i '/\*.*omitempty/!s/,omitempty//' ./proto/go/*.pb.go
            '';
          };
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
              commands.proto
              commands.tygo
              commands.openapi
            ];
            text = ''
              ${setup}
              proto
              tygo
              openapi
            '';
          };
        };

      in
      {
        packages = {
          inherit flixur-server;
          default = flixur-server;
        };

        apps = (builtins.mapAttrs (_: drv: flake-utils.lib.mkApp { inherit drv; }) commands) // {
          default = flake-utils.lib.mkApp { drv = flixur-server; };
        };
      }
    );
}
