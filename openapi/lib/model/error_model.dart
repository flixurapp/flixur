//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class ErrorModel {
  /// Returns a new [ErrorModel] instance.
  ErrorModel({
    this.dollarSchema,
    this.detail,
    this.errors = const [],
    this.instance,
    this.status,
    this.title,
    this.type = 'about:blank',
  });

  /// A URL to the JSON Schema for this object.
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? dollarSchema;

  /// A human-readable explanation specific to this occurrence of the problem.
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? detail;

  /// Optional list of individual error details
  List<ErrorDetail>? errors;

  /// A URI reference that identifies the specific occurrence of the problem.
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? instance;

  /// HTTP status code
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  int? status;

  /// A short, human-readable summary of the problem type. This value should not change between occurrences of the error.
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? title;

  /// A URI reference to human-readable documentation for the error.
  String type;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ErrorModel &&
          other.dollarSchema == dollarSchema &&
          other.detail == detail &&
          _deepEquality.equals(other.errors, errors) &&
          other.instance == instance &&
          other.status == status &&
          other.title == title &&
          other.type == type;

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (dollarSchema == null ? 0 : dollarSchema!.hashCode) +
      (detail == null ? 0 : detail!.hashCode) +
      (errors == null ? 0 : errors!.hashCode) +
      (instance == null ? 0 : instance!.hashCode) +
      (status == null ? 0 : status!.hashCode) +
      (title == null ? 0 : title!.hashCode) +
      (type.hashCode);

  @override
  String toString() =>
      'ErrorModel[dollarSchema=$dollarSchema, detail=$detail, errors=$errors, instance=$instance, status=$status, title=$title, type=$type]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.dollarSchema != null) {
      json[r'$schema'] = this.dollarSchema;
    } else {
      json[r'$schema'] = null;
    }
    if (this.detail != null) {
      json[r'detail'] = this.detail;
    } else {
      json[r'detail'] = null;
    }
    if (this.errors != null) {
      json[r'errors'] = this.errors;
    } else {
      json[r'errors'] = null;
    }
    if (this.instance != null) {
      json[r'instance'] = this.instance;
    } else {
      json[r'instance'] = null;
    }
    if (this.status != null) {
      json[r'status'] = this.status;
    } else {
      json[r'status'] = null;
    }
    if (this.title != null) {
      json[r'title'] = this.title;
    } else {
      json[r'title'] = null;
    }
    json[r'type'] = this.type;
    return json;
  }

  /// Returns a new [ErrorModel] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ErrorModel? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        return true;
      }());

      return ErrorModel(
        dollarSchema: mapValueOfType<String>(json, r'$schema'),
        detail: mapValueOfType<String>(json, r'detail'),
        errors: ErrorDetail.listFromJson(json[r'errors']),
        instance: mapValueOfType<String>(json, r'instance'),
        status: mapValueOfType<int>(json, r'status'),
        title: mapValueOfType<String>(json, r'title'),
        type: mapValueOfType<String>(json, r'type') ?? 'about:blank',
      );
    }
    return null;
  }

  static List<ErrorModel> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <ErrorModel>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ErrorModel.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ErrorModel> mapFromJson(dynamic json) {
    final map = <String, ErrorModel>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ErrorModel.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ErrorModel-objects as value to a dart map
  static Map<String, List<ErrorModel>> mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<ErrorModel>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ErrorModel.listFromJson(
          entry.value,
          growable: growable,
        );
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{};
}
