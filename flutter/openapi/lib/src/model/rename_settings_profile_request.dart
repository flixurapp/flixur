//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'rename_settings_profile_request.g.dart';

/// RenameSettingsProfileRequest
///
/// Properties:
/// * [dollarSchema] - A URL to the JSON Schema for this object.
/// * [name]
@BuiltValue()
abstract class RenameSettingsProfileRequest
    implements
        Built<RenameSettingsProfileRequest,
            RenameSettingsProfileRequestBuilder> {
  /// A URL to the JSON Schema for this object.
  @BuiltValueField(wireName: r'$schema')
  String? get dollarSchema;

  @BuiltValueField(wireName: r'name')
  String get name;

  RenameSettingsProfileRequest._();

  factory RenameSettingsProfileRequest(
          [void updates(RenameSettingsProfileRequestBuilder b)]) =
      _$RenameSettingsProfileRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(RenameSettingsProfileRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<RenameSettingsProfileRequest> get serializer =>
      _$RenameSettingsProfileRequestSerializer();
}

class _$RenameSettingsProfileRequestSerializer
    implements PrimitiveSerializer<RenameSettingsProfileRequest> {
  @override
  final Iterable<Type> types = const [
    RenameSettingsProfileRequest,
    _$RenameSettingsProfileRequest
  ];

  @override
  final String wireName = r'RenameSettingsProfileRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    RenameSettingsProfileRequest object, {
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
    RenameSettingsProfileRequest object, {
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
    required RenameSettingsProfileRequestBuilder result,
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
  RenameSettingsProfileRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = RenameSettingsProfileRequestBuilder();
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
