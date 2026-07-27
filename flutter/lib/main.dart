import "package:flixur/router.dart";
import "package:flixur/utils.dart";
import "package:flutter/material.dart";
import "package:flutter_web_plugins/url_strategy.dart";

void main() async {
  // enable path URLs
  usePathUrlStrategy();
  // ensure flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // setup translations
  await LocaleSettings.useDeviceLocale();

  // get package info
  await AppInfo.init();

  runApp(TranslationProvider(child: const MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: buildAppTheme(AppColors.of(.dark)),
      routerConfig: router,
    );
  }
}
