import "package:window_manager/window_manager.dart";

//TODO: start maximized setting
class TitlebarManager {
  static Future<void> init() async {
    final window = WindowManager.instance.getCurrent();
    if (window == null) return;
    window.titleBarStyle = TitleBarStyle.hidden;
  }
}
