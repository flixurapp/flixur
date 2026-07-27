import "package:flixur/routes/startup/components.dart";
import "package:flixur/routes/startup/server_url.dart";
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

  PingOutputBody get _serverResponseBody => widget.serverInfo.body;

  AuthenticationApi? _api;
  @override
  void initState() {
    super.initState();
    _api = AuthenticationApi(ApiClient(basePath: widget.serverInfo.url));
  }

  String? _usernameError;
  String? _passwordError;
  bool _isPasswordLoading = false;
  bool _isOidcLoading = false;

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
        title: Text(t.routes.startup.login.app_bar),
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
              if (_serverResponseBody.supportsPasswordLogin) ...[
                FlixurInput(
                  label: t.username.toUpperCase(),
                  hintText: "peppa.pig",
                  errorText: _usernameError,
                  textController: _usernameController,
                  onSubmitted: (_) => _passwordFocus.requestFocus(),
                ),
                FlixurInput(
                  label: t.password.toUpperCase(),
                  hintText: "*" * 12,
                  errorText: _passwordError,
                  textController: _passwordController,
                  onSubmitted: (_) => _passwordSubmit(),
                  focusNode: _passwordFocus,
                  obscureText: true,
                ),
                StartupButton(
                  text: t.routes.startup.login.login,
                  isLoading: _isPasswordLoading,
                  // disable button if OIDC is loading
                  onPressed: _isOidcLoading ? null : _passwordSubmit,
                ),
              ],
              // only show the "OR" line if both methods are allowed
              if (_serverResponseBody.supportsPasswordLogin &&
                  _serverResponseBody.supportsOIDCLogin != "")
                const OrLine(),
              if (_serverResponseBody.supportsOIDCLogin != "")
                StartupButton(
                  text: _serverResponseBody.supportsOIDCLogin,
                  isLoading: _isOidcLoading,
                  onPressed: _isPasswordLoading ? null : _oidcSubmit,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _passwordSubmit() async {
    if (_isPasswordLoading || _isOidcLoading || _api == null) return;

    setState(() {
      _usernameError = _passwordError = null;
      _isPasswordLoading = true;
    });
  }

  Future<void> _oidcSubmit() async {
    if (_isOidcLoading || _isPasswordLoading || _api == null) return;

    setState(() => _isOidcLoading = true);
  }
}
