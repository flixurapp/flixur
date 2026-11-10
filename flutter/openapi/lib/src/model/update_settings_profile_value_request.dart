//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'update_settings_profile_value_request.g.dart';

/// UpdateSettingsProfileValueRequest
///
/// Properties:
/// * [dollarSchema] - A URL to the JSON Schema for this object.
/// * [value]
@BuiltValue()
abstract class UpdateSettingsProfileValueRequest
    implements
        Built<UpdateSettingsProfileValueRequest,
            UpdateSettingsProfileValueRequestBuilder> {
  /// A URL to the JSON Schema for this object.
  @BuiltValueField(wireName: r'$schema')
  String? get dollarSchema;

  @BuiltValueField(wireName: r'value')
  String get value;

  UpdateSettingsProfileValueRequest._();

  factory UpdateSettingsProfileValueRequest(
          [void updates(UpdateSettingsProfileValueRequestBuilder b)]) =
      _$UpdateSettingsProfileValueRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UpdateSettingsProfileValueRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<UpdateSettingsProfileValueRequest> get serializer =>
      _$UpdateSettingsProfileValueRequestSerializer();
}

class _$UpdateSettingsProfileValueRequestSerializer
    implements PrimitiveSerializer<UpdateSettingsProfileValueRequest> {
  @override
  final Iterable<Type> types = const [
    UpdateSettingsProfileValueRequest,
    _$UpdateSettingsProfileValueRequest
  ];

  @override
  final String wireName = r'UpdateSettingsProfileValueRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UpdateSettingsProfileValueRequest object, {
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
    UpdateSettingsProfileValueRequest object, {
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
    required UpdateSettingsProfileValueRequestBuilder result,
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
  UpdateSettingsProfileValueRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UpdateSettingsProfileValueRequestBuilder();
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
