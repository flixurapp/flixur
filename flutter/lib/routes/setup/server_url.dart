import "package:flixur/routes/setup/components.dart";
import "package:flixur/ui/inputs.dart";
import "package:flixur/utils.dart";
import "package:flutter/material.dart";
import "package:openapi/api.dart";

class ServerUrlView extends StatefulWidget {
  const ServerUrlView({super.key});

  @override
  State<ServerUrlView> createState() => _ServerUrlViewState();
}

class _ServerUrlViewState extends State<ServerUrlView> {
  final _serverUrlController = TextEditingController();

  String? errorText;
  bool isLoading = false;

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
                    t.routes.setup.server_url.welcome,
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
                      label: t.routes.setup.server_url.url.toUpperCase(),
                      hintText: "https://demo.flixur.app",
                      errorText: errorText,
                      textController: _serverUrlController,
                      onSubmitted: (_) => _serverUrlSubmit(),
                    ),
                    SetupButton(
                      text: t.routes.setup.server_url.connect,
                      isLoading: isLoading,
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

  void setServerUrlError(String? text) {
    setState(() => errorText = text);
  }

  Future<void> _serverUrlSubmit() async {
    if (isLoading) return;

    setServerUrlError(null);
    final serverUrl = Uri.tryParse(_serverUrlController.text);
    if (serverUrl == null ||
        // must be an HTTP url
        (serverUrl.scheme != "http" && serverUrl.scheme != "https") ||
        // and have a host
        serverUrl.authority == "") {
      setServerUrlError(t.routes.setup.server_url.url_error);
      return;
    }

    final apiClient = ApiClient(
      // append the `api` path to the URL
      basePath: serverUrl
          .replace(
            pathSegments: [...serverUrl.pathSegments, "api"],
          )
          .toString(),
    );
    final api = AuthenticationApi(apiClient);

    setState(() => isLoading = true);
    final pingResponse = await safeGet(api.ping);
    if (!mounted) return;
    setState(() => isLoading = false);

    switch (pingResponse) {
      case ApiSuccess(:final data):
        if (data.isSetup) {
          context.go(
            "/setup/login",
            extra: ServerLoginPayload(url: apiClient.basePath, body: data),
          );
        } else {
          //TODO: setup screen
        }
      case ApiFailure(:final err):
        setServerUrlError(
          err.message ?? t.routes.setup.server_url.server_ping_error,
        );
    }
  }
}

class ServerLoginPayload {
  ServerLoginPayload({required this.url, required this.body});

  // Full basePath of the api client.
  final String url;
  // Server ping response body.
  final PingOutputBody body;
}
