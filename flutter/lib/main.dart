import 'package:flutter/material.dart';

import './gen/strings.g.dart';

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
    return const MaterialApp(home: LoginScreen());
  }
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Image.asset("assets/logo.png", width: 50),
          FilledButton(onPressed: () {}, child: Text(t.pages.login.connect)),
        ],
      ),
    );
  }
}
