//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'string_props.g.dart';

/// StringProps
///
/// Properties:
/// * [default_]
/// * [maxLength]
/// * [secret]
@BuiltValue()
abstract class StringProps implements Built<StringProps, StringPropsBuilder> {
  @BuiltValueField(wireName: r'default')
  String? get default_;

  @BuiltValueField(wireName: r'maxLength')
  int? get maxLength;

  @BuiltValueField(wireName: r'secret')
  bool? get secret;

  StringProps._();

  factory StringProps([void updates(StringPropsBuilder b)]) = _$StringProps;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(StringPropsBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<StringProps> get serializer => _$StringPropsSerializer();
}

class _$StringPropsSerializer implements PrimitiveSerializer<StringProps> {
  @override
  final Iterable<Type> types = const [StringProps, _$StringProps];

  @override
  final String wireName = r'StringProps';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    StringProps object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.default_ != null) {
      yield r'default';
      yield serializers.serialize(
        object.default_,
        specifiedType: const FullType(String),
      );
    }
    if (object.maxLength != null) {
      yield r'maxLength';
      yield serializers.serialize(
        object.maxLength,
        specifiedType: const FullType(int),
      );
    }
    if (object.secret != null) {
      yield r'secret';
      yield serializers.serialize(
        object.secret,
        specifiedType: const FullType(bool),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    StringProps object, {
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
    required StringPropsBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'default':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.default_ = valueDes;
          break;
        case r'maxLength':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.maxLength = valueDes;
          break;
        case r'secret':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.secret = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  StringProps deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = StringPropsBuilder();
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
