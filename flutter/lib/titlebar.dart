import "package:window_manager/window_manager.dart";

//TODO: wire into setting
const startMaximizedSetting = true;

class TitlebarManager {
  static Future<void> init() async {
    final window = WindowManager.instance.getCurrent();
    if (window == null) return;
    window.titleBarStyle = TitleBarStyle.hidden;
    if (startMaximizedSetting) window.maximize();
  }
}
