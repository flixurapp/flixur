//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class APIError {
  /// Returns a new [APIError] instance.
  APIError({
    this.dollarSchema,
    required this.code,
    this.detail,
  });

  /// A URL to the JSON Schema for this object.
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? dollarSchema;

  APIErrorCodeEnum code;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? detail;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is APIError &&
          other.dollarSchema == dollarSchema &&
          other.code == code &&
          other.detail == detail;

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (dollarSchema == null ? 0 : dollarSchema!.hashCode) +
      (code.hashCode) +
      (detail == null ? 0 : detail!.hashCode);

  @override
  String toString() =>
      'APIError[dollarSchema=$dollarSchema, code=$code, detail=$detail]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.dollarSchema != null) {
      json[r'$schema'] = this.dollarSchema;
    } else {
      json[r'$schema'] = null;
    }
    json[r'code'] = this.code;
    if (this.detail != null) {
      json[r'detail'] = this.detail;
    } else {
      json[r'detail'] = null;
    }
    return json;
  }

  /// Returns a new [APIError] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static APIError? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'code'),
            'Required key "APIError[code]" is missing from JSON.');
        assert(json[r'code'] != null,
            'Required key "APIError[code]" has a null value in JSON.');
        return true;
      }());

      return APIError(
        dollarSchema: mapValueOfType<String>(json, r'$schema'),
        code: APIErrorCodeEnum.fromJson(json[r'code'])!,
        detail: mapValueOfType<String>(json, r'detail'),
      );
    }
    return null;
  }

  static List<APIError> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <APIError>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = APIError.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, APIError> mapFromJson(dynamic json) {
    final map = <String, APIError>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = APIError.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of APIError-objects as value to a dart map
  static Map<String, List<APIError>> mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<APIError>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = APIError.listFromJson(
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
  };
}

class APIErrorCodeEnum {
  /// Instantiate a new enum with the provided [value].
  const APIErrorCodeEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const DATABASE_ERROR = APIErrorCodeEnum._(r'DATABASE_ERROR');
  static const INCORRECT_PASSWORD = APIErrorCodeEnum._(r'INCORRECT_PASSWORD');
  static const INCORRECT_USERNAME = APIErrorCodeEnum._(r'INCORRECT_USERNAME');
  static const INVALID_INPUT = APIErrorCodeEnum._(r'INVALID_INPUT');
  static const TOO_LONG = APIErrorCodeEnum._(r'TOO_LONG');
  static const TOO_SHORT = APIErrorCodeEnum._(r'TOO_SHORT');

  /// List of all possible values in this [enum][APIErrorCodeEnum].
  static const values = <APIErrorCodeEnum>[
    DATABASE_ERROR,
    INCORRECT_PASSWORD,
    INCORRECT_USERNAME,
    INVALID_INPUT,
    TOO_LONG,
    TOO_SHORT,
  ];

  static APIErrorCodeEnum? fromJson(dynamic value) =>
      APIErrorCodeEnumTypeTransformer().decode(value);

  static List<APIErrorCodeEnum> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <APIErrorCodeEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = APIErrorCodeEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [APIErrorCodeEnum] to String,
/// and [decode] dynamic data back to [APIErrorCodeEnum].
class APIErrorCodeEnumTypeTransformer {
  factory APIErrorCodeEnumTypeTransformer() =>
      _instance ??= const APIErrorCodeEnumTypeTransformer._();

  const APIErrorCodeEnumTypeTransformer._();

  String encode(APIErrorCodeEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a APIErrorCodeEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  APIErrorCodeEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'DATABASE_ERROR':
          return APIErrorCodeEnum.DATABASE_ERROR;
        case r'INCORRECT_PASSWORD':
          return APIErrorCodeEnum.INCORRECT_PASSWORD;
        case r'INCORRECT_USERNAME':
          return APIErrorCodeEnum.INCORRECT_USERNAME;
        case r'INVALID_INPUT':
          return APIErrorCodeEnum.INVALID_INPUT;
        case r'TOO_LONG':
          return APIErrorCodeEnum.TOO_LONG;
        case r'TOO_SHORT':
          return APIErrorCodeEnum.TOO_SHORT;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [APIErrorCodeEnumTypeTransformer] instance.
  static APIErrorCodeEnumTypeTransformer? _instance;
}
