//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:openapi/src/model/setting_profile_body.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'settings_profiles_body.g.dart';

/// SettingsProfilesBody
///
/// Properties:
/// * [dollarSchema] - A URL to the JSON Schema for this object.
/// * [list]
@BuiltValue()
abstract class SettingsProfilesBody
    implements Built<SettingsProfilesBody, SettingsProfilesBodyBuilder> {
  /// A URL to the JSON Schema for this object.
  @BuiltValueField(wireName: r'$schema')
  String? get dollarSchema;

  @BuiltValueField(wireName: r'list')
  BuiltList<SettingProfileBody> get list;

  SettingsProfilesBody._();

  factory SettingsProfilesBody([void updates(SettingsProfilesBodyBuilder b)]) =
      _$SettingsProfilesBody;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SettingsProfilesBodyBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SettingsProfilesBody> get serializer =>
      _$SettingsProfilesBodySerializer();
}

class _$SettingsProfilesBodySerializer
    implements PrimitiveSerializer<SettingsProfilesBody> {
  @override
  final Iterable<Type> types = const [
    SettingsProfilesBody,
    _$SettingsProfilesBody
  ];

  @override
  final String wireName = r'SettingsProfilesBody';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SettingsProfilesBody object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.dollarSchema != null) {
      yield r'$schema';
      yield serializers.serialize(
        object.dollarSchema,
        specifiedType: const FullType(String),
      );
    }
    yield r'list';
    yield serializers.serialize(
      object.list,
      specifiedType: const FullType(BuiltList, [FullType(SettingProfileBody)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    SettingsProfilesBody object, {
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
    required SettingsProfilesBodyBuilder result,
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
        case r'list':
          final valueDes = serializers.deserialize(
            value,
            specifiedType:
                const FullType(BuiltList, [FullType(SettingProfileBody)]),
          ) as BuiltList<SettingProfileBody>;
          result.list.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SettingsProfilesBody deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SettingsProfilesBodyBuilder();
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
