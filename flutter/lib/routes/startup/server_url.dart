import "package:flixur/api.dart";
import "package:flixur/routes/startup/components.dart";
import "package:flixur/storage.dart";
import "package:flixur/ui/inputs.dart";
import "package:flixur/utils.dart";
import "package:flutter/material.dart";
import "package:openapi/openapi.dart";

class ServerUrlView extends StatefulWidget {
  const ServerUrlView({super.key});

  @override
  State<ServerUrlView> createState() => _ServerUrlViewState();
}

class _ServerUrlViewState extends State<ServerUrlView> {
  final _serverUrlController = TextEditingController(
    text: Storage.serverUrl.value,
  );

  String? _errorText;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.mantle,
      body: Center(
        child: Flex(
          direction: context.isLandscape ? .horizontal : .vertical,
          mainAxisAlignment: .center,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: .center,
                spacing: 16,
                children: [
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      // sane sizing for logo depending on screen size
                      maxWidth:
                          context.screenSize.width *
                          (context.isLandscape ? 0.4 : 0.8),
                      maxHeight:
                          context.screenSize.height *
                          (context.isLandscape ? 0.4 : 0.3),
                    ),
                    child: Images.logo,
                  ),
                  Text(
                    t.routes.startup.server_url.welcome,
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
                      label: t.routes.startup.server_url.url.toUpperCase(),
                      errorText: _errorText,
                      textField: (deco) => TextField(
                        decoration: deco.copyWith(
                          hintText: "https://demo.flixur.app",
                        ),
                        controller: _serverUrlController,
                        onSubmitted: (_) => _serverUrlSubmit(),
                      ),
                    ),
                    StartupButton(
                      text: t.routes.startup.server_url.connect,
                      isLoading: _isLoading,
                      onPressed: _serverUrlSubmit,
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

  void _setServerUrlError(String? text) {
    setState(() => _errorText = text);
  }

  Future<void> _serverUrlSubmit() async {
    if (_isLoading) return;

    _setServerUrlError(null);
    var serverUrl = Uri.tryParse(_serverUrlController.text);
    if (serverUrl == null ||
        // must be an HTTP url
        (serverUrl.scheme != "http" && serverUrl.scheme != "https") ||
        // and have a host
        serverUrl.authority == "") {
      _setServerUrlError(t.routes.startup.server_url.url_error);
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

    setState(() => _isLoading = true);
    final pingResponse = await Api.request(
      (a) => a.getAuthenticationApi().getPing(),
    );
    if (!mounted) return;
    setState(() => _isLoading = false);

    switch (pingResponse) {
      case ApiSuccess(:final data):
        await Storage.setServerUrl(finalServerUrl);
        if (!mounted) return;
        context.goNamed(
          data.isSetup ? "startup_login" : "startup_setup",
          extra: ServerLoginPayload(
            url: finalServerUrl,
            body: data,
          ),
        );
      case ApiFailure(:final message):
        _setServerUrlError(message);
    }
  }
}

class ServerLoginPayload {
  ServerLoginPayload({required this.url, required this.body});

  // Full basePath of the api client.
  final String url;
  // Server ping response body.
  final PingBody body;
}
