import "dart:io";

import "package:device_info_plus/device_info_plus.dart";
import "package:flutter/material.dart";
import "package:openapi/api.dart";
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

  //TODO: machine id
  static String machineID = "";
  static late String deviceName;
  static late String deviceOS;

  static String get name => _info.appName;
  static String get versionString => "${_info.version}+${_info.buildNumber}";
  // Client identifier string for headers.
  static String get clientIdentifier => "$name/$versionString";
}

sealed class ApiResult<T> {
  const ApiResult();
}

class ApiSuccess<T> extends ApiResult<T> {
  const ApiSuccess(this.data);
  final T data;
}

class ApiFailure<T> extends ApiResult<T> {
  const ApiFailure(this.err);
  final ApiException err;
}

class Images {
  // App logo.
  static Image get logo => Image.asset("assets/logo.png", fit: .contain);
}

// safely make a request and return the error if it occurs
Future<ApiResult<T>> safeGet<T>(Future<T?> Function() request) async {
  try {
    final result = await request();
    if (result == null) throw ApiException(0, "No request body was returned.");
    return ApiSuccess(result);
  } on ApiException catch (err) {
    return ApiFailure(err);
  }
}
