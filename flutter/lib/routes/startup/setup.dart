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
  final _codeController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameFocus = FocusNode();
  final _passwordFocus = FocusNode();

  AuthenticationApi? _api;
  @override
  void initState() {
    super.initState();
    _api = AuthenticationApi(ApiClient(basePath: widget.serverInfo.url));
  }

  String? _codeError;
  String? _usernameError;
  String? _passwordError;
  bool _isLoading = false;

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
              Container(
                padding: const .all(12),
                decoration: BoxDecoration(
                  color: context.colors.secondary.withValues(alpha: 0.6),
                  border: .all(color: context.colors.secondary),
                  borderRadius: .circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: context.colors.onSecondary),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        t.routes.startup.setup.code_info,
                        style: .new(color: context.colors.onSecondary),
                      ),
                    ),
                  ],
                ),
              ),
              FlixurInput(
                label: t.routes.startup.setup.code.toUpperCase(),
                hintText: "X" * 6,
                errorText: _codeError,
                textController: _codeController,
                onSubmitted: (_) => _usernameFocus.requestFocus(),
              ),
              FlixurInput(
                label: t.username.toUpperCase(),
                hintText: "peppa.pig",
                errorText: _usernameError,
                textController: _usernameController,
                onSubmitted: (_) => _passwordFocus.requestFocus(),
                focusNode: _usernameFocus,
              ),
              FlixurInput(
                label: t.password.toUpperCase(),
                hintText: "*" * 12,
                errorText: _passwordError,
                textController: _passwordController,
                onSubmitted: (_) => _completeSetup(),
                focusNode: _passwordFocus,
                obscureText: true,
              ),
              StartupButton(
                text: t.routes.startup.setup.complete,
                isLoading: _isLoading,
                onPressed: _completeSetup,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _completeSetup() async {
    final api = _api;
    if (_isLoading || api == null) return;

    setState(() {
      _usernameError = _passwordError = null;
      _isLoading = true;
    });

    final response = await safeGet(
      () => api.setup(
        AppInfo.clientIdentifier,
        AppInfo.deviceName,
        AppInfo.deviceOS,
        SetupRequest(
          code: _codeController.text,
          password: _passwordController.text,
          username: _usernameController.text,
        ),
      ),
    );
  }
}
