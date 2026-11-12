import "package:flixur/api.dart";
import "package:flixur/hive/hive_adapters.dart";
import "package:flixur/router.dart";
import "package:flixur/settings.dart";
import "package:flixur/storage.dart";
import "package:flixur/titlebar.dart";
import "package:flixur/ui/icons.dart";
import "package:flixur/ui/main_nav/common.dart";
import "package:flixur/ui/main_nav/top.dart";
import "package:flixur/utils.dart";
import "package:flutter_web_plugins/url_strategy.dart";
import "package:material_ui/material_ui.dart";
import "package:window_manager/window_manager.dart";

void main() async {
  // enable path URLs
  usePathUrlStrategy();
  // ensure flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  //! A LOT OF THIS HAS TO BE INITIALIZED IN ORDER SO LOOK BEFORE REORDERING

  // setup translations
  await LocaleSettings.useDeviceLocale();

  // get package info
  await AppInfo.init();

  // init hive and open boxes
  await Storage.init();
  await initIconify();
  registerHiveAdapters();

  // init API client
  Api.init();

  // init settings manager
  await Settings.init();

  // init title bar
  await TitlebarManager.init();

  runApp(TranslationProvider(child: const MainApp()));
}

class const MainApp({super.key}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: AppTheme.dark.theme,
      routerConfig: router,
      builder: (context, page) =>
          WindowFrame(page: page ?? const Text("Uhm~ 4-oh-4...")),
    );
  }
}

/// Window titlebar / buttons wrapping the entire app.
class const WindowFrame({required final Widget page, super.key})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GatedWidget(
      gate: TitlebarManager.isSupported,
      // wrap the entire app with resize edges if supported
      wrapper: (child) => SettingsValue(
        "ui.window.useCustom",
        builder: (context, _) => ValueListenableBuilder(
          valueListenable: TitlebarManager.isMaximizedNotifier,
          builder: (context, maximized, child) => TitlebarManager.shouldEnable
              ? DragToResizeArea(
                  // only enable resize edges when the window isnt maximized
                  enableResizeEdges: maximized ? [] : null,
                  child: child!,
                )
              : child!,
          child: child,
        ),
      ),

      child: PageTitleScope(
        // main app title slot
        slot: MainNavWrapper.titleSlot,
        child: Scaffold(
          body: Column(
            crossAxisAlignment: .stretch,
            children: [
              // titlebar
              const MainNavTop(),
              // page
              Expanded(child: page),
            ],
          ),
        ),
      ),
    );
  }
}
