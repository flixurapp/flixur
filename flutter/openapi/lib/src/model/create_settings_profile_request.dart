//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'create_settings_profile_request.g.dart';

/// CreateSettingsProfileRequest
///
/// Properties:
/// * [dollarSchema] - A URL to the JSON Schema for this object.
/// * [name]
@BuiltValue()
abstract class CreateSettingsProfileRequest
    implements
        Built<CreateSettingsProfileRequest,
            CreateSettingsProfileRequestBuilder> {
  /// A URL to the JSON Schema for this object.
  @BuiltValueField(wireName: r'$schema')
  String? get dollarSchema;

  @BuiltValueField(wireName: r'name')
  String get name;

  CreateSettingsProfileRequest._();

  factory CreateSettingsProfileRequest(
          [void updates(CreateSettingsProfileRequestBuilder b)]) =
      _$CreateSettingsProfileRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CreateSettingsProfileRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CreateSettingsProfileRequest> get serializer =>
      _$CreateSettingsProfileRequestSerializer();
}

class _$CreateSettingsProfileRequestSerializer
    implements PrimitiveSerializer<CreateSettingsProfileRequest> {
  @override
  final Iterable<Type> types = const [
    CreateSettingsProfileRequest,
    _$CreateSettingsProfileRequest
  ];

  @override
  final String wireName = r'CreateSettingsProfileRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CreateSettingsProfileRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.dollarSchema != null) {
      yield r'$schema';
      yield serializers.serialize(
        object.dollarSchema,
        specifiedType: const FullType(String),
      );
    }
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CreateSettingsProfileRequest object, {
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
    required CreateSettingsProfileRequestBuilder result,
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
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CreateSettingsProfileRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CreateSettingsProfileRequestBuilder();
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
