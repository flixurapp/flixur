//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class GreetingOutputBody {
  /// Returns a new [GreetingOutputBody] instance.
  GreetingOutputBody({
    this.dollarSchema,
    required this.message,
  });

  /// A URL to the JSON Schema for this object.
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? dollarSchema;

  /// Greeting message
  String message;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GreetingOutputBody &&
          other.dollarSchema == dollarSchema &&
          other.message == message;

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (dollarSchema == null ? 0 : dollarSchema!.hashCode) + (message.hashCode);

  @override
  String toString() =>
      'GreetingOutputBody[dollarSchema=$dollarSchema, message=$message]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.dollarSchema != null) {
      json[r'$schema'] = this.dollarSchema;
    } else {
      json[r'$schema'] = null;
    }
    json[r'message'] = this.message;
    return json;
  }

  /// Returns a new [GreetingOutputBody] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static GreetingOutputBody? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'message'),
            'Required key "GreetingOutputBody[message]" is missing from JSON.');
        assert(json[r'message'] != null,
            'Required key "GreetingOutputBody[message]" has a null value in JSON.');
        return true;
      }());

      return GreetingOutputBody(
        dollarSchema: mapValueOfType<String>(json, r'$schema'),
        message: mapValueOfType<String>(json, r'message')!,
      );
    }
    return null;
  }

  static List<GreetingOutputBody> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <GreetingOutputBody>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = GreetingOutputBody.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, GreetingOutputBody> mapFromJson(dynamic json) {
    final map = <String, GreetingOutputBody>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = GreetingOutputBody.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of GreetingOutputBody-objects as value to a dart map
  static Map<String, List<GreetingOutputBody>> mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<GreetingOutputBody>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = GreetingOutputBody.listFromJson(
          entry.value,
          growable: growable,
        );
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'message',
  };
}
