import "package:flixur/routes/setup/server_url.dart";
import "package:flixur/ui/inputs.dart";
import "package:flixur/utils.dart";
import "package:flutter/material.dart";

class LoginView extends StatefulWidget {
  const LoginView({required this.serverInfo, super.key});

  final ServerLoginPayload serverInfo;

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  String? errorText;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.base,
      appBar: AppBar(
        backgroundColor: context.colors.mantle,
        leading: Images.logo,
        title: Text(t.routes.setup.login.login),
      ),
      body: Center(
        child: FractionallySizedBox(
          widthFactor: 0.8,
          child: Column(
            mainAxisAlignment: .center,
            crossAxisAlignment: .stretch,
            spacing: 14,
            children: [
              FlixurInput(
                label: t.routes.setup.server_url.url.toUpperCase(),
                hintText: "https://demo.flixur.app",
                errorText: errorText,
                textController: _usernameController,
                onSubmitted: (_) => _loginSubmit(),
              ),
              FilledButton(
                onPressed: isLoading ? null : _loginSubmit,
                style: .new(
                  padding: .all(const .symmetric(vertical: 18)),
                  textStyle: .all(
                    const .new(fontSize: 24, fontWeight: .w500),
                  ),
                ),
                child: isLoading
                    ? const LoadingSpinner()
                    : Text(
                        t.routes.setup.login.login.toUpperCase(),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void setServerUrlError(String? text) {
    setState(() => errorText = text);
  }

  Future<void> _loginSubmit() async {}
}
