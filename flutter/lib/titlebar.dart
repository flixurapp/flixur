import "dart:io";

import "package:flutter/foundation.dart";
import "package:window_manager/window_manager.dart";

//TODO: wire into setting
const startMaximizedSetting = true;

class TitlebarManager {
  /// Whether the platform supports a custom titlebar.
  static bool get isSupported =>
      !(kIsWeb || Platform.isAndroid || Platform.isIOS);

  /// Get the current window instance.
  static Window? getWindow() {
    return WindowManager.instance.getCurrent();
  }

  static Future<void> init() async {
    if (!isSupported) return;

    final window = getWindow();
    if (window == null) return;
    window.titleBarStyle = TitleBarStyle.hidden;
    if (startMaximizedSetting) window.maximize();
  }

  static void minimize() {
    if (!isSupported) return;
    final window = getWindow();
    window?.minimize();
  }

  static void maximize() {
    if (!isSupported) return;
    final window = getWindow();
    window?.maximize();
  }

  static void close() {
    if (!isSupported) return;
    final window = getWindow();
    window?.close();
  }
}
