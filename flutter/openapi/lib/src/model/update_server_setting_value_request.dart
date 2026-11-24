//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'update_server_setting_value_request.g.dart';

/// UpdateServerSettingValueRequest
///
/// Properties:
/// * [dollarSchema] - A URL to the JSON Schema for this object.
/// * [value]
@BuiltValue()
abstract class UpdateServerSettingValueRequest
    implements
        Built<UpdateServerSettingValueRequest,
            UpdateServerSettingValueRequestBuilder> {
  /// A URL to the JSON Schema for this object.
  @BuiltValueField(wireName: r'$schema')
  String? get dollarSchema;

  @BuiltValueField(wireName: r'value')
  String get value;

  UpdateServerSettingValueRequest._();

  factory UpdateServerSettingValueRequest(
          [void updates(UpdateServerSettingValueRequestBuilder b)]) =
      _$UpdateServerSettingValueRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UpdateServerSettingValueRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<UpdateServerSettingValueRequest> get serializer =>
      _$UpdateServerSettingValueRequestSerializer();
}

class _$UpdateServerSettingValueRequestSerializer
    implements PrimitiveSerializer<UpdateServerSettingValueRequest> {
  @override
  final Iterable<Type> types = const [
    UpdateServerSettingValueRequest,
    _$UpdateServerSettingValueRequest
  ];

  @override
  final String wireName = r'UpdateServerSettingValueRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UpdateServerSettingValueRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.dollarSchema != null) {
      yield r'$schema';
      yield serializers.serialize(
        object.dollarSchema,
        specifiedType: const FullType(String),
      );
    }
    yield r'value';
    yield serializers.serialize(
      object.value,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    UpdateServerSettingValueRequest object, {
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
    required UpdateServerSettingValueRequestBuilder result,
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
        case r'value':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.value = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  UpdateServerSettingValueRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UpdateServerSettingValueRequestBuilder();
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
