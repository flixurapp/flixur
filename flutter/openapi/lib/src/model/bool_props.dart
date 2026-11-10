//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'bool_props.g.dart';

/// BoolProps
///
/// Properties:
/// * [default_]
@BuiltValue()
abstract class BoolProps implements Built<BoolProps, BoolPropsBuilder> {
  @BuiltValueField(wireName: r'default')
  bool get default_;

  BoolProps._();

  factory BoolProps([void updates(BoolPropsBuilder b)]) = _$BoolProps;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(BoolPropsBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<BoolProps> get serializer => _$BoolPropsSerializer();
}

class _$BoolPropsSerializer implements PrimitiveSerializer<BoolProps> {
  @override
  final Iterable<Type> types = const [BoolProps, _$BoolProps];

  @override
  final String wireName = r'BoolProps';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    BoolProps object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'default';
    yield serializers.serialize(
      object.default_,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    BoolProps object, {
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
    required BoolPropsBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'default':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
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
  BoolProps deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = BoolPropsBuilder();
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
