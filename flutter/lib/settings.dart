import "dart:async";
import "dart:convert";
import "dart:math";
import "dart:ui";

import "package:flixur/api.dart";
import "package:flixur/gen/strings.g.dart";
import "package:flixur/hooks.dart";
import "package:flixur/storage.dart";
import "package:flutter/widgets.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:fuse_dart/fuse_dart.dart";
import "package:hive_ce_flutter/hive_ce_flutter.dart";
import "package:openapi/openapi.dart";

// storage keys
const _definitionsKey = "cached_definitions";
const _groupsKey = "cached_groups";
const _profilesKey = "cached_profiles";
const _activeProfileKey = "active_profile";
const _pendingItemsKey = "pending_sync";
const _valuesDelimiter = r"$";

/// A setting change that is pending a sync with the server.
class SettingsPendingPushItem({
  required final String profileID,
  required final String settingID,
  required final String value,
  required final DateTime updatedAt,
});

abstract class Settings {
  /// All settings definitions provided by the server.
  static List<SettingsDefinition>? definitions;

  /// All setting groups provided by the server.
  static List<SettingsGroup>? groups;

  /// All settings profiles of the user.
  static List<SettingProfileBody>? profiles;

  /// Currently selected settings profile.
  static String? activeProfileID;

  /// Setting overrides for the active profile. Values are the encoded JSON.
  static Map<String, String>? overrides;

  /// Broadcast stream of settings changes.
  static final StreamController<SettingsChange> _changes =
      StreamController<SettingsChange>.broadcast();

  /// Current server sync state, for status indicators.
  static final ValueNotifier<SettingsSyncState> syncState = ValueNotifier(
    const SyncIdle(),
  );

  /// Listens for changes affecting the given setting IDs.
  /// An empty [ids] listens to all settings.
  static Stream<SettingsChange> watch(List<String> ids) {
    if (ids.isEmpty) return _changes.stream;
    return _changes.stream.where(
      (event) => event.ids.isEmpty || event.ids.any(ids.contains),
    );
  }

  /// Get a definition by ID.
  static SettingsDefinition? definition(String id) =>
      definitions?.where((item) => item.id == id).firstOrNull;

  /// Get a profile by ID.
  static SettingProfileBody? profile(String id) =>
      profiles?.where((item) => item.id == id).firstOrNull;

  /// Hive box to store settings/data.
  static late Box<dynamic> _box;

  /// Map of stored setting values, keyed by profile and then setting ID.
  static final Map<String, Map<String, SettingValueEntry>> _storedValues = {};
  static final List<SettingsPendingPushItem> _pendingItems = [];

  static Future<void> init() async {
    // load all of the cached data from storage
    _box = await Hive.openBox("settings");

    // definitions
    final storedDefinitions = _box.get(_definitionsKey) as List?;
    if (storedDefinitions != null) {
      definitions = List<SettingsDefinition>.from(storedDefinitions);
    }

    // groups
    final storedGroups = _box.get(_groupsKey) as List?;
    if (storedGroups != null) {
      groups = List<SettingsGroup>.from(storedGroups);
    }

    // profiles
    final storedProfiles = _box.get(_profilesKey) as List?;
    if (storedProfiles != null) {
      profiles = List<SettingProfileBody>.from(storedProfiles);
    }

    activeProfileID = _box.get(_activeProfileKey) as String?;

    // pending sync items
    final storedPending = _box.get(_pendingItemsKey) as List?;
    if (storedPending != null) {
      _pendingItems.addAll(List<SettingsPendingPushItem>.from(storedPending));
    }

    // load stored setting values
    for (final key in _box.keys) {
      if (key is! String || !key.startsWith(_valuesDelimiter)) continue;
      // extract IDs from key
      final profileID = key.substring(
        _valuesDelimiter.length,
        key.indexOf(_valuesDelimiter, _valuesDelimiter.length),
      );
      final settingID = key.substring(
        _valuesDelimiter.length * 2 + profileID.length,
      );
      // get value
      final value = await _box.get(key);
      if (value is! SettingValueEntry) continue;
      // store the value in memory
      _storedValues[profileID] ??= {};
      _storedValues[profileID]![settingID] = value;
    }
    _refreshOverrides();
    _refreshSearchIndex();

    // watch for auth events
    Storage.watch(.sessionToken).listen((event) {
      // logged out, so clear local data
      if (event.deleted) {
        profiles = null;
        activeProfileID = null;
        overrides = null;
        _storedValues.clear();
        _pendingItems.clear();
        _changes.add(.all());
      } else {
        // otherwise queue a sync because auth updated
        unawaited(sync());
      }
    });

    // sync with the server on startup
    unawaited(sync());
  }

  /// Refresh the current setting overrides and notify listeners.
  static void _refreshOverrides() {
    if (activeProfileID == null) {
      overrides = null;
      return;
    }
    overrides = {
      for (final entry in (_storedValues[activeProfileID] ?? const {}).entries)
        entry.key: entry.value.value,
    };
  }

  /// Tail of the sync queue, for chaining.
  static Future<void> _syncTail = Future.value();

  /// Amount of active data transfers to the server.
  static int _activeSyncs = 0;

  static void _beginSync() {
    _activeSyncs++;
    syncState.value = const SyncSyncing();
  }

  /// Ends a sync, putting [failure] into the resulting sync state.
  static void _endSync(ApiFailure<dynamic>? failure) {
    _activeSyncs = max(0, _activeSyncs - 1);
    if (_activeSyncs > 0) return;
    syncState.value = switch (failure) {
      null => const SyncIdle(),
      final f when f.rawException.response == null => const SyncOffline(),
      final f => SyncError(f.message),
    };
  }

  /// Synchronizes local settings data with the server. Calls are queued.
  static Future<void> sync() {
    final task = _syncTail.then((_) => _runSync());
    // keep the chain alive even if a sync throws
    _syncTail = task.catchError((_) {});
    return task;
  }

  static Future<void> _runSync() async {
    if (!Api.canMakeAuthenticatedRequests) return;
    _beginSync();
    ApiFailure<dynamic>? failure;

    try {
      // push pending updates to the server first
      failure ??= await _pushPending();

      // definitions
      final defs = await Api.request(
        (a) => a.getSettingsApi().getClientSettingsDefinitions(),
      );
      switch (defs) {
        case ApiSuccess(:final data):
          definitions = data.list.toList();
          groups = data.groups.toList();
          _refreshSearchIndex();
          // defaults may have changed, notify listeners
          _changes.add(.all());

          // persist for offline use
          await _box.put(_definitionsKey, definitions);
          await _box.put(_groupsKey, groups);
        case ApiFailure():
          failure ??= defs;
      }

      // profiles
      final profileList = await Api.request(
        (a) => a.getSettingsApi().getSettingsProfiles(),
      );
      switch (profileList) {
        case ApiSuccess(:final data):
          final oldProfiles = profiles;
          profiles = data.list.toList();

          await _box.put(_profilesKey, profiles);

          // switch to first profile if ours was deleted
          final hasActive = data.list.any((item) => item.id == activeProfileID);
          if (!hasActive) await switchProfile(data.list.firstOrNull?.id);

          // notify listeners when profiles changed
          if (oldProfiles == null ||
              oldProfiles.length != profiles!.length ||
              oldProfiles.any((item) => profile(item.id)?.name != item.name)) {
            _changes.add(.all());
          }
        case ApiFailure():
          failure ??= profileList;
      }

      // pull values if we have an active profile
      final active = activeProfileID;
      if (active != null) {
        failure ??= await _pullValues(active);
      }
    } finally {
      _endSync(failure);
    }
  }

  /// Pushes pending updates to the server.
  /// Returns the failure response if the push failed.
  static Future<ApiFailure<dynamic>?> _pushPending() async {
    _beginSync();
    ApiFailure<dynamic>? failure;

    final remaining = List.of(_pendingItems);
    final profileList = profiles;
    final definitionList = definitions;
    for (final pending in remaining) {
      // drop pending items that no longer exist
      // also drops all pending items if we have no server state
      if (profileList == null ||
          profileList.where((p) => p.id == pending.profileID).isEmpty ||
          definitionList == null ||
          definitionList.where((d) => d.id == pending.settingID).isEmpty) {
        _pendingItems.remove(pending);
        continue;
      }

      //TODO: if the server has a value newer than the pending push we should
      // reject the pending push, we can send a timestamp to the server for ts
      final response = await Api.request(
        (a) => a.getSettingsApi().updateSettingsProfileValue(
          profile: pending.profileID,
          settingID: pending.settingID,
          updateSettingsProfileValueRequest: .new(
            (b) => b.value = pending.value,
          ),
        ),
      );
      switch (response) {
        case ApiSuccess(:final data):
          // values pushed at their default drop the override
          final found = definitionList
              .where((d) => d.id == pending.settingID)
              .toList();
          if (found.isNotEmpty && pending.value == found.first.encodedDefault) {
            _deleteValue(pending.profileID, pending.settingID);
          } else {
            _storeValue(pending.profileID, pending.settingID, data);
          }
          _pendingItems.remove(pending);
        case ApiFailure():
          //TODO: add retry counter on this and stop after so many tries
          //TODO: surface server errors to the user in a toast

          // keep it queued for the next sync
          // we only pass on the first failure, let everything else sync
          failure ??= response;
      }
    }

    await _box.put(_pendingItemsKey, _pendingItems);
    _endSync(failure);
    return failure;
  }

  /// Pulls server values for [profileID], merging them with local ones.
  /// Returns the failure response if the pull failed.
  static Future<ApiFailure<dynamic>?> _pullValues(String profileID) async {
    final response = await Api.request(
      (a) => a.getSettingsApi().getSettingsProfileValues(profile: profileID),
    );
    switch (response) {
      case ApiSuccess(:final data):
        final stored = _storedValues[profileID];
        final changed = <String>[];
        for (final entry in data.values.entries) {
          final existing = stored?[entry.key];
          // newer timestamp wins
          if (existing == null ||
              entry.value.updatedAt.isAfter(existing.updatedAt)) {
            _storeValue(profileID, entry.key, entry.value);
            changed.add(entry.key);
          }
        }
        // drop local entries that are no longer stored on the server
        for (final id in stored?.keys.toList() ?? const <String>[]) {
          if (data.values.containsKey(id)) continue;
          // keep entries that are still pending a push
          if (_pendingItems.any(
            (item) => item.profileID == profileID && item.settingID == id,
          )) {
            continue;
          }
          _deleteValue(profileID, id);
          changed.add(id);
        }
        _refreshOverrides();
        if (changed.isNotEmpty) _changes.add(.new(changed));
        return null;
      case ApiFailure():
        return response;
    }
  }

  /// Stores a value locally without notifying.
  static void _storeValue(
    String profileID,
    String id,
    SettingValueEntry value,
  ) {
    _storedValues[profileID] ??= {};
    _storedValues[profileID]![id] = value;

    // items are stored as $profileID$key.name.here
    unawaited(
      _box.put(_valuesDelimiter + profileID + _valuesDelimiter + id, value),
    );
  }

  /// Deletes a locally stored value without notifying.
  static void _deleteValue(String profileID, String id) {
    _storedValues[profileID]?.remove(id);
    unawaited(
      _box.delete(_valuesDelimiter + profileID + _valuesDelimiter + id),
    );
  }

  /// Switches to the specified profile.
  static Future<void> switchProfile(String? id) async {
    // dont switch to nonexistent profile
    if (id != null && profile(id) == null) return;
    // nothing to do
    if (activeProfileID == id) return;

    activeProfileID = id;
    if (id != null) {
      await _box.put(_activeProfileKey, id);
    } else {
      await _box.delete(_activeProfileKey);
    }
    _refreshOverrides();
    _changes.add(.all());
  }

  /// Reads a setting value from it's ID. Null if the setting is not found yet.
  static T? get<T>(String id) {
    final def = definition(id);
    if (def == null) return null;
    final override = overrides?[id];
    if (override != null) return _decode<T>(def, override);
    return def.typedDefault<T>();
  }

  /// Always returns a value for a setting, even if it's not found.
  static T getValue<T>(String id) => get<T>(id) ?? _fallbackTypeValue<T>();

  /// Writes a typed value for a setting to [profileID] when given or current.
  /// Returns a boolean indicating success.
  static Future<bool> set<T>(String id, T value, {String? profileID}) async {
    final def = definition(id);
    final targetProfileID = profileID ?? activeProfileID;
    if (def == null || targetProfileID == null) return false;

    final encoded = _encode<T>(def, value);
    final updatedAt = DateTime.now().toUtc();

    // values equal to the default drop the override
    if (def.isDefault(value)) {
      _deleteValue(targetProfileID, id);
    } else {
      // store/update value locally
      _storeValue(
        targetProfileID,
        id,
        SettingValueEntry(
          (b) => b
            ..value = encoded
            ..updatedAt = updatedAt,
        ),
      );
    }
    _refreshOverrides();
    _changes.add(.new([id]));

    // remove any pending updates for this item
    _pendingItems.removeWhere(
      (item) => item.profileID == targetProfileID && item.settingID == id,
    );
    // queue new update for the server
    _pendingItems.add(
      SettingsPendingPushItem(
        profileID: targetProfileID,
        settingID: id,
        value: encoded,
        updatedAt: updatedAt,
      ),
    );
    await _box.put(_pendingItemsKey, _pendingItems);
    await _pushPending();
    return true;
  }

  /// Decodes a JSON-encoded value text into the setting's type.
  static T? _decode<T>(SettingsDefinition def, String text) {
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
  static String _encode<T>(SettingsDefinition def, T value) =>
      switch (def.kind) {
        .bool_ => jsonEncode(value as bool),
        .int_ => jsonEncode(value as num),
        .float => jsonEncode(value as num),
        .string || .enum_ => jsonEncode(value as String),
        .stringlist => jsonEncode((value as List<String>).toList()),
        _ => jsonEncode(value),
      };

  /// Completely reset the settings manager. Used for logout.
  static Future<void> reset() async {
    definitions = groups = activeProfileID = overrides = null;
    _pendingItems.clear();
    _storedValues.clear();
    await _box.deleteAll([_definitionsKey, _groupsKey, _pendingItemsKey]);

    _refreshSearchIndex();
    _changes.add(.all());
  }

  static Fuse<SettingsDefinition> searchIndex = .new(
    const [],
    options: .new(
      includeScore: true,
      useTokenSearch: true,
      keys: <FuseKey<SettingsDefinition>>[
        .new(
          name: "title",
          weight: 5,
          getFn: (d) => SettingsTranslated.defName(d.id),
        ),
        .new(
          name: "description",
          weight: 4,
          getFn: (d) => SettingsTranslated.defDescription(d.id),
        ),
        .new(name: "id", weight: 2, getFn: (d) => d.id),
        .new(
          name: "parents",
          weight: 1,
          // all of the group path segments joined into one string
          getFn: (d) => SettingsTranslated.groupSegments(d.id).join("\n"),
        ),
      ],
    ),
  );

  /// Refreshes the stored documents in [searchIndex].
  static void _refreshSearchIndex() =>
      searchIndex.setCollection(definitions ?? const []);
}

/// A settings change event.
/// An empty [ids] means a global change affecting every setting.
class SettingsChange(final List<String> ids) {
  new all() : this(const []);
}

// we are using classes here so that we can pass message from the error one.
/// Server sync state of settings.
sealed class const SettingsSyncState();
class const SyncIdle() extends SettingsSyncState;
class const SyncSyncing() extends SettingsSyncState;
class const SyncOffline() extends SettingsSyncState;
class SyncError(final String message) extends SettingsSyncState;

/// Listens for setting value changes and rebuilds, returning the value.
class const SettingsValue<T>(
  final String id, {
  required final Widget Function(BuildContext context, T value) builder,
  super.key,
}) extends HookWidget {
  @override
  Widget build(BuildContext context) {
    useSettings([id]);
    return builder(context, Settings.getValue<T>(id));
  }
}

/// Listens for setting changes and rebuilds without reading a value.
/// An empty [ids] listens to all settings.
class const SettingsListen(
  final List<String> ids, {
  required final Widget Function(BuildContext context) builder,
  super.key,
}) extends HookWidget {
  @override
  Widget build(BuildContext context) {
    useSettings(ids);
    return builder(context);
  }
}

/// Returns the parent group of an ID. Null for toplevel groups.
String? settingIDParent(String id) {
  final dot = id.lastIndexOf(".");
  return dot <= 0 ? null : id.substring(0, dot);
}

/// Returns a fallback value for the given setting dart type.
T _fallbackTypeValue<T>() {
  if (T == bool) return false as T;
  if (T == int) return 0 as T;
  if (T == double) return 0.0 as T;
  if (T == String) return "" as T;
  if (T == List<String>) return List<String>.empty() as T;
  throw UnsupportedError("no default value for the type $T");
}

extension SettingsDefinitionHelpers on SettingsDefinition {
  String get name => SettingsTranslated.defName(id);
  String get description => SettingsTranslated.defDescription(id);
  T value<T>() => Settings.getValue<T>(id);

  /// The raw default value of this definition.
  Object? get rawDefault => switch (kind) {
    .bool_ => bool_?.defaultValue ?? false,
    .int_ => int_?.defaultValue ?? 0,
    .float => float?.defaultValue ?? 0.0,
    .string => string?.defaultValue ?? "",
    .enum_ => enum_?.defaultValue ?? enum_?.choices?.firstOrNull?.value ?? "",
    .stringlist => stringList?.defaultValue?.toList() ?? const <String>[],
    _ => null,
  };

  /// The typed default value of this definition, per its kind.
  /// Null if unsupported.
  T? typedDefault<T>() {
    final value = rawDefault;
    return value is T ? value : null;
  }

  /// Returns the default value of this definition. Always returns a value.
  T? getDefault<T>() => typedDefault() ?? _fallbackTypeValue<T>();

  /// The encoded JSON text of this definition's default value.
  String get encodedDefault => Settings._encode<dynamic>(this, rawDefault);

  /// Whether [value] equals this definition's default value.
  bool isDefault(Object? value) {
    final defaultValue = rawDefault;
    if (defaultValue == null) return false;
    return jsonEncode(value) == jsonEncode(defaultValue);
  }
}

abstract class SettingsTranslated {
  /// Translated name for a setting definition.
  static String defName(String id) => t.setting_definitions[id] ?? id;

  /// Translated description for a setting definition, empty when missing.
  static String defDescription(String id) =>
      t.setting_definitions["$id.description"] ?? "";

  /// Translated display name for a setting choice.
  static String choiceName(String id, String value) =>
      t.setting_choices["$id.$value"] ?? value;

  /// Translated description for a setting choice, empty when missing.
  static String choiceDescription(String id, String value) =>
      t.setting_choices["$id.$value.description"] ?? "";

  /// Translated name for a settings group.
  static String groupName(String id) => t.setting_groups[id] ?? id;

  /// Translated group-name segments for a setting ID, outermost first.
  static List<String> groupSegments(String id) => [
    for (
      var group = settingIDParent(id);
      group != null;
      group = settingIDParent(group)
    )
      groupName(group),
  ].reversed.toList();

  /// Translated title path for a setting ID, including the definition name.
  static List<String> defSegments(String id) => [
    ...groupSegments(id),
    defName(id),
  ];
}

abstract class SettingsDerived {
  /// Gets a 0-1 transparency value based on the transparency setting.
  ///
  /// The [target] is the opacity that should be returned when the setting
  /// is at its DEFAULT value. Will be interpolated so that 0 is always
  /// fully transparent, and 1 is always fully opaque.
  static double transparency(double target) {
    final value = Settings.getValue<double>("ui.transparency");
    final def =
        (Settings.definition("ui.transparency")?.typedDefault<double>() ?? 0.5)
            .clamp(0.0, 1.0);
    return (value <= def
            // if the value is less than the default then interpolate downward
            ? lerpDouble(0, target, value / def)!
            // if greater, interpolate upwards
            : lerpDouble(target, 1, (value - def) / (1 - def))!)
        .clamp(0, 1);
  }
}
