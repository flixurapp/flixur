import "package:flixur/gen/strings.g.dart";
import "package:flixur/ui/inputs.dart";
import "package:flixur/ui/responsiveness.dart";
import "package:flixur/ui/theme.dart";
import "package:flutter/material.dart";

class ServerUrlView extends StatefulWidget {
  const ServerUrlView({super.key});

  @override
  State<ServerUrlView> createState() => _ServerUrlViewState();
}

class _ServerUrlViewState extends State<ServerUrlView> {
  final _serverUrlController = TextEditingController();

  String? errorText;

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
                    child: Image.asset("assets/logo.png", fit: .contain),
                  ),
                  Text(
                    t.pages.login.welcome,
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
                      label: t.pages.login.server_url.toUpperCase(),
                      hintText: "https://demo.flixur.app",
                      errorText: errorText,
                      textController: _serverUrlController,
                      onSubmitted: (_) => _serverUrlSubmit(),
                    ),
                    FilledButton(
                      onPressed: _serverUrlSubmit,
                      style: .new(
                        padding: .all(const .symmetric(vertical: 18)),
                        textStyle: .all(
                          const .new(fontSize: 24, fontWeight: .w500),
                        ),
                      ),
                      child: Text(t.pages.login.connect.toUpperCase()),
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
    setServerUrlError(null);
    final serverUrl = Uri.tryParse(_serverUrlController.text);
    if (serverUrl == null ||
        // must be an HTTP url
        (serverUrl.scheme != "http" && serverUrl.scheme != "https") ||
        // and have a host
        serverUrl.authority == "") {
      setServerUrlError(t.pages.login.server_url_error);
      return;
    }
  }
}
