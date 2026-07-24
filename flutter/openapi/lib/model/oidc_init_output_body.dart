//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class OIDCInitOutputBody {
  /// Returns a new [OIDCInitOutputBody] instance.
  OIDCInitOutputBody({
    this.dollarSchema,
    required this.loginURL,
  });

  /// A URL to the JSON Schema for this object.
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? dollarSchema;

  String loginURL;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OIDCInitOutputBody &&
          other.dollarSchema == dollarSchema &&
          other.loginURL == loginURL;

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (dollarSchema == null ? 0 : dollarSchema!.hashCode) + (loginURL.hashCode);

  @override
  String toString() =>
      'OIDCInitOutputBody[dollarSchema=$dollarSchema, loginURL=$loginURL]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.dollarSchema != null) {
      json[r'$schema'] = this.dollarSchema;
    } else {
      json[r'$schema'] = null;
    }
    json[r'loginURL'] = this.loginURL;
    return json;
  }

  /// Returns a new [OIDCInitOutputBody] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static OIDCInitOutputBody? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'loginURL'),
            'Required key "OIDCInitOutputBody[loginURL]" is missing from JSON.');
        assert(json[r'loginURL'] != null,
            'Required key "OIDCInitOutputBody[loginURL]" has a null value in JSON.');
        return true;
      }());

      return OIDCInitOutputBody(
        dollarSchema: mapValueOfType<String>(json, r'$schema'),
        loginURL: mapValueOfType<String>(json, r'loginURL')!,
      );
    }
    return null;
  }

  static List<OIDCInitOutputBody> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <OIDCInitOutputBody>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = OIDCInitOutputBody.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, OIDCInitOutputBody> mapFromJson(dynamic json) {
    final map = <String, OIDCInitOutputBody>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = OIDCInitOutputBody.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of OIDCInitOutputBody-objects as value to a dart map
  static Map<String, List<OIDCInitOutputBody>> mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<OIDCInitOutputBody>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = OIDCInitOutputBody.listFromJson(
          entry.value,
          growable: growable,
        );
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'loginURL',
  };
}
