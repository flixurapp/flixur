import "dart:io";

import "package:device_info_plus/device_info_plus.dart";
import "package:flutter/material.dart";
import "package:package_info_plus/package_info_plus.dart";

// re-export several extensions on the context so we arent duplicating
export "package:flixur/gen/strings.g.dart";
export "package:flixur/ui/responsiveness.dart";
export "package:flixur/ui/theme.dart";
export "package:go_router/go_router.dart";

class AppInfo {
  static final _deviceInfo = DeviceInfoPlugin();
  static late PackageInfo _info;

  static Future<void> init() async {
    _info = await PackageInfo.fromPlatform();
    if (Platform.isWindows) {
      final device = await _deviceInfo.windowsInfo;
      deviceName = device.computerName;
      deviceOS = "${device.productName} Build ${device.displayVersion}";
    } else if (Platform.isMacOS) {
      final device = await _deviceInfo.macOsInfo;
      deviceName = device.modelName;
      final macVersion = [
        device.majorVersion,
        device.minorVersion,
        device.patchVersion,
      ].join(".");
      deviceOS = "macOS $macVersion";
    } else if (Platform.isLinux) {
      final device = await _deviceInfo.linuxInfo;
      deviceName = Platform.localHostname;
      deviceOS = device.prettyName;
    } else if (Platform.isIOS) {
      final device = await _deviceInfo.iosInfo;
      deviceName = device.modelName;
      deviceOS = "${device.systemName} ${device.systemVersion}";
    } else if (Platform.isAndroid) {
      final device = await _deviceInfo.androidInfo;
      deviceName = device.model;
      deviceOS =
          "Android ${device.version.release} (SDK ${device.version.sdkInt})";
    } else {
      // unknown platform
      deviceName = "Unknown Device";
      deviceOS = "Unknown";
    }
  }

  static late String deviceName;
  static late String deviceOS;

  static String get name => _info.appName;
  static String get versionString => "${_info.version}+${_info.buildNumber}";
  // Client identifier string for headers.
  static String get clientIdentifier => "$name/$versionString";
}

class Images {
  // App logo.
  static Image get logo => Image.asset("assets/logo.png", fit: .contain);
}
