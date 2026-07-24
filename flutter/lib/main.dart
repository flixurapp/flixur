import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

import './gen/strings.g.dart';
import './router.dart';
import './ui/theme.dart';

void main() {
  usePathUrlStrategy();
  // set up and use translations
  WidgetsFlutterBinding.ensureInitialized();
  LocaleSettings.useDeviceLocale();
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
