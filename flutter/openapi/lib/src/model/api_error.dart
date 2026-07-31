//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'api_error.g.dart';

/// APIError
///
/// Properties:
/// * [dollarSchema] - A URL to the JSON Schema for this object.
/// * [code]
/// * [detail]
@BuiltValue()
abstract class APIError implements Built<APIError, APIErrorBuilder> {
  /// A URL to the JSON Schema for this object.
  @BuiltValueField(wireName: r'$schema')
  String? get dollarSchema;

  @BuiltValueField(wireName: r'code')
  APIErrorCodeEnum get code;
  // enum codeEnum {  DATABASE_ERROR,  INCORRECT_PASSWORD,  INCORRECT_USERNAME,  INVALID_INPUT,  TOO_LONG,  TOO_SHORT,  };

  @BuiltValueField(wireName: r'detail')
  String? get detail;

  APIError._();

  factory APIError([void updates(APIErrorBuilder b)]) = _$APIError;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(APIErrorBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<APIError> get serializer => _$APIErrorSerializer();
}

class _$APIErrorSerializer implements PrimitiveSerializer<APIError> {
  @override
  final Iterable<Type> types = const [APIError, _$APIError];

  @override
  final String wireName = r'APIError';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    APIError object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.dollarSchema != null) {
      yield r'$schema';
      yield serializers.serialize(
        object.dollarSchema,
        specifiedType: const FullType(String),
      );
    }
    yield r'code';
    yield serializers.serialize(
      object.code,
      specifiedType: const FullType(APIErrorCodeEnum),
    );
    if (object.detail != null) {
      yield r'detail';
      yield serializers.serialize(
        object.detail,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    APIError object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object,
            specifiedType: specifiedType)
        .toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required APIErrorBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'$schema':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.dollarSchema = valueDes;
          break;
        case r'code':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(APIErrorCodeEnum),
          ) as APIErrorCodeEnum;
          result.code = valueDes;
          break;
        case r'detail':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.detail = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  APIError deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = APIErrorBuilder();
    final serializedList = (serialized as Iterable<Object?>).toList();
    final unhandled = <Object?>[];
    _deserializeProperties(
      serializers,
      serialized,
      specifiedType: specifiedType,
      serializedList: serializedList,
      unhandled: unhandled,
      result: result,
    );
    return result.build();
  }
}

class APIErrorCodeEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'DATABASE_ERROR')
  static const APIErrorCodeEnum DATABASE_ERROR =
      _$aPIErrorCodeEnum_DATABASE_ERROR;
  @BuiltValueEnumConst(wireName: r'INCORRECT_PASSWORD')
  static const APIErrorCodeEnum INCORRECT_PASSWORD =
      _$aPIErrorCodeEnum_INCORRECT_PASSWORD;
  @BuiltValueEnumConst(wireName: r'INCORRECT_USERNAME')
  static const APIErrorCodeEnum INCORRECT_USERNAME =
      _$aPIErrorCodeEnum_INCORRECT_USERNAME;
  @BuiltValueEnumConst(wireName: r'INVALID_INPUT')
  static const APIErrorCodeEnum INVALID_INPUT =
      _$aPIErrorCodeEnum_INVALID_INPUT;
  @BuiltValueEnumConst(wireName: r'TOO_LONG')
  static const APIErrorCodeEnum TOO_LONG = _$aPIErrorCodeEnum_TOO_LONG;
  @BuiltValueEnumConst(wireName: r'TOO_SHORT')
  static const APIErrorCodeEnum TOO_SHORT = _$aPIErrorCodeEnum_TOO_SHORT;

  static Serializer<APIErrorCodeEnum> get serializer =>
      _$aPIErrorCodeEnumSerializer;

  const APIErrorCodeEnum._(String name) : super(name);

  static BuiltSet<APIErrorCodeEnum> get values => _$aPIErrorCodeEnumValues;
  static APIErrorCodeEnum valueOf(String name) =>
      _$aPIErrorCodeEnumValueOf(name);
}
