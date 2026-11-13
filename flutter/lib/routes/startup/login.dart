import "package:flixur/api.dart";
import "package:flixur/routes/startup/components.dart";
import "package:flixur/routes/startup/server_url.dart";
import "package:flixur/storage.dart";
import "package:flixur/titlebar.dart";
import "package:flixur/ui/dialogs.dart";
import "package:flixur/ui/inputs.dart";
import "package:flixur/utils.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:material_ui/material_ui.dart";
import "package:openapi/openapi.dart";

class const LoginView({required final ServerLoginPayload serverInfo, super.key})
    extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final usernameController = useTextEditingController();
    final passwordController = useTextEditingController();
    final passwordFocus = useFocusNode();
    final usernameError = useState<String?>(null);
    final passwordError = useState<String?>(null);
    final isPasswordLoading = useState(false);
    final isOidcLoading = useState(false);

    final serverResponseBody = serverInfo.body;

    Future<void> passwordSubmit() async {
      if (isPasswordLoading.value || isOidcLoading.value) return;

      usernameError.value = passwordError.value = null;
      isPasswordLoading.value = true;

      final response = await Api.request(
        (a) => a.getAuthenticationApi().postAuthLogin(
          postAuthLoginRequest: PostAuthLoginRequest(
            (b) => b
              ..username = usernameController.text
              ..password = passwordController.text,
          ),
          xPlatformClient: AppInfo.clientIdentifier,
          xPlatformDevice: AppInfo.deviceName,
          xPlatformOS: AppInfo.deviceOS,
        ),
      );
      if (!context.mounted) return;
      isPasswordLoading.value = false;

      switch (response) {
        case ApiSuccess(:final data):
          await Storage.put(.sessionToken, data.sessionToken);
          if (!context.mounted) return;
          context.goNamed("home");
        case ApiFailure(:final translated):
          await showErrorDialog(
            context,
            title: t.routes.startup.login.failed,
            message: translated(t.routes.startup.login.failed_codes),
          );
      }
    }

    Future<void> oidcSubmit() async {
      if (isOidcLoading.value || isPasswordLoading.value) return;

      isOidcLoading.value = true;
    }

    return PageTitle(
      t.routes.startup.login.title,
      child: StartupBody(
        backgroundColor: context.colors.base,
        child: FractionallySizedBox(
          widthFactor: context.isLandscape ? 0.8 : 1,
          child: Column(
            mainAxisAlignment: .center,
            crossAxisAlignment: .stretch,
            spacing: 14,
            children: [
              if (serverResponseBody.supportsPasswordLogin) ...[
                FlixurInput(
                  label: t.username.toUpperCase(),
                  errorText: usernameError.value,
                  textField: (deco) => TextField(
                    decoration: deco.copyWith(hintText: "peppa.pig"),
                    controller: usernameController,
                    onSubmitted: (_) => passwordFocus.requestFocus(),
                  ),
                ),
                FlixurInput(
                  label: t.password.toUpperCase(),
                  errorText: passwordError.value,
                  textField: (deco) => TextField(
                    decoration: deco.copyWith(hintText: "*" * 12),
                    controller: passwordController,
                    onSubmitted: (_) => passwordSubmit(),
                    focusNode: passwordFocus,
                    obscureText: true,
                  ),
                ),
                StartupButton(
                  text: t.routes.startup.login.login,
                  isLoading: isPasswordLoading.value,
                  // disable button if OIDC is loading
                  onPressed: isOidcLoading.value ? null : passwordSubmit,
                ),
              ],
              // only show the "OR" line if both methods are allowed
              if (serverResponseBody.supportsPasswordLogin &&
                  serverResponseBody.supportsOIDCLogin != "")
                const OrLine(),
              if (serverResponseBody.supportsOIDCLogin != "")
                StartupButton(
                  text: serverResponseBody.supportsOIDCLogin,
                  isLoading: isOidcLoading.value,
                  onPressed: isPasswordLoading.value ? null : oidcSubmit,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
