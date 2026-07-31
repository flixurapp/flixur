//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'session_token_body.g.dart';

/// SessionTokenBody
///
/// Properties:
/// * [dollarSchema] - A URL to the JSON Schema for this object.
/// * [sessionToken]
@BuiltValue()
abstract class SessionTokenBody
    implements Built<SessionTokenBody, SessionTokenBodyBuilder> {
  /// A URL to the JSON Schema for this object.
  @BuiltValueField(wireName: r'$schema')
  String? get dollarSchema;

  @BuiltValueField(wireName: r'sessionToken')
  String get sessionToken;

  SessionTokenBody._();

  factory SessionTokenBody([void updates(SessionTokenBodyBuilder b)]) =
      _$SessionTokenBody;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SessionTokenBodyBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SessionTokenBody> get serializer =>
      _$SessionTokenBodySerializer();
}

class _$SessionTokenBodySerializer
    implements PrimitiveSerializer<SessionTokenBody> {
  @override
  final Iterable<Type> types = const [SessionTokenBody, _$SessionTokenBody];

  @override
  final String wireName = r'SessionTokenBody';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SessionTokenBody object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.dollarSchema != null) {
      yield r'$schema';
      yield serializers.serialize(
        object.dollarSchema,
        specifiedType: const FullType(String),
      );
    }
    yield r'sessionToken';
    yield serializers.serialize(
      object.sessionToken,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    SessionTokenBody object, {
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
    required SessionTokenBodyBuilder result,
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
        case r'sessionToken':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.sessionToken = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SessionTokenBody deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SessionTokenBodyBuilder();
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
