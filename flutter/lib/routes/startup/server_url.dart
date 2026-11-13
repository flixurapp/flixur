import "package:flixur/api.dart";
import "package:flixur/routes/startup/components.dart";
import "package:flixur/storage.dart";
import "package:flixur/titlebar.dart";
import "package:flixur/ui/inputs.dart";
import "package:flixur/utils.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:material_ui/material_ui.dart";
import "package:openapi/openapi.dart";

class const ServerUrlView({super.key}) extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final serverUrlController = useTextEditingController(
      text: Storage.get(.serverUrl),
    );
    final errorText = useState<String?>(null);
    final isLoading = useState(false);

    Future<void> submit() async {
      if (isLoading.value) return;

      errorText.value = null;
      var serverUrl = Uri.tryParse(serverUrlController.text);
      if (serverUrl == null ||
          // must be an HTTP url
          (serverUrl.scheme != "http" && serverUrl.scheme != "https") ||
          // and have a host
          serverUrl.authority == "") {
        errorText.value = t.routes.startup.server_url.url_error;
        return;
      }

      //TODO: maybe dont hardcode this eventually?
      const apiPath = "api";

      // append the `api` path to the URL
      if (serverUrl.pathSegments.lastOrNull?.endsWith(apiPath) != true) {
        serverUrl = serverUrl.replace(
          pathSegments: [...serverUrl.pathSegments, apiPath],
        );
      }
      final finalServerUrl = serverUrl.toString();
      // we aren't going through `Storage` here since we don't want to persist
      // an incorrect value
      Api.setBaseUrl(finalServerUrl);

      isLoading.value = true;
      final pingResponse = await Api.request(
        (a) => a.getAuthenticationApi().getPing(),
      );
      if (!context.mounted) return;
      isLoading.value = false;

      switch (pingResponse) {
        case ApiSuccess(:final data):
          await Storage.put(.serverUrl, finalServerUrl);
          if (!context.mounted) return;
          context.goNamed(
            data.isSetup ? "startup_login" : "startup_setup",
            extra: ServerLoginPayload(url: finalServerUrl, body: data),
          );
        case ApiFailure(:final message):
          errorText.value = message;
      }
    }

    final welcomeText = Text(
      t.routes.startup.server_url.welcome,
      style: const TextStyle(fontSize: 56),
    );

    final logo = ConstrainedBox(
      constraints: BoxConstraints(
        // sane sizing for logo depending on screen size
        maxWidth: context.screenSize.width * (context.isLandscape ? 0.4 : 0.8),
        maxHeight:
            context.screenSize.height * (context.isLandscape ? 0.4 : 0.3),
      ),
      child: Images.logo,
    );

    final input = FractionallySizedBox(
      widthFactor: context.isLandscape ? 0.8 : 1,
      child: Column(
        mainAxisAlignment: .center,
        crossAxisAlignment: .stretch,
        spacing: 14,
        children: [
          FlixurInput(
            label: t.routes.startup.server_url.url.toUpperCase(),
            errorText: errorText.value,
            textField: (deco) => TextField(
              decoration: deco.copyWith(hintText: "https://demo.flixur.app"),
              controller: serverUrlController,
              onSubmitted: (_) => submit(),
            ),
          ),
          StartupButton(
            text: t.routes.startup.server_url.connect,
            isLoading: isLoading.value,
            onPressed: submit,
          ),
        ],
      ),
    );

    return PageTitle(
      t.routes.startup.server_url.welcome,
      child: StartupBody(
        backgroundColor: context.colors.mantle,
        child: context.isLandscape
            ? Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: .center,
                      spacing: 16,
                      children: [logo, welcomeText],
                    ),
                  ),
                  Expanded(child: input),
                ],
              )
            : Column(
                mainAxisAlignment: .center,
                spacing: 16,
                children: [logo, welcomeText, input],
              ),
      ),
    );
  }
}

class ServerLoginPayload({
  /// Full basePath of the api client.
  required final String url,

  /// Server ping response body.
  required final PingBody body,
});
