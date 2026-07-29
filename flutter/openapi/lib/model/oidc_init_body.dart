//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class OIDCInitBody {
  /// Returns a new [OIDCInitBody] instance.
  OIDCInitBody({
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
      other is OIDCInitBody &&
          other.dollarSchema == dollarSchema &&
          other.loginURL == loginURL;

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (dollarSchema == null ? 0 : dollarSchema!.hashCode) + (loginURL.hashCode);

  @override
  String toString() =>
      'OIDCInitBody[dollarSchema=$dollarSchema, loginURL=$loginURL]';

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

  /// Returns a new [OIDCInitBody] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static OIDCInitBody? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'loginURL'),
            'Required key "OIDCInitBody[loginURL]" is missing from JSON.');
        assert(json[r'loginURL'] != null,
            'Required key "OIDCInitBody[loginURL]" has a null value in JSON.');
        return true;
      }());

      return OIDCInitBody(
        dollarSchema: mapValueOfType<String>(json, r'$schema'),
        loginURL: mapValueOfType<String>(json, r'loginURL')!,
      );
    }
    return null;
  }

  static List<OIDCInitBody> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <OIDCInitBody>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = OIDCInitBody.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, OIDCInitBody> mapFromJson(dynamic json) {
    final map = <String, OIDCInitBody>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = OIDCInitBody.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of OIDCInitBody-objects as value to a dart map
  static Map<String, List<OIDCInitBody>> mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<OIDCInitBody>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = OIDCInitBody.listFromJson(
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
