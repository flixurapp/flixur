//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:openapi/src/model/error_detail.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'error_model.g.dart';

/// ErrorModel
///
/// Properties:
/// * [dollarSchema] - A URL to the JSON Schema for this object.
/// * [detail] - A human-readable explanation specific to this occurrence of the problem.
/// * [errors] - Optional list of individual error details
/// * [instance] - A URI reference that identifies the specific occurrence of the problem.
/// * [status] - HTTP status code
/// * [title] - A short, human-readable summary of the problem type. This value should not change between occurrences of the error.
/// * [type] - A URI reference to human-readable documentation for the error.
@BuiltValue()
abstract class ErrorModel implements Built<ErrorModel, ErrorModelBuilder> {
  /// A URL to the JSON Schema for this object.
  @BuiltValueField(wireName: r'$schema')
  String? get dollarSchema;

  /// A human-readable explanation specific to this occurrence of the problem.
  @BuiltValueField(wireName: r'detail')
  String? get detail;

  /// Optional list of individual error details
  @BuiltValueField(wireName: r'errors')
  BuiltList<ErrorDetail>? get errors;

  /// A URI reference that identifies the specific occurrence of the problem.
  @BuiltValueField(wireName: r'instance')
  String? get instance;

  /// HTTP status code
  @BuiltValueField(wireName: r'status')
  int? get status;

  /// A short, human-readable summary of the problem type. This value should not change between occurrences of the error.
  @BuiltValueField(wireName: r'title')
  String? get title;

  /// A URI reference to human-readable documentation for the error.
  @BuiltValueField(wireName: r'type')
  String? get type;

  ErrorModel._();

  factory ErrorModel([void updates(ErrorModelBuilder b)]) = _$ErrorModel;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ErrorModelBuilder b) => b..type = 'about:blank';

  @BuiltValueSerializer(custom: true)
  static Serializer<ErrorModel> get serializer => _$ErrorModelSerializer();
}

class _$ErrorModelSerializer implements PrimitiveSerializer<ErrorModel> {
  @override
  final Iterable<Type> types = const [ErrorModel, _$ErrorModel];

  @override
  final String wireName = r'ErrorModel';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ErrorModel object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.dollarSchema != null) {
      yield r'$schema';
      yield serializers.serialize(
        object.dollarSchema,
        specifiedType: const FullType(String),
      );
    }
    if (object.detail != null) {
      yield r'detail';
      yield serializers.serialize(
        object.detail,
        specifiedType: const FullType(String),
      );
    }
    if (object.errors != null) {
      yield r'errors';
      yield serializers.serialize(
        object.errors,
        specifiedType:
            const FullType.nullable(BuiltList, [FullType(ErrorDetail)]),
      );
    }
    if (object.instance != null) {
      yield r'instance';
      yield serializers.serialize(
        object.instance,
        specifiedType: const FullType(String),
      );
    }
    if (object.status != null) {
      yield r'status';
      yield serializers.serialize(
        object.status,
        specifiedType: const FullType(int),
      );
    }
    if (object.title != null) {
      yield r'title';
      yield serializers.serialize(
        object.title,
        specifiedType: const FullType(String),
      );
    }
    if (object.type != null) {
      yield r'type';
      yield serializers.serialize(
        object.type,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ErrorModel object, {
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
    required ErrorModelBuilder result,
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
        case r'detail':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.detail = valueDes;
          break;
        case r'errors':
          final valueDes = serializers.deserialize(
            value,
            specifiedType:
                const FullType.nullable(BuiltList, [FullType(ErrorDetail)]),
          ) as BuiltList<ErrorDetail>?;
          if (valueDes == null) continue;
          result.errors.replace(valueDes);
          break;
        case r'instance':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.instance = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.status = valueDes;
          break;
        case r'title':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.title = valueDes;
          break;
        case r'type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.type = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ErrorModel deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ErrorModelBuilder();
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
