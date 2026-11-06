import "dart:io";

import "package:flutter/foundation.dart";
import "package:window_manager/window_manager.dart";

//TODO: wire into setting
const startMaximizedSetting = true;

class TitlebarManager {
  static Future<void> init() async {
    // these platforms dont have title bars
    if (kIsWeb || Platform.isAndroid || Platform.isIOS) return;

    final window = WindowManager.instance.getCurrent();
    if (window == null) return;
    window.titleBarStyle = TitleBarStyle.hidden;
    if (startMaximizedSetting) window.maximize();
  }
}
