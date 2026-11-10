//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/settings_definition.dart';
import 'package:built_collection/built_collection.dart';
import 'package:openapi/src/model/settings_group.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'settings_definitions_body.g.dart';

/// SettingsDefinitionsBody
///
/// Properties:
/// * [dollarSchema] - A URL to the JSON Schema for this object.
/// * [groups]
/// * [list]
@BuiltValue()
abstract class SettingsDefinitionsBody
    implements Built<SettingsDefinitionsBody, SettingsDefinitionsBodyBuilder> {
  /// A URL to the JSON Schema for this object.
  @BuiltValueField(wireName: r'$schema')
  String? get dollarSchema;

  @BuiltValueField(wireName: r'groups')
  BuiltList<SettingsGroup> get groups;

  @BuiltValueField(wireName: r'list')
  BuiltList<SettingsDefinition> get list;

  SettingsDefinitionsBody._();

  factory SettingsDefinitionsBody(
          [void updates(SettingsDefinitionsBodyBuilder b)]) =
      _$SettingsDefinitionsBody;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SettingsDefinitionsBodyBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SettingsDefinitionsBody> get serializer =>
      _$SettingsDefinitionsBodySerializer();
}

class _$SettingsDefinitionsBodySerializer
    implements PrimitiveSerializer<SettingsDefinitionsBody> {
  @override
  final Iterable<Type> types = const [
    SettingsDefinitionsBody,
    _$SettingsDefinitionsBody
  ];

  @override
  final String wireName = r'SettingsDefinitionsBody';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SettingsDefinitionsBody object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.dollarSchema != null) {
      yield r'$schema';
      yield serializers.serialize(
        object.dollarSchema,
        specifiedType: const FullType(String),
      );
    }
    yield r'groups';
    yield serializers.serialize(
      object.groups,
      specifiedType: const FullType(BuiltList, [FullType(SettingsGroup)]),
    );
    yield r'list';
    yield serializers.serialize(
      object.list,
      specifiedType: const FullType(BuiltList, [FullType(SettingsDefinition)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    SettingsDefinitionsBody object, {
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
    required SettingsDefinitionsBodyBuilder result,
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
        case r'groups':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(SettingsGroup)]),
          ) as BuiltList<SettingsGroup>;
          result.groups.replace(valueDes);
          break;
        case r'list':
          final valueDes = serializers.deserialize(
            value,
            specifiedType:
                const FullType(BuiltList, [FullType(SettingsDefinition)]),
          ) as BuiltList<SettingsDefinition>;
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
  SettingsDefinitionsBody deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SettingsDefinitionsBodyBuilder();
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
