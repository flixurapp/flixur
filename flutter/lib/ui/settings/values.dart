import "dart:async";
import "dart:convert";

import "package:flixur/hooks.dart" show useSettings;
import "package:flixur/settings.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:openapi/openapi.dart";

/// The shared client settings store.
final clientSettingsValues = ClientSettingsValues();

/// Central [SettingsDefinition] management interface.
abstract class SettingsValues {
  /// All setting definitions to display.
  List<SettingsDefinition> get definitions;

  /// All setting groups to display.
  List<SettingsGroup> get groups;

  /// Reads a setting value by ID. Null when the setting is unknown.
  T? get<T>(String id);

  /// Always returns a value for a setting, even if it's not found.
  T getValue<T>(String id) => get<T>(id) ?? fallbackTypeValue<T>();

  /// Writes a typed value for a setting. Returns a boolean indicating success.
  Future<bool> set<T>(String id, T value);

  /// Whether these settings are server-scoped for translations.
  bool get isServer;

  /// Broadcast of changed setting IDs. An empty list means all settings.
  Stream<List<String>> get changes;
}

/// [SettingsValues] using the client [Settings] manager.
class ClientSettingsValues extends SettingsValues {
  @override
  List<SettingsDefinition> get definitions => Settings.definitions ?? const [];

  @override
  List<SettingsGroup> get groups => Settings.groups ?? const [];

  @override
  T? get<T>(String id) => Settings.get<T>(id);

  @override
  Future<bool> set<T>(String id, T value) => Settings.set<T>(id, value);

  @override
  bool get isServer => false;

  @override
  Stream<List<String>> get changes =>
      Settings.watch(const []).map((event) => event.ids);
}

/// Rebuilds the calling HookWidget when any [ids] change in [values].
/// See [useSettings]
int useSettingsChanges(SettingsValues values, [List<String> ids = const []]) {
  final revision = useState(0);
  final key = ids.join(",");
  useEffect(() {
    return values.changes
        .where(
          (event) => ids.isEmpty || event.isEmpty || event.any(ids.contains),
        )
        .listen((_) => revision.value++)
        .cancel;
  }, [values, key]);
  return revision.value;
}

/// Decodes a JSON-encoded value text into the setting's type.
T? decodeSettingValue<T>(SettingsDefinition def, String text) {
  final value = switch (def.kind) {
    .bool_ => jsonDecode(text) as bool,
    .int_ => (jsonDecode(text) as num).toInt(),
    .float => (jsonDecode(text) as num).toDouble(),
    .string || .enum_ => jsonDecode(text) as String,
    .stringlist => [
      for (final item in jsonDecode(text) as List) item as String,
    ],
    _ => null,
  };
  return value is T ? value : null;
}

/// Encodes a typed value into the setting's JSON value string.
String encodeSettingValue<T>(SettingsDefinition def, T value) =>
    switch (def.kind) {
      .bool_ => jsonEncode(value as bool),
      .int_ => jsonEncode(value as num),
      .float => jsonEncode(value as num),
      .string || .enum_ => jsonEncode(value as String),
      .stringlist => jsonEncode((value as List<String>).toList()),
      _ => jsonEncode(value),
    };

/// Returns a fallback value for the given setting dart type.
T fallbackTypeValue<T>() {
  if (T == bool) return false as T;
  if (T == int) return 0 as T;
  if (T == double) return 0.0 as T;
  if (T == String) return "" as T;
  if (T == List<String>) return List<String>.empty() as T;
  throw UnsupportedError("no default value for the type $T");
}
