//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:openapi/src/model/artist.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'artist_search_body.g.dart';

/// ArtistSearchBody
///
/// Properties:
/// * [dollarSchema] - A URL to the JSON Schema for this object.
/// * [list]
@BuiltValue()
abstract class ArtistSearchBody
    implements Built<ArtistSearchBody, ArtistSearchBodyBuilder> {
  /// A URL to the JSON Schema for this object.
  @BuiltValueField(wireName: r'$schema')
  String? get dollarSchema;

  @BuiltValueField(wireName: r'list')
  BuiltList<Artist> get list;

  ArtistSearchBody._();

  factory ArtistSearchBody([void updates(ArtistSearchBodyBuilder b)]) =
      _$ArtistSearchBody;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ArtistSearchBodyBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ArtistSearchBody> get serializer =>
      _$ArtistSearchBodySerializer();
}

class _$ArtistSearchBodySerializer
    implements PrimitiveSerializer<ArtistSearchBody> {
  @override
  final Iterable<Type> types = const [ArtistSearchBody, _$ArtistSearchBody];

  @override
  final String wireName = r'ArtistSearchBody';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ArtistSearchBody object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.dollarSchema != null) {
      yield r'$schema';
      yield serializers.serialize(
        object.dollarSchema,
        specifiedType: const FullType(String),
      );
    }
    yield r'list';
    yield serializers.serialize(
      object.list,
      specifiedType: const FullType(BuiltList, [FullType(Artist)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ArtistSearchBody object, {
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
    required ArtistSearchBodyBuilder result,
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
        case r'list':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(Artist)]),
          ) as BuiltList<Artist>;
          result.list.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ArtistSearchBody deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ArtistSearchBodyBuilder();
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
