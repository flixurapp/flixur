{
  flutter,
  lib,

  targetFlutterPlatform ? "linux",
}:
flutter.buildFlutterApplication {
  pname = "flixur-flutter";
  version = "0.0.0+1";
  inherit targetFlutterPlatform;
  src = ../flutter;
  pubspecLock = lib.importJSON ../flutter/pubspec.lock.json;
  # hashes for git-sourced pub dependencies (see pubspec.lock.json)
  gitHashes.iconify_design = "sha256-2i8MA5B6NXCr93oZqcnQJ0Ajz9Un0emMC1ayn1A//MA=";
}
