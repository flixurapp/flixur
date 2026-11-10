//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'output_success_body.g.dart';

/// OutputSuccessBody
///
/// Properties:
/// * [dollarSchema] - A URL to the JSON Schema for this object.
/// * [success]
@BuiltValue()
abstract class OutputSuccessBody
    implements Built<OutputSuccessBody, OutputSuccessBodyBuilder> {
  /// A URL to the JSON Schema for this object.
  @BuiltValueField(wireName: r'$schema')
  String? get dollarSchema;

  @BuiltValueField(wireName: r'success')
  bool get success;

  OutputSuccessBody._();

  factory OutputSuccessBody([void updates(OutputSuccessBodyBuilder b)]) =
      _$OutputSuccessBody;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(OutputSuccessBodyBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<OutputSuccessBody> get serializer =>
      _$OutputSuccessBodySerializer();
}

class _$OutputSuccessBodySerializer
    implements PrimitiveSerializer<OutputSuccessBody> {
  @override
  final Iterable<Type> types = const [OutputSuccessBody, _$OutputSuccessBody];

  @override
  final String wireName = r'OutputSuccessBody';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    OutputSuccessBody object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.dollarSchema != null) {
      yield r'$schema';
      yield serializers.serialize(
        object.dollarSchema,
        specifiedType: const FullType(String),
      );
    }
    yield r'success';
    yield serializers.serialize(
      object.success,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    OutputSuccessBody object, {
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
    required OutputSuccessBodyBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'$schema':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.dollarSchema = valueDes;
          break;
        case r'success':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.success = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  OutputSuccessBody deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = OutputSuccessBodyBuilder();
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
