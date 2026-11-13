import "dart:async";
import "dart:io";

import "package:device_info_plus/device_info_plus.dart";
import "package:flutter/foundation.dart";
import "package:material_ui/material_ui.dart";
import "package:package_info_plus/package_info_plus.dart";
import "package:path_provider/path_provider.dart";

// re-export several extensions on the context so we arent duplicating
export "package:flixur/gen/strings.g.dart";
export "package:flixur/ui/responsiveness.dart";
export "package:flixur/ui/theme.dart";
export "package:go_router/go_router.dart";

/// Contains app/system information.
class AppInfo {
  static final _deviceInfo = DeviceInfoPlugin();
  static late PackageInfo _info;

  /// The application support directory for the current system. Null if on web.
  static String? dataDirectory;

  static Future<void> init() async {
    _info = await PackageInfo.fromPlatform();
    if (kIsWeb) {
      final browser = await _deviceInfo.webBrowserInfo;
      deviceName = browser.browserName.name;
      deviceOS = "Web (${browser.browserName.name})";
    } else if (Platform.isWindows) {
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

    // load data dir
    if (!kIsWeb) {
      dataDirectory = (await getApplicationSupportDirectory()).path;
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

/// Cancels and restarts a timer on each [run] call.
class Debounced({
  final Duration duration = defaultDuration,

  /// Whether [dispose] should run the pending action instead of dropping it.
  final bool flushOnDispose = false,
}) {
  static const defaultDuration = Duration(milliseconds: 350);

  Timer? _timer;
  void Function()? _action;

  void run(void Function() action) {
    _timer?.cancel();
    _timer = Timer(duration, _action = action);
  }

  void cancel() {
    _timer?.cancel();
    _action = null;
  }

  /// Runs the pending action immediately, if any.
  void flush() {
    final action = _action;
    _timer?.cancel();
    _action = null;
    action?.call();
  }

  /// Destroys this debouncer, flushing it if enabled.
  void dispose() {
    if (flushOnDispose) {
      flush();
    } else {
      _timer?.cancel();
      _action = null;
    }
    _timer = null;
  }
}

/// Conditionally wraps [child] using [wrapper] when [gate] is true.
class const GatedWidget({
  required final bool gate,
  required final Widget Function(Widget child) wrapper,
  required final Widget child,
  super.key,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) => gate ? wrapper(child) : child;
}
