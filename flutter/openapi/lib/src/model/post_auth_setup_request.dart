//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'post_auth_setup_request.g.dart';

/// PostAuthSetupRequest
///
/// Properties:
/// * [dollarSchema] - A URL to the JSON Schema for this object.
/// * [code]
/// * [password]
/// * [username]
@BuiltValue()
abstract class PostAuthSetupRequest
    implements Built<PostAuthSetupRequest, PostAuthSetupRequestBuilder> {
  /// A URL to the JSON Schema for this object.
  @BuiltValueField(wireName: r'$schema')
  String? get dollarSchema;

  @BuiltValueField(wireName: r'code')
  String get code;

  @BuiltValueField(wireName: r'password')
  String get password;

  @BuiltValueField(wireName: r'username')
  String get username;

  PostAuthSetupRequest._();

  factory PostAuthSetupRequest([void updates(PostAuthSetupRequestBuilder b)]) =
      _$PostAuthSetupRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PostAuthSetupRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PostAuthSetupRequest> get serializer =>
      _$PostAuthSetupRequestSerializer();
}

class _$PostAuthSetupRequestSerializer
    implements PrimitiveSerializer<PostAuthSetupRequest> {
  @override
  final Iterable<Type> types = const [
    PostAuthSetupRequest,
    _$PostAuthSetupRequest
  ];

  @override
  final String wireName = r'PostAuthSetupRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PostAuthSetupRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.dollarSchema != null) {
      yield r'$schema';
      yield serializers.serialize(
        object.dollarSchema,
        specifiedType: const FullType(String),
      );
    }
    yield r'code';
    yield serializers.serialize(
      object.code,
      specifiedType: const FullType(String),
    );
    yield r'password';
    yield serializers.serialize(
      object.password,
      specifiedType: const FullType(String),
    );
    yield r'username';
    yield serializers.serialize(
      object.username,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PostAuthSetupRequest object, {
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
    required PostAuthSetupRequestBuilder result,
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
        case r'code':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.code = valueDes;
          break;
        case r'password':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.password = valueDes;
          break;
        case r'username':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.username = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PostAuthSetupRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PostAuthSetupRequestBuilder();
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
