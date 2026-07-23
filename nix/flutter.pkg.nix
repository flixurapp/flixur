{
  flutter341,
  targetFlutterPlatform ? "linux",
}:
flutter341.buildFlutterApplication {
  pname = "flixur-flutter";
  version = "0.0.0";
  inherit targetFlutterPlatform;
  src = ../flutter;
  pubspecLock = lib.importJSON ../flutter/pubspec.lock.json;
}
