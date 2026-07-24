import "package:flixur/extensions.dart";
import "package:flixur/gen/strings.g.dart";
import "package:flixur/router.dart";
import "package:flutter/material.dart";
import "package:flutter_web_plugins/url_strategy.dart";

void main() async {
  // enable path URLs
  usePathUrlStrategy();
  // set up and use translations
  WidgetsFlutterBinding.ensureInitialized();
  await LocaleSettings.useDeviceLocale();

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
