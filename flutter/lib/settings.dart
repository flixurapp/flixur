import "dart:async";
import "dart:convert";

import "package:flixur/api.dart";
import "package:flixur/gen/strings.g.dart";
import "package:flixur/storage.dart";
import "package:flutter/widgets.dart";
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

class Settings {
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

  /// Bumped whenever any settings property changes.
  static ValueNotifier<int> changeNotifier = .new(0);

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

    // watch for auth events
    Storage.watch(.sessionToken).listen((event) {
      // logged out, so clear local data
      if (event.deleted) {
        profiles = null;
        activeProfileID = null;
        overrides = null;
        _storedValues.clear();
        _pendingItems.clear();
      } else {
        // otherwise queue a sync because auth updated
        unawaited(sync());
      }
    });
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
    changeNotifier.value++;
  }

  static bool _syncing = false;

  /// Synchronizes local settings data with the server.
  static Future<void> sync() async {
    if (_syncing || !Api.canMakeAuthenticatedRequests) return;
    _syncing = true;

    try {
      // push pending updates to the server first
      await _pushPending();

      // definitions
      final defs = await Api.request(
        (a) => a.getSettingsApi().getClientSettingsDefinitions(),
      );
      if (defs case ApiSuccess(:final data)) {
        definitions = data.list.toList();
        groups = data.groups.toList();
        changeNotifier.value++;

        // persist for offline use
        await _box.put(_definitionsKey, definitions);
        await _box.put(_groupsKey, groups);
      }

      // profiles
      final profileList = await Api.request(
        (a) => a.getSettingsApi().getSettingsProfiles(),
      );
      if (profileList case ApiSuccess(:final data)) {
        profiles = data.list.toList();
        changeNotifier.value++;

        await _box.put(_profilesKey, profiles);

        // switch to first profile if ours was deleted
        final profile = data.list.any((item) => item.id == activeProfileID);
        if (!profile) await switchProfile(data.list.firstOrNull?.id);
      }

      // pull values if we have an active profile
      final active = activeProfileID;
      if (active != null) await _pullValues(active);
    } finally {
      _syncing = false;
    }
  }

  /// Pushes pending updates to the server.
  static Future<void> _pushPending() async {
    final remaining = List.of(_pendingItems);
    for (final pending in remaining) {
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
          _storeValue(pending.profileID, pending.settingID, data);
          _pendingItems.remove(pending);
        case ApiFailure():
          // keep it queued for the next sync
          //TODO: add retry counter on this and stop after so many tries
          return;
      }
    }
    await _box.put(_pendingItemsKey, _pendingItems);
  }

  /// Pulls server values for [profileID], merging them with local ones.
  static Future<void> _pullValues(String profileID) async {
    final response = await Api.request(
      (a) => a.getSettingsApi().getSettingsProfileValues(profile: profileID),
    );
    if (response case ApiSuccess(:final data)) {
      final stored = _storedValues[profileID];
      for (final entry in data.values.entries) {
        final existing = stored?[entry.key];
        // newer timestamp wins
        if (existing == null ||
            entry.value.updatedAt.isAfter(existing.updatedAt)) {
          _storeValue(profileID, entry.key, entry.value);
        }
      }
      _refreshOverrides();
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

  /// Switches to the specified profile.
  static Future<void> switchProfile(String? id) async {
    // dont switch to nonexistent profile
    if (id != null && profile(id) == null) return;

    activeProfileID = id;
    if (id != null) {
      await _box.put(_activeProfileKey, id);
    } else {
      await _box.delete(_activeProfileKey);
    }
    _refreshOverrides();
  }

  /// Reads a setting value from it's ID. Null if the setting is not found yet.
  static T? get<T extends Object>(String id) {
    final def = definition(id);
    if (def == null) return null;
    final text = overrides?[id] ?? _defaultEncoded(def);
    return _decode<T>(def, text);
  }

  /// Always returns a value for a setting, even if it's not found.
  static T getValue<T extends Object>(String id) {
    final resolved = get<T>(id);
    if (resolved != null) return resolved;

    if (T == bool) return false as T;
    if (T == int) return 0 as T;
    if (T == double) return 0.0 as T;
    if (T == String) return "" as T;
    if (T == List<String>) return List<String>.empty() as T;
    throw UnsupportedError("no default value for the type $T");
  }

  /// Writes a typed value for a setting to the active profile.
  /// Returns a boolean indicating success.
  static Future<bool> set<T extends Object>(String id, T value) async {
    final def = definition(id);
    final profileID = activeProfileID;
    if (def == null || profileID == null) return false;

    final encoded = _encode<T>(def, value);
    final updatedAt = DateTime.now();

    // store/update value locally
    _storeValue(
      profileID,
      id,
      SettingValueEntry(
        (b) => b
          ..value = encoded
          ..updatedAt = updatedAt,
      ),
    );
    _refreshOverrides();

    // queue update for the server
    _pendingItems.add(
      SettingsPendingPushItem(
        profileID: profileID,
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
  static T? _decode<T extends Object>(SettingsDefinition def, String text) {
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
  static String _encode<T extends Object>(SettingsDefinition def, T value) =>
      switch (def.kind) {
        .bool_ => jsonEncode(value as bool),
        .int_ => jsonEncode(value as num),
        .float => jsonEncode(value as num),
        .string || .enum_ => jsonEncode(value as String),
        .stringlist => jsonEncode((value as List<String>).toList()),
        _ => jsonEncode(value),
      };
}

/// Listens for setting changes and rebuilds.
class const SettingsValue<T extends Object>(
  final String id, {
  required final Widget Function(BuildContext context, T value) builder,
  super.key,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: Settings.changeNotifier,
      builder: (context, revision, child) =>
          builder(context, Settings.getValue<T>(id)),
    );
  }
}

/// Translated name for a setting.
String settingName(String id) => t.setting_names[id] ?? id;

/// Translated description for a setting, empty when missing.
String settingDescription(String id) => t.setting_descriptions[id] ?? "";

/// Translated name for a settings group.
String settingGroupName(String id) => t.setting_group_names[id] ?? id;

/// The JSON-encoded default value of a definition.
String _defaultEncoded(SettingsDefinition def) => switch (def.kind) {
  .bool_ => jsonEncode(def.bool_?.defaultValue ?? false),
  .int_ => jsonEncode(def.int_?.defaultValue ?? 0),
  .float => jsonEncode(def.float?.defaultValue ?? 0.0),
  .string => jsonEncode(def.string?.defaultValue ?? ""),
  .enum_ => jsonEncode(
    def.enum_?.defaultValue ?? def.enum_?.choices?.firstOrNull?.value ?? "",
  ),
  .stringlist => jsonEncode(def.stringList?.defaultValue?.toList() ?? []),
  _ => jsonEncode(""),
};
