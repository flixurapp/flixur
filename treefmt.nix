{
  projectRootFile = "flake.nix";

  settings.excludes = [
    # generated code
    "server/ent/**"
    "pluginkit/proto/**"
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
}
