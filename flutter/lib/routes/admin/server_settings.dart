import "dart:async";

import "package:collection/collection.dart";
import "package:flixur/api.dart";
import "package:flixur/settings.dart";
import "package:flixur/ui/settings/values.dart";
import "package:flixur/utils.dart";
import "package:flutter/widgets.dart";
import "package:openapi/openapi.dart";

/// Server-scoped settings store for the admin page.
class ServerSettingsValues extends SettingsValues {
  final StreamController<List<String>> _changes =
      StreamController<List<String>>.broadcast();

  /// Amount of settings currently being pushed to the server.
  final ValueNotifier<int> pushing = ValueNotifier(0);

  /// Whether a fetch of definitions/values is in progress.
  final ValueNotifier<bool> loading = ValueNotifier(false);

  /// Message of the last failed fetch, if any.
  final ValueNotifier<String?> loadError = ValueNotifier(null);

  /// Message of the last failed write, if any.
  final ValueNotifier<String?> writeError = ValueNotifier(null);

  final Map<String, String> _values = {};

  List<SettingsDefinition> _definitions = const [];
  @override
  List<SettingsDefinition> get definitions => _definitions;

  List<SettingsGroup> _groups = const [];
  @override
  List<SettingsGroup> get groups => _groups;

  @override
  bool get isServer => true;

  @override
  T? get<T>(String id) {
    final def = _definition(id);
    if (def == null) return null;
    final encoded = _values[id];
    if (encoded != null) return decodeSettingValue<T>(def, encoded);
    return def.typedDefault<T>();
  }

  @override
  Future<bool> set<T>(String id, T value) async {
    final def = _definition(id);
    if (def == null) return false;

    final encoded = encodeSettingValue<T>(def, value);

    // update locally first
    final previous = _values[id];
    _values[id] = encoded;
    _changes.add([id]);

    pushing.value++;
    final response = await Api.request(
      (a) => a.getSettingsApi().updateServerSettingValue(
        settingID: id,
        updateServerSettingValueRequest: .new((b) => b.value = encoded),
      ),
    );
    pushing.value--;

    switch (response) {
      case ApiSuccess(:final data):
        // keep server-validated value
        _values[id] = data.value;
        _changes.add([id]);
        return true;
      case ApiFailure(:final message):
        // revert local update
        if (previous == null) {
          _values.remove(id);
        } else {
          _values[id] = previous;
        }
        _changes.add([id]);
        writeError.value = message;
        return false;
    }
  }

  @override
  Stream<List<String>> get changes => _changes.stream;

  /// Fetches definitions and values from the server.
  Future<void> load() async {
    loading.value = true;
    loadError.value = null;
    try {
      final defsResult = await Api.request(
        (a) => a.getSettingsApi().getServerSettingsDefinitions(),
      );
      switch (defsResult) {
        case ApiSuccess(:final data):
          _definitions = data.list.toList();
          _groups = data.groups.toList();
        case ApiFailure(:final message):
          loadError.value = message;
          return;
      }

      final valuesResult = await Api.request(
        (a) => a.getSettingsApi().getServerSettingsValues(),
      );
      switch (valuesResult) {
        case ApiSuccess(:final data):
          _values
            ..clear()
            ..addAll({
              for (final entry in data.values.entries)
                entry.key: entry.value.value,
            });
        case ApiFailure(:final message):
          loadError.value = message;
          return;
      }

      _changes.add(const []);
    } finally {
      loading.value = false;
    }
  }

  /// The definition for [id], null if unknown.
  SettingsDefinition? _definition(String id) =>
      _definitions.firstWhereOrNull((item) => item.id == id);
}
