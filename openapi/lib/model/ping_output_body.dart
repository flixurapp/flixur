//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class PingOutputBody {
  /// Returns a new [PingOutputBody] instance.
  PingOutputBody({
    this.dollarSchema,
    required this.version,
  });

  /// A URL to the JSON Schema for this object.
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? dollarSchema;

  String version;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PingOutputBody &&
          other.dollarSchema == dollarSchema &&
          other.version == version;

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (dollarSchema == null ? 0 : dollarSchema!.hashCode) + (version.hashCode);

  @override
  String toString() =>
      'PingOutputBody[dollarSchema=$dollarSchema, version=$version]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.dollarSchema != null) {
      json[r'$schema'] = this.dollarSchema;
    } else {
      json[r'$schema'] = null;
    }
    json[r'version'] = this.version;
    return json;
  }

  /// Returns a new [PingOutputBody] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static PingOutputBody? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'version'),
            'Required key "PingOutputBody[version]" is missing from JSON.');
        assert(json[r'version'] != null,
            'Required key "PingOutputBody[version]" has a null value in JSON.');
        return true;
      }());

      return PingOutputBody(
        dollarSchema: mapValueOfType<String>(json, r'$schema'),
        version: mapValueOfType<String>(json, r'version')!,
      );
    }
    return null;
  }

  static List<PingOutputBody> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <PingOutputBody>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PingOutputBody.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, PingOutputBody> mapFromJson(dynamic json) {
    final map = <String, PingOutputBody>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = PingOutputBody.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of PingOutputBody-objects as value to a dart map
  static Map<String, List<PingOutputBody>> mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<PingOutputBody>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = PingOutputBody.listFromJson(
          entry.value,
          growable: growable,
        );
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'version',
  };
}
