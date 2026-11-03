{
  flutter341,
  lib,

  targetFlutterPlatform ? "linux",
}:
flutter341.buildFlutterApplication {
  pname = "flixur-flutter";
  version = "0.0.0+1";
  inherit targetFlutterPlatform;
  src = ../flutter;
  pubspecLock = lib.importJSON ../flutter/pubspec.lock.json;
  # hashes for git-sourced pub dependencies (see pubspec.lock.json)
  gitHashes.iconify_design = "sha256-Ak9YTmHrvJuxKp7LUr7iUyskl/DrUm16cH+bSo2E8Ac=";
}
