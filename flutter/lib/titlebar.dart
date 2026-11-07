import "dart:io";
import "dart:ui" show Size;

import "package:flixur/ui/main_nav/common.dart";
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

    // keep the OS window title in sync with the main nav
    window.title = MainNavWrapper.pageTitle.value;
    MainNavWrapper.pageTitle.addListener(
      () => window.title = MainNavWrapper.pageTitle.value,
    );

    // keep the notifier up to date
    isMaximizedNotifier.value = window.isMaximized;
    WindowManager.instance.addListener(
      (event) => isMaximizedNotifier.value = window.isMaximized,
    );
  }

  static void minimize() {
    final window = getWindow();
    window?.minimize();
  }

  static bool get isMaximized => getWindow()?.isMaximized ?? false;
  static final ValueNotifier<bool> isMaximizedNotifier = ValueNotifier<bool>(
    false,
  );

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

  /// Resize the window to a landscape "phone" layout for debugging.
  static void debugResizeToPhone() {
    final window = getWindow();
    if (window == null) return;
    final phoneHeight = window.size.height * 0.9;
    final phoneWidth = (phoneHeight * 9 / 16).clamp(0.0, window.size.width);
    if (window.isMaximized) window.unmaximize();
    window.setSize(Size(phoneWidth, phoneHeight).toNative(), false);
  }
}
