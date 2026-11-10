//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'int_props.g.dart';

/// IntProps
///
/// Properties:
/// * [defaultValue]
/// * [max]
/// * [min]
/// * [recommendedMax]
/// * [recommendedMin]
/// * [step]
@BuiltValue()
abstract class IntProps implements Built<IntProps, IntPropsBuilder> {
  @BuiltValueField(wireName: r'defaultValue')
  int get defaultValue;

  @BuiltValueField(wireName: r'max')
  int? get max;

  @BuiltValueField(wireName: r'min')
  int? get min;

  @BuiltValueField(wireName: r'recommendedMax')
  int? get recommendedMax;

  @BuiltValueField(wireName: r'recommendedMin')
  int? get recommendedMin;

  @BuiltValueField(wireName: r'step')
  int? get step;

  IntProps._();

  factory IntProps([void updates(IntPropsBuilder b)]) = _$IntProps;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(IntPropsBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<IntProps> get serializer => _$IntPropsSerializer();
}

class _$IntPropsSerializer implements PrimitiveSerializer<IntProps> {
  @override
  final Iterable<Type> types = const [IntProps, _$IntProps];

  @override
  final String wireName = r'IntProps';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    IntProps object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'defaultValue';
    yield serializers.serialize(
      object.defaultValue,
      specifiedType: const FullType(int),
    );
    if (object.max != null) {
      yield r'max';
      yield serializers.serialize(
        object.max,
        specifiedType: const FullType(int),
      );
    }
    if (object.min != null) {
      yield r'min';
      yield serializers.serialize(
        object.min,
        specifiedType: const FullType(int),
      );
    }
    if (object.recommendedMax != null) {
      yield r'recommendedMax';
      yield serializers.serialize(
        object.recommendedMax,
        specifiedType: const FullType(int),
      );
    }
    if (object.recommendedMin != null) {
      yield r'recommendedMin';
      yield serializers.serialize(
        object.recommendedMin,
        specifiedType: const FullType(int),
      );
    }
    if (object.step != null) {
      yield r'step';
      yield serializers.serialize(
        object.step,
        specifiedType: const FullType(int),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    IntProps object, {
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
    required IntPropsBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'defaultValue':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.defaultValue = valueDes;
          break;
        case r'max':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.max = valueDes;
          break;
        case r'min':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.min = valueDes;
          break;
        case r'recommendedMax':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.recommendedMax = valueDes;
          break;
        case r'recommendedMin':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.recommendedMin = valueDes;
          break;
        case r'step':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.step = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  IntProps deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = IntPropsBuilder();
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
