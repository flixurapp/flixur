//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'choice_spec.g.dart';

/// ChoiceSpec
///
/// Properties:
/// * [hasDescription]
/// * [icon]
/// * [value]
@BuiltValue()
abstract class ChoiceSpec implements Built<ChoiceSpec, ChoiceSpecBuilder> {
  @BuiltValueField(wireName: r'hasDescription')
  bool? get hasDescription;

  @BuiltValueField(wireName: r'icon')
  String? get icon;

  @BuiltValueField(wireName: r'value')
  String get value;

  ChoiceSpec._();

  factory ChoiceSpec([void updates(ChoiceSpecBuilder b)]) = _$ChoiceSpec;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ChoiceSpecBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ChoiceSpec> get serializer => _$ChoiceSpecSerializer();
}

class _$ChoiceSpecSerializer implements PrimitiveSerializer<ChoiceSpec> {
  @override
  final Iterable<Type> types = const [ChoiceSpec, _$ChoiceSpec];

  @override
  final String wireName = r'ChoiceSpec';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ChoiceSpec object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.hasDescription != null) {
      yield r'hasDescription';
      yield serializers.serialize(
        object.hasDescription,
        specifiedType: const FullType(bool),
      );
    }
    if (object.icon != null) {
      yield r'icon';
      yield serializers.serialize(
        object.icon,
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
    ChoiceSpec object, {
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
    required ChoiceSpecBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'hasDescription':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.hasDescription = valueDes;
          break;
        case r'icon':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.icon = valueDes;
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
  ChoiceSpec deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ChoiceSpecBuilder();
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
