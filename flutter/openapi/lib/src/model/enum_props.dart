//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:openapi/src/model/settings_choice.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'enum_props.g.dart';

/// EnumProps
///
/// Properties:
/// * [choices]
/// * [defaultValue]
@BuiltValue()
abstract class EnumProps implements Built<EnumProps, EnumPropsBuilder> {
  @BuiltValueField(wireName: r'choices')
  BuiltList<SettingsChoice>? get choices;

  @BuiltValueField(wireName: r'default_value')
  String get defaultValue;

  EnumProps._();

  factory EnumProps([void updates(EnumPropsBuilder b)]) = _$EnumProps;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(EnumPropsBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<EnumProps> get serializer => _$EnumPropsSerializer();
}

class _$EnumPropsSerializer implements PrimitiveSerializer<EnumProps> {
  @override
  final Iterable<Type> types = const [EnumProps, _$EnumProps];

  @override
  final String wireName = r'EnumProps';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    EnumProps object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.choices != null) {
      yield r'choices';
      yield serializers.serialize(
        object.choices,
        specifiedType:
            const FullType.nullable(BuiltList, [FullType(SettingsChoice)]),
      );
    }
    yield r'default_value';
    yield serializers.serialize(
      object.defaultValue,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    EnumProps object, {
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
    required EnumPropsBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'choices':
          final valueDes = serializers.deserialize(
            value,
            specifiedType:
                const FullType.nullable(BuiltList, [FullType(SettingsChoice)]),
          ) as BuiltList<SettingsChoice>?;
          if (valueDes == null) continue;
          result.choices.replace(valueDes);
          break;
        case r'default_value':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.defaultValue = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  EnumProps deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = EnumPropsBuilder();
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
