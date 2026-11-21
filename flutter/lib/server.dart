import "package:flixur/api.dart";
import "package:openapi/openapi.dart";

/// Server state pulled from the server.
abstract final class ServerState {
  /// List of all plugins installed on the server.
  static List<PluginManifest>? plugins;

  static Future<void> init() async {
    if (!Api.canMakeAuthenticatedRequests) return;

    switch (await Api.request((a) => a.getManagementApi().listPlugins())) {
      case ApiSuccess(:final data):
        plugins = data.list.toList();
      case ApiFailure():
        plugins = null;
    }
  }

  static void clear() {
    plugins = null;
  }
}
