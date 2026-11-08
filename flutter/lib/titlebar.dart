import "dart:async";
import "dart:io";

import "package:flixur/ui/main_nav/common.dart";
import "package:flutter/foundation.dart";
import "package:material_ui/material_ui.dart";
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

/// Holds titles pushed by [PageTitle] widgets.
class PageTitleSlot extends ValueNotifier<String?> {
  new() : super(null);

  /// Stack of titles pushed by widgets.
  final _titleStack = <Object, String>{};

  /// Have [widget] push a [title], replacing any existing title it has.
  void push(Object widget, String title) {
    if (_titleStack[widget] == title) return;
    _titleStack[widget] = title;
    _scheduleUpdate();
  }

  /// Remove any title associated with [widget].
  void pop(Object widget) {
    if (_titleStack.remove(widget) != null) _scheduleUpdate();
  }

  void _scheduleUpdate() {
    // updates have to be scheduled so a title change doesn't update the widget
    // tree before a build is finished
    scheduleMicrotask(() {
      final title = _titleStack.isEmpty ? null : _titleStack.values.last;
      if (value != title) value = title;
    });
  }
}

/// Provides a [PageTitleSlot] to [PageTitle]s beneath it.
class const PageTitleScope({
  required final PageTitleSlot slot,
  required super.child,
  super.key,
}) extends InheritedWidget {
  /// The nearest title slot for a [context] if it exists.
  static PageTitleSlot? slotOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<PageTitleScope>()?.slot;
  @override
  bool updateShouldNotify(PageTitleScope old) => old.slot != slot;
}

/// Pushes its [title] to the nearest [PageTitleScope].
class const PageTitle(
  final String title, {
  required final Widget child,
  super.key,
}) extends StatefulWidget {
  @override
  State<PageTitle> createState() => _PageTitleState();
}

class _PageTitleState extends State<PageTitle> {
  PageTitleSlot? _slot;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _sync();
  }

  @override
  void didUpdateWidget(PageTitle old) {
    super.didUpdateWidget(old);
    if (widget.title != old.title) _sync();
  }

  void _sync() {
    final slot = PageTitleScope.slotOf(context);
    if (!identical(slot, _slot)) {
      _slot?.pop(this);
      _slot = slot;
    }
    _slot?.push(this, widget.title);
  }

  @override
  void deactivate() {
    _slot?.pop(this);
    _slot = null;
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
