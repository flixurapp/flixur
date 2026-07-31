import "package:flixur/api.dart";
import "package:flixur/routes/startup/components.dart";
import "package:flixur/routes/startup/server_url.dart";
import "package:flixur/storage.dart";
import "package:flixur/ui/dialogs.dart";
import "package:flixur/ui/inputs.dart";
import "package:flixur/utils.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:openapi/openapi.dart";

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
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "${t.routes.startup.setup.body}\n"
                        "${t.routes.startup.setup.code_info}",
                        style: .new(color: context.colors.onSecondary),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              FlixurInput(
                label: t.routes.startup.setup.code.toUpperCase(),
                textField: (deco) => TextField(
                  decoration: deco.copyWith(
                    hintText: "X" * 6,
                  ),
                  controller: _codeController,
                  onSubmitted: (_) => _usernameFocus.requestFocus(),
                  maxLength: 6,
                ),
              ),
              FlixurInput(
                label: t.username.toUpperCase(),
                textField: (deco) => TextField(
                  decoration: deco.copyWith(hintText: "peppa.pig"),
                  controller: _usernameController,
                  onSubmitted: (_) => _passwordFocus.requestFocus(),
                  focusNode: _usernameFocus,
                  maxLength: 64,
                ),
              ),
              FlixurInput(
                label: t.password.toUpperCase(),
                textField: (deco) => TextField(
                  decoration: deco.copyWith(
                    hintText: "*" * 12,
                  ),
                  controller: _passwordController,
                  onSubmitted: (_) => _completeSetup(),
                  focusNode: _passwordFocus,
                  obscureText: true,
                  maxLength: 72,
                ),
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
    if (_isLoading) return;

    setState(() => _isLoading = true);

    final response = await Api.request(
      (a) => a.getAuthenticationApi().postAuthSetup(
        postAuthSetupRequest: PostAuthSetupRequest(
          (b) => b
            ..code = _codeController.text
            ..password = _passwordController.text
            ..username = _usernameController.text,
        ),
        xPlatformClient: AppInfo.clientIdentifier,
        xPlatformDevice: AppInfo.deviceName,
        xPlatformOS: AppInfo.deviceOS,
      ),
    );
    setState(() => _isLoading = false);
    if (!mounted) return;

    switch (response) {
      case ApiSuccess(:final data):
        try {
          await Storage.setServerUrl(widget.serverInfo.url);
          await Storage.setSessionToken(data.sessionToken);
        } on PlatformException catch (e) {
          if (!mounted) return;
          await showErrorDialog(
            context,
            title: t.storage.store_fail_title,
            message: e.message ?? t.storage.store_fail,
          );
          return;
        }
        if (!mounted) return;
        // save was successful, so continue
        context.goNamed("home");
      case ApiFailure(:final err, :final message):
        await showErrorDialog(
          context,
          title: t.routes.startup.setup.failed,
          message: t.routes.startup.setup.failed_codes[err?.key] ?? message,
        );
    }
  }
}
