import "package:flixur/routes/startup/components.dart";
import "package:flixur/routes/startup/server_url.dart";
import "package:flixur/ui/inputs.dart";
import "package:flixur/utils.dart";
import "package:flutter/material.dart";
import "package:openapi/api.dart";

class SetupView extends StatefulWidget {
  const SetupView({required this.serverInfo, super.key});

  final ServerLoginPayload serverInfo;

  @override
  State<SetupView> createState() => _SetupViewState();
}

class _SetupViewState extends State<SetupView> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordFocus = FocusNode();

  PingOutputBody get serverResponseBody => widget.serverInfo.body;

  AuthenticationApi? api;
  @override
  void initState() {
    super.initState();
    api = AuthenticationApi(ApiClient(basePath: widget.serverInfo.url));
  }

  String? errorText;
  bool isPasswordLoading = false;
  bool isOidcLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.base,
      appBar: AppBar(
        backgroundColor: context.colors.mantle,
        leading: Padding(
          padding: const .symmetric(vertical: 6),
          child: Images.logo,
        ),
        title: Text(t.routes.startup.setup.app_bar),
        toolbarHeight: 60,
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
                label: t.username.toUpperCase(),
                hintText: "peppa.pig",
                textController: _usernameController,
                onSubmitted: (_) => _passwordFocus.requestFocus(),
              ),
              FlixurInput(
                label: t.password.toUpperCase(),
                hintText: "*" * 12,
                errorText: errorText,
                textController: _passwordController,
                onSubmitted: (_) => _completeSetup(),
                focusNode: _passwordFocus,
                obscureText: true,
              ),
              StartupButton(
                text: t.routes.startup.setup.complete,
                isLoading: isPasswordLoading,
                // disable button if OIDC is loading
                onPressed: isOidcLoading ? null : _completeSetup,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _setError(String? text) {
    setState(() => errorText = text);
  }

  Future<void> _completeSetup() async {
    if (isPasswordLoading || isOidcLoading || api == null) return;
    _setError(null);

    setState(() => isPasswordLoading = true);
  }
}
