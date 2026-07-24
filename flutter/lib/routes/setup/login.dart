import "package:flixur/routes/setup/components.dart";
import "package:flixur/routes/setup/server_url.dart";
import "package:flixur/ui/inputs.dart";
import "package:flixur/utils.dart";
import "package:flutter/material.dart";
import "package:openapi/api.dart";

class LoginView extends StatefulWidget {
  const LoginView({required this.serverInfo, super.key});

  final ServerLoginPayload serverInfo;

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
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
        title: Text(t.routes.setup.login.login),
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
              if (serverResponseBody.supportsPasswordLogin) ...[
                FlixurInput(
                  label: t.routes.setup.login.username.toUpperCase(),
                  hintText: "peppa.pig",
                  textController: _usernameController,
                  onSubmitted: (_) => _passwordFocus.requestFocus(),
                ),
                FlixurInput(
                  label: t.routes.setup.login.password.toUpperCase(),
                  hintText: "*" * 12,
                  errorText: errorText,
                  textController: _passwordController,
                  onSubmitted: (_) => _passwordSubmit(),
                  focusNode: _passwordFocus,
                  obscureText: true,
                ),
                SetupButton(
                  text: t.routes.setup.login.login,
                  isLoading: isPasswordLoading,
                  // disable button if OIDC is loading
                  onPressed: isOidcLoading ? null : _passwordSubmit,
                ),
              ],
              // only show the "OR" line if both methods are allowed
              if (serverResponseBody.supportsPasswordLogin &&
                  serverResponseBody.supportsOIDCLogin != "")
                const OrLine(),
              if (serverResponseBody.supportsOIDCLogin != "")
                SetupButton(
                  text: serverResponseBody.supportsOIDCLogin,
                  isLoading: isOidcLoading,
                  onPressed: isPasswordLoading ? null : _oidcSubmit,
                ),
            ],
          ),
        ),
      ),
    );
  }

  void setLoginError(String? text) {
    setState(() => errorText = text);
  }

  Future<void> _passwordSubmit() async {
    if (isPasswordLoading || isOidcLoading || api == null) return;

    setState(() => isPasswordLoading = true);
  }

  Future<void> _oidcSubmit() async {
    if (isOidcLoading || isPasswordLoading || api == null) return;

    setState(() => isOidcLoading = true);
  }
}
