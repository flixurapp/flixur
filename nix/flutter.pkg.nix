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
}
