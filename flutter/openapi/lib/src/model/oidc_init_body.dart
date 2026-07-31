//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'oidc_init_body.g.dart';

/// OIDCInitBody
///
/// Properties:
/// * [dollarSchema] - A URL to the JSON Schema for this object.
/// * [loginURL]
@BuiltValue()
abstract class OIDCInitBody
    implements Built<OIDCInitBody, OIDCInitBodyBuilder> {
  /// A URL to the JSON Schema for this object.
  @BuiltValueField(wireName: r'$schema')
  String? get dollarSchema;

  @BuiltValueField(wireName: r'loginURL')
  String get loginURL;

  OIDCInitBody._();

  factory OIDCInitBody([void updates(OIDCInitBodyBuilder b)]) = _$OIDCInitBody;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(OIDCInitBodyBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<OIDCInitBody> get serializer => _$OIDCInitBodySerializer();
}

class _$OIDCInitBodySerializer implements PrimitiveSerializer<OIDCInitBody> {
  @override
  final Iterable<Type> types = const [OIDCInitBody, _$OIDCInitBody];

  @override
  final String wireName = r'OIDCInitBody';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    OIDCInitBody object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.dollarSchema != null) {
      yield r'$schema';
      yield serializers.serialize(
        object.dollarSchema,
        specifiedType: const FullType(String),
      );
    }
    yield r'loginURL';
    yield serializers.serialize(
      object.loginURL,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    OIDCInitBody object, {
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
    required OIDCInitBodyBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'$schema':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.dollarSchema = valueDes;
          break;
        case r'loginURL':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.loginURL = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  OIDCInitBody deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = OIDCInitBodyBuilder();
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
