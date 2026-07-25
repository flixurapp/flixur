//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class SetupRequest {
  /// Returns a new [SetupRequest] instance.
  SetupRequest({
    this.dollarSchema,
    required this.code,
    required this.password,
    required this.username,
  });

  /// A URL to the JSON Schema for this object.
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? dollarSchema;

  String code;

  String password;

  String username;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SetupRequest &&
          other.dollarSchema == dollarSchema &&
          other.code == code &&
          other.password == password &&
          other.username == username;

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (dollarSchema == null ? 0 : dollarSchema!.hashCode) +
      (code.hashCode) +
      (password.hashCode) +
      (username.hashCode);

  @override
  String toString() =>
      'SetupRequest[dollarSchema=$dollarSchema, code=$code, password=$password, username=$username]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.dollarSchema != null) {
      json[r'$schema'] = this.dollarSchema;
    } else {
      json[r'$schema'] = null;
    }
    json[r'code'] = this.code;
    json[r'password'] = this.password;
    json[r'username'] = this.username;
    return json;
  }

  /// Returns a new [SetupRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static SetupRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'code'),
            'Required key "SetupRequest[code]" is missing from JSON.');
        assert(json[r'code'] != null,
            'Required key "SetupRequest[code]" has a null value in JSON.');
        assert(json.containsKey(r'password'),
            'Required key "SetupRequest[password]" is missing from JSON.');
        assert(json[r'password'] != null,
            'Required key "SetupRequest[password]" has a null value in JSON.');
        assert(json.containsKey(r'username'),
            'Required key "SetupRequest[username]" is missing from JSON.');
        assert(json[r'username'] != null,
            'Required key "SetupRequest[username]" has a null value in JSON.');
        return true;
      }());

      return SetupRequest(
        dollarSchema: mapValueOfType<String>(json, r'$schema'),
        code: mapValueOfType<String>(json, r'code')!,
        password: mapValueOfType<String>(json, r'password')!,
        username: mapValueOfType<String>(json, r'username')!,
      );
    }
    return null;
  }

  static List<SetupRequest> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <SetupRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = SetupRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, SetupRequest> mapFromJson(dynamic json) {
    final map = <String, SetupRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = SetupRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of SetupRequest-objects as value to a dart map
  static Map<String, List<SetupRequest>> mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<SetupRequest>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = SetupRequest.listFromJson(
          entry.value,
          growable: growable,
        );
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'code',
    'password',
    'username',
  };
}
