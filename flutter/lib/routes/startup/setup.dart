import "package:flixur/api.dart";
import "package:flixur/routes/startup/components.dart";
import "package:flixur/routes/startup/server_url.dart";
import "package:flixur/storage.dart";
import "package:flixur/titlebar.dart";
import "package:flixur/ui/dialogs.dart";
import "package:flixur/ui/icons.dart";
import "package:flixur/ui/inputs.dart";
import "package:flixur/utils.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:material_ui/material_ui.dart";
import "package:openapi/openapi.dart";

class const SetupView({required final ServerLoginPayload serverInfo, super.key})
    extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final codeController = useTextEditingController();
    final usernameController = useTextEditingController();
    final passwordController = useTextEditingController();
    final usernameFocus = useFocusNode();
    final passwordFocus = useFocusNode();
    final isLoading = useState(false);

    Future<void> completeSetup() async {
      if (isLoading.value) return;

      isLoading.value = true;

      final response = await Api.request(
        (a) => a.getAuthenticationApi().postAuthSetup(
          postAuthSetupRequest: PostAuthSetupRequest(
            (b) => b
              ..code = codeController.text
              ..password = passwordController.text
              ..username = usernameController.text,
          ),
          xPlatformClient: AppInfo.clientIdentifier,
          xPlatformDevice: AppInfo.deviceName,
          xPlatformOS: AppInfo.deviceOS,
        ),
      );
      if (!context.mounted) return;
      isLoading.value = false;

      switch (response) {
        case ApiSuccess(:final data):
          await Storage.put(.serverUrl, serverInfo.url);
          await Storage.put(.sessionToken, data.sessionToken);
          if (!context.mounted) return;
          // save was successful, so continue
          context.goNamed("home");
        case ApiFailure(:final translated):
          await showErrorDialog(
            context,
            title: t.routes.startup.setup.failed,
            message: translated(t.routes.startup.setup.failed_codes),
          );
      }
    }

    return PageTitle(
      t.routes.startup.setup.title,
      child: StartupBody(
        backgroundColor: context.colors.base,
        child: FractionallySizedBox(
          widthFactor: context.isLandscape ? 0.8 : 1,
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
                    Iconify(
                      "info-bold",
                      color: context.colors.onSecondary,
                      size: 32,
                    ),
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
                  decoration: deco.copyWith(hintText: "X" * 6),
                  controller: codeController,
                  onSubmitted: (_) => usernameFocus.requestFocus(),
                  maxLength: 6,
                ),
              ),
              FlixurInput(
                label: t.username.toUpperCase(),
                textField: (deco) => TextField(
                  decoration: deco.copyWith(hintText: "peppa.pig"),
                  controller: usernameController,
                  onSubmitted: (_) => passwordFocus.requestFocus(),
                  focusNode: usernameFocus,
                  maxLength: 64,
                ),
              ),
              FlixurInput(
                label: t.password.toUpperCase(),
                textField: (deco) => TextField(
                  decoration: deco.copyWith(hintText: "*" * 12),
                  controller: passwordController,
                  onSubmitted: (_) => completeSetup(),
                  focusNode: passwordFocus,
                  obscureText: true,
                  maxLength: 72,
                ),
              ),
              StartupButton(
                text: t.routes.startup.setup.complete,
                isLoading: isLoading.value,
                onPressed: completeSetup,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
