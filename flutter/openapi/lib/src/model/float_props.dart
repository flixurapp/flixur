//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'float_props.g.dart';

/// FloatProps
///
/// Properties:
/// * [defaultValue]
/// * [max]
/// * [min]
/// * [recommendedMax]
/// * [recommendedMin]
/// * [step]
@BuiltValue()
abstract class FloatProps implements Built<FloatProps, FloatPropsBuilder> {
  @BuiltValueField(wireName: r'default_value')
  double get defaultValue;

  @BuiltValueField(wireName: r'max')
  double? get max;

  @BuiltValueField(wireName: r'min')
  double? get min;

  @BuiltValueField(wireName: r'recommended_max')
  double? get recommendedMax;

  @BuiltValueField(wireName: r'recommended_min')
  double? get recommendedMin;

  @BuiltValueField(wireName: r'step')
  double? get step;

  FloatProps._();

  factory FloatProps([void updates(FloatPropsBuilder b)]) = _$FloatProps;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(FloatPropsBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<FloatProps> get serializer => _$FloatPropsSerializer();
}

class _$FloatPropsSerializer implements PrimitiveSerializer<FloatProps> {
  @override
  final Iterable<Type> types = const [FloatProps, _$FloatProps];

  @override
  final String wireName = r'FloatProps';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    FloatProps object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'default_value';
    yield serializers.serialize(
      object.defaultValue,
      specifiedType: const FullType(double),
    );
    if (object.max != null) {
      yield r'max';
      yield serializers.serialize(
        object.max,
        specifiedType: const FullType(double),
      );
    }
    if (object.min != null) {
      yield r'min';
      yield serializers.serialize(
        object.min,
        specifiedType: const FullType(double),
      );
    }
    if (object.recommendedMax != null) {
      yield r'recommended_max';
      yield serializers.serialize(
        object.recommendedMax,
        specifiedType: const FullType(double),
      );
    }
    if (object.recommendedMin != null) {
      yield r'recommended_min';
      yield serializers.serialize(
        object.recommendedMin,
        specifiedType: const FullType(double),
      );
    }
    if (object.step != null) {
      yield r'step';
      yield serializers.serialize(
        object.step,
        specifiedType: const FullType(double),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    FloatProps object, {
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
    required FloatPropsBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'default_value':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(double),
          ) as double;
          result.defaultValue = valueDes;
          break;
        case r'max':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(double),
          ) as double?;
          if (valueDes == null) continue;
          result.max = valueDes;
          break;
        case r'min':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(double),
          ) as double?;
          if (valueDes == null) continue;
          result.min = valueDes;
          break;
        case r'recommended_max':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(double),
          ) as double?;
          if (valueDes == null) continue;
          result.recommendedMax = valueDes;
          break;
        case r'recommended_min':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(double),
          ) as double?;
          if (valueDes == null) continue;
          result.recommendedMin = valueDes;
          break;
        case r'step':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(double),
          ) as double?;
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
  FloatProps deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = FloatPropsBuilder();
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
