import 'package:flixur/ui/inputs.dart';
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

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _serverUrlController = TextEditingController();

  String? errorText;

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
          direction: context.isLandscape ? .horizontal : .vertical,
          mainAxisAlignment: .center,
          crossAxisAlignment: .center,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: .center,
                spacing: 16,
                children: [
                  logo,
                  Text(
                    t.pages.login.welcome,
                    style: const TextStyle(fontSize: 56),
                  ),
                ],
              ),
            ),
            Expanded(
              child: FractionallySizedBox(
                widthFactor: 0.8,
                child: Column(
                  mainAxisAlignment: .center,
                  crossAxisAlignment: .stretch,
                  spacing: 14,
                  children: [
                    FlixurInput(
                      label: t.pages.login.server_url.toUpperCase(),
                      hintText: "https://demo.flixur.app",
                      errorText: errorText,
                      textController: _serverUrlController,
                      onSubmitted: (_) => _serverUrlSubmit(),
                    ),
                    FilledButton(
                      onPressed: _serverUrlSubmit,
                      style: .new(
                        padding: .all(.symmetric(vertical: 18)),
                        textStyle: .all(.new(fontSize: 24, fontWeight: .w500)),
                      ),
                      child: Text(t.pages.login.connect.toUpperCase()),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void setServerUrlError(String? text) {
    setState(() => errorText = text);
  }

  void _serverUrlSubmit() {
    setServerUrlError(null);
    final serverUrl = Uri.tryParse(_serverUrlController.text);
    if (serverUrl == null ||
        // must be an HTTP url
        (serverUrl.scheme != "http" && serverUrl.scheme != "https") ||
        // and have a host
        serverUrl.authority == "") {
      setServerUrlError(t.pages.login.server_url_error);
      return;
    }
  }
}
