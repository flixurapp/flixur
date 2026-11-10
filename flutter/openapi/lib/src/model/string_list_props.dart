//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:openapi/src/model/choice_spec.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'string_list_props.g.dart';

/// StringListProps
///
/// Properties:
/// * [choices]
/// * [default_]
/// * [maxItems]
@BuiltValue()
abstract class StringListProps
    implements Built<StringListProps, StringListPropsBuilder> {
  @BuiltValueField(wireName: r'choices')
  BuiltList<ChoiceSpec>? get choices;

  @BuiltValueField(wireName: r'default')
  BuiltList<String>? get default_;

  @BuiltValueField(wireName: r'maxItems')
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
    yield r'choices';
    yield object.choices == null
        ? null
        : serializers.serialize(
            object.choices,
            specifiedType:
                const FullType.nullable(BuiltList, [FullType(ChoiceSpec)]),
          );
    yield r'default';
    yield object.default_ == null
        ? null
        : serializers.serialize(
            object.default_,
            specifiedType:
                const FullType.nullable(BuiltList, [FullType(String)]),
          );
    if (object.maxItems != null) {
      yield r'maxItems';
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
        case r'choices':
          final valueDes = serializers.deserialize(
            value,
            specifiedType:
                const FullType.nullable(BuiltList, [FullType(ChoiceSpec)]),
          ) as BuiltList<ChoiceSpec>?;
          if (valueDes == null) continue;
          result.choices.replace(valueDes);
          break;
        case r'default':
          final valueDes = serializers.deserialize(
            value,
            specifiedType:
                const FullType.nullable(BuiltList, [FullType(String)]),
          ) as BuiltList<String>?;
          if (valueDes == null) continue;
          result.default_.replace(valueDes);
          break;
        case r'maxItems':
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
