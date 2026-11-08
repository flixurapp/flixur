{ pkgs, ... }:
let
  yamlKeySort = [ "flutter/assets/translations/*.yaml" ];
in
{
  projectRootFile = "flake.nix";

  settings.excludes = [
    # generated code
    "server/ent/**"
    "pluginkit/proto/**"
    "pluginkit/manifest.schema.json"
    "flutter/openapi/**"
    "flutter/build/**"
    "flutter/.dart_tool/**"
    # generated manifests
    "flutter/pubspec.lock"
    "flutter/pubspec.lock.json"
    "govendor.toml"
    "*.lock"
    "*.sum"
  ];

  programs = {
    nixfmt.enable = true;
    gofmt.enable = true;
    dart-format.enable = true;
    clang-format.enable = true;
    prettier.enable = true;
    buf.enable = true;
    just.enable = true;
  };

  # ignore the yaml key files in prettier so yaml-sort can work
  settings.formatter.prettier.excludes = yamlKeySort;
  settings.formatter.yaml-sort = {
    command = "${pkgs.yq-go}/bin/yq";
    options = [
      "eval"
      "sort_keys(..)"
      "--inplace"
    ];
    includes = yamlKeySort;
  };
}
