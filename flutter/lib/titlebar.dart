import "dart:io";

import "package:flutter/foundation.dart";
import "package:window_manager/window_manager.dart";

//TODO: wire into setting
const startMaximizedSetting = true;

class TitlebarManager {
  /// Whether the platform supports a custom titlebar.
  static bool get isSupported =>
      !(kIsWeb || Platform.isAndroid || Platform.isIOS);

  //TODO: wire setting into this and other stuff idk
  /// Whether the title bar should be showing buttons.
  static bool get shouldShowButtons => isSupported;

  /// Get the current window instance.
  static Window? getWindow() {
    if (!isSupported) return null;
    return WindowManager.instance.getCurrent();
  }

  static Future<void> init() async {
    final window = getWindow();
    if (window == null) return;
    window.titleBarStyle = TitleBarStyle.hidden;
    if (startMaximizedSetting) window.maximize();
  }

  static void minimize() {
    final window = getWindow();
    window?.minimize();
  }

  static bool get isMaximized => getWindow()?.isMaximized ?? false;
  static void toggleMaximized() {
    final window = getWindow();
    if (isMaximized) {
      window?.unmaximize();
    } else {
      window?.maximize();
    }
  }

  static void close() {
    final window = getWindow();
    window?.close();
  }
}
