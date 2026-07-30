//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class PostAuthLoginRequest {
  /// Returns a new [PostAuthLoginRequest] instance.
  PostAuthLoginRequest({
    this.dollarSchema,
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

  String password;

  String username;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PostAuthLoginRequest &&
          other.dollarSchema == dollarSchema &&
          other.password == password &&
          other.username == username;

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (dollarSchema == null ? 0 : dollarSchema!.hashCode) +
      (password.hashCode) +
      (username.hashCode);

  @override
  String toString() =>
      'PostAuthLoginRequest[dollarSchema=$dollarSchema, password=$password, username=$username]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.dollarSchema != null) {
      json[r'$schema'] = this.dollarSchema;
    } else {
      json[r'$schema'] = null;
    }
    json[r'password'] = this.password;
    json[r'username'] = this.username;
    return json;
  }

  /// Returns a new [PostAuthLoginRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static PostAuthLoginRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'password'),
            'Required key "PostAuthLoginRequest[password]" is missing from JSON.');
        assert(json[r'password'] != null,
            'Required key "PostAuthLoginRequest[password]" has a null value in JSON.');
        assert(json.containsKey(r'username'),
            'Required key "PostAuthLoginRequest[username]" is missing from JSON.');
        assert(json[r'username'] != null,
            'Required key "PostAuthLoginRequest[username]" has a null value in JSON.');
        return true;
      }());

      return PostAuthLoginRequest(
        dollarSchema: mapValueOfType<String>(json, r'$schema'),
        password: mapValueOfType<String>(json, r'password')!,
        username: mapValueOfType<String>(json, r'username')!,
      );
    }
    return null;
  }

  static List<PostAuthLoginRequest> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <PostAuthLoginRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PostAuthLoginRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, PostAuthLoginRequest> mapFromJson(dynamic json) {
    final map = <String, PostAuthLoginRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = PostAuthLoginRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of PostAuthLoginRequest-objects as value to a dart map
  static Map<String, List<PostAuthLoginRequest>> mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<PostAuthLoginRequest>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = PostAuthLoginRequest.listFromJson(
          entry.value,
          growable: growable,
        );
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'password',
    'username',
  };
}
