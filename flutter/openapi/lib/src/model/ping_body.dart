//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'ping_body.g.dart';

/// PingBody
///
/// Properties:
/// * [dollarSchema] - A URL to the JSON Schema for this object.
/// * [isSetup]
/// * [protocolVersion]
/// * [supportsOIDCLogin]
/// * [supportsPasswordLogin]
/// * [version]
@BuiltValue()
abstract class PingBody implements Built<PingBody, PingBodyBuilder> {
  /// A URL to the JSON Schema for this object.
  @BuiltValueField(wireName: r'$schema')
  String? get dollarSchema;

  @BuiltValueField(wireName: r'isSetup')
  bool get isSetup;

  @BuiltValueField(wireName: r'protocolVersion')
  int get protocolVersion;

  @BuiltValueField(wireName: r'supportsOIDCLogin')
  String get supportsOIDCLogin;

  @BuiltValueField(wireName: r'supportsPasswordLogin')
  bool get supportsPasswordLogin;

  @BuiltValueField(wireName: r'version')
  String get version;

  PingBody._();

  factory PingBody([void updates(PingBodyBuilder b)]) = _$PingBody;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PingBodyBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PingBody> get serializer => _$PingBodySerializer();
}

class _$PingBodySerializer implements PrimitiveSerializer<PingBody> {
  @override
  final Iterable<Type> types = const [PingBody, _$PingBody];

  @override
  final String wireName = r'PingBody';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PingBody object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.dollarSchema != null) {
      yield r'$schema';
      yield serializers.serialize(
        object.dollarSchema,
        specifiedType: const FullType(String),
      );
    }
    yield r'isSetup';
    yield serializers.serialize(
      object.isSetup,
      specifiedType: const FullType(bool),
    );
    yield r'protocolVersion';
    yield serializers.serialize(
      object.protocolVersion,
      specifiedType: const FullType(int),
    );
    yield r'supportsOIDCLogin';
    yield serializers.serialize(
      object.supportsOIDCLogin,
      specifiedType: const FullType(String),
    );
    yield r'supportsPasswordLogin';
    yield serializers.serialize(
      object.supportsPasswordLogin,
      specifiedType: const FullType(bool),
    );
    yield r'version';
    yield serializers.serialize(
      object.version,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PingBody object, {
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
    required PingBodyBuilder result,
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
        case r'isSetup':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.isSetup = valueDes;
          break;
        case r'protocolVersion':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.protocolVersion = valueDes;
          break;
        case r'supportsOIDCLogin':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.supportsOIDCLogin = valueDes;
          break;
        case r'supportsPasswordLogin':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.supportsPasswordLogin = valueDes;
          break;
        case r'version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.version = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PingBody deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PingBodyBuilder();
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
