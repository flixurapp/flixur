//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:openapi/src/model/settings_choice.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'string_list_props.g.dart';

/// StringListProps
///
/// Properties:
/// * [allowDuplicates]
/// * [choices]
/// * [defaultValue]
/// * [maxItems]
@BuiltValue()
abstract class StringListProps
    implements Built<StringListProps, StringListPropsBuilder> {
  @BuiltValueField(wireName: r'allow_duplicates')
  bool? get allowDuplicates;

  @BuiltValueField(wireName: r'choices')
  BuiltList<SettingsChoice>? get choices;

  @BuiltValueField(wireName: r'default_value')
  BuiltList<String>? get defaultValue;

  @BuiltValueField(wireName: r'max_items')
  int? get maxItems;

  StringListProps._();

  factory StringListProps([void updates(StringListPropsBuilder b)]) =
      _$StringListProps;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(StringListPropsBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<StringListProps> get serializer =>
      _$StringListPropsSerializer();
}

class _$StringListPropsSerializer
    implements PrimitiveSerializer<StringListProps> {
  @override
  final Iterable<Type> types = const [StringListProps, _$StringListProps];

  @override
  final String wireName = r'StringListProps';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    StringListProps object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.allowDuplicates != null) {
      yield r'allow_duplicates';
      yield serializers.serialize(
        object.allowDuplicates,
        specifiedType: const FullType(bool),
      );
    }
    if (object.choices != null) {
      yield r'choices';
      yield serializers.serialize(
        object.choices,
        specifiedType:
            const FullType.nullable(BuiltList, [FullType(SettingsChoice)]),
      );
    }
    yield r'default_value';
    yield object.defaultValue == null
        ? null
        : serializers.serialize(
            object.defaultValue,
            specifiedType:
                const FullType.nullable(BuiltList, [FullType(String)]),
          );
    if (object.maxItems != null) {
      yield r'max_items';
      yield serializers.serialize(
        object.maxItems,
        specifiedType: const FullType(int),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    StringListProps object, {
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
    required StringListPropsBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'allow_duplicates':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.allowDuplicates = valueDes;
          break;
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
            specifiedType:
                const FullType.nullable(BuiltList, [FullType(String)]),
          ) as BuiltList<String>?;
          if (valueDes == null) continue;
          result.defaultValue.replace(valueDes);
          break;
        case r'max_items':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.maxItems = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  StringListProps deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = StringListPropsBuilder();
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
