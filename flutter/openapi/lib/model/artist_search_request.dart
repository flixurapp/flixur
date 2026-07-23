//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class ArtistSearchRequest {
  /// Returns a new [ArtistSearchRequest] instance.
  ArtistSearchRequest({
    this.dollarSchema,
    this.limit = 10,
    this.plugin,
    required this.query,
  });

  /// A URL to the JSON Schema for this object.
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? dollarSchema;

  /// Minimum value: 1
  /// Maximum value: 100
  int limit;

  /// Plugin ID to use for the request. Omit to use the local server.
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? plugin;

  String query;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ArtistSearchRequest &&
          other.dollarSchema == dollarSchema &&
          other.limit == limit &&
          other.plugin == plugin &&
          other.query == query;

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (dollarSchema == null ? 0 : dollarSchema!.hashCode) +
      (limit.hashCode) +
      (plugin == null ? 0 : plugin!.hashCode) +
      (query.hashCode);

  @override
  String toString() =>
      'ArtistSearchRequest[dollarSchema=$dollarSchema, limit=$limit, plugin=$plugin, query=$query]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.dollarSchema != null) {
      json[r'$schema'] = this.dollarSchema;
    } else {
      json[r'$schema'] = null;
    }
    json[r'limit'] = this.limit;
    if (this.plugin != null) {
      json[r'plugin'] = this.plugin;
    } else {
      json[r'plugin'] = null;
    }
    json[r'query'] = this.query;
    return json;
  }

  /// Returns a new [ArtistSearchRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ArtistSearchRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'query'),
            'Required key "ArtistSearchRequest[query]" is missing from JSON.');
        assert(json[r'query'] != null,
            'Required key "ArtistSearchRequest[query]" has a null value in JSON.');
        return true;
      }());

      return ArtistSearchRequest(
        dollarSchema: mapValueOfType<String>(json, r'$schema'),
        limit: mapValueOfType<int>(json, r'limit') ?? 10,
        plugin: mapValueOfType<String>(json, r'plugin'),
        query: mapValueOfType<String>(json, r'query')!,
      );
    }
    return null;
  }

  static List<ArtistSearchRequest> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <ArtistSearchRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ArtistSearchRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ArtistSearchRequest> mapFromJson(dynamic json) {
    final map = <String, ArtistSearchRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ArtistSearchRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ArtistSearchRequest-objects as value to a dart map
  static Map<String, List<ArtistSearchRequest>> mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<ArtistSearchRequest>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ArtistSearchRequest.listFromJson(
          entry.value,
          growable: growable,
        );
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'query',
  };
}
