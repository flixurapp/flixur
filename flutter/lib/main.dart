import 'package:flutter/material.dart';

import './gen/strings.g.dart';
import './ui/responsiveness.dart';
import './ui/theme.dart';

void main() {
  // set up and use translations
  WidgetsFlutterBinding.ensureInitialized();
  LocaleSettings.useDeviceLocale();
  runApp(TranslationProvider(child: const MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: buildAppTheme(AppColors.of(.dark)),
      home: LoginScreen(),
    );
  }
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final logo = RepaintBoundary(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          // sane sizing for logo depending on screen size
          maxWidth:
              context.screenSize.width * (context.isLandscape ? 0.4 : 0.8),
          maxHeight:
              context.screenSize.height * (context.isLandscape ? 0.4 : 0.3),
        ),
        child: Image.asset("assets/logo.png", fit: .contain),
      ),
    );

    return Scaffold(
      backgroundColor: context.colors.mantle,
      body: Center(
        child: Flex(
          direction: context.isLandscape ? Axis.horizontal : Axis.vertical,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: .center,
                spacing: 16,
                children: [
                  logo,
                  Text(t.pages.login.welcome, style: TextStyle(fontSize: 56)),
                ],
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: .center,
                children: [
                  FilledButton(
                    onPressed: () {},
                    child: Text(t.pages.login.connect.toUpperCase()),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
