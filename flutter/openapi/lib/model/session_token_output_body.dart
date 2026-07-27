//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class SessionTokenOutputBody {
  /// Returns a new [SessionTokenOutputBody] instance.
  SessionTokenOutputBody({
    this.dollarSchema,
    required this.sessionToken,
  });

  /// A URL to the JSON Schema for this object.
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? dollarSchema;

  String sessionToken;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SessionTokenOutputBody &&
          other.dollarSchema == dollarSchema &&
          other.sessionToken == sessionToken;

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (dollarSchema == null ? 0 : dollarSchema!.hashCode) +
      (sessionToken.hashCode);

  @override
  String toString() =>
      'SessionTokenOutputBody[dollarSchema=$dollarSchema, sessionToken=$sessionToken]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.dollarSchema != null) {
      json[r'$schema'] = this.dollarSchema;
    } else {
      json[r'$schema'] = null;
    }
    json[r'sessionToken'] = this.sessionToken;
    return json;
  }

  /// Returns a new [SessionTokenOutputBody] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static SessionTokenOutputBody? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'sessionToken'),
            'Required key "SessionTokenOutputBody[sessionToken]" is missing from JSON.');
        assert(json[r'sessionToken'] != null,
            'Required key "SessionTokenOutputBody[sessionToken]" has a null value in JSON.');
        return true;
      }());

      return SessionTokenOutputBody(
        dollarSchema: mapValueOfType<String>(json, r'$schema'),
        sessionToken: mapValueOfType<String>(json, r'sessionToken')!,
      );
    }
    return null;
  }

  static List<SessionTokenOutputBody> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <SessionTokenOutputBody>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = SessionTokenOutputBody.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, SessionTokenOutputBody> mapFromJson(dynamic json) {
    final map = <String, SessionTokenOutputBody>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = SessionTokenOutputBody.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of SessionTokenOutputBody-objects as value to a dart map
  static Map<String, List<SessionTokenOutputBody>> mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<SessionTokenOutputBody>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = SessionTokenOutputBody.listFromJson(
          entry.value,
          growable: growable,
        );
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'sessionToken',
  };
}
