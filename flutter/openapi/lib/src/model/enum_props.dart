//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:openapi/src/model/choice_spec.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'enum_props.g.dart';

/// EnumProps
///
/// Properties:
/// * [choices]
/// * [default_]
@BuiltValue()
abstract class EnumProps implements Built<EnumProps, EnumPropsBuilder> {
  @BuiltValueField(wireName: r'choices')
  BuiltList<ChoiceSpec>? get choices;

  @BuiltValueField(wireName: r'default')
  String get default_;

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
    yield r'choices';
    yield object.choices == null
        ? null
        : serializers.serialize(
            object.choices,
            specifiedType:
                const FullType.nullable(BuiltList, [FullType(ChoiceSpec)]),
          );
    yield r'default';
    yield serializers.serialize(
      object.default_,
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
                const FullType.nullable(BuiltList, [FullType(ChoiceSpec)]),
          ) as BuiltList<ChoiceSpec>?;
          if (valueDes == null) continue;
          result.choices.replace(valueDes);
          break;
        case r'default':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.default_ = valueDes;
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
