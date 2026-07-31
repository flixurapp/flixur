//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'search_artists_request.g.dart';

/// SearchArtistsRequest
///
/// Properties:
/// * [dollarSchema] - A URL to the JSON Schema for this object.
/// * [limit]
/// * [plugin] - Plugin ID to use for the request. Omit to use the local server.
/// * [query]
@BuiltValue()
abstract class SearchArtistsRequest
    implements Built<SearchArtistsRequest, SearchArtistsRequestBuilder> {
  /// A URL to the JSON Schema for this object.
  @BuiltValueField(wireName: r'$schema')
  String? get dollarSchema;

  @BuiltValueField(wireName: r'limit')
  int? get limit;

  /// Plugin ID to use for the request. Omit to use the local server.
  @BuiltValueField(wireName: r'plugin')
  String? get plugin;

  @BuiltValueField(wireName: r'query')
  String get query;

  SearchArtistsRequest._();

  factory SearchArtistsRequest([void updates(SearchArtistsRequestBuilder b)]) =
      _$SearchArtistsRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SearchArtistsRequestBuilder b) => b..limit = 10;

  @BuiltValueSerializer(custom: true)
  static Serializer<SearchArtistsRequest> get serializer =>
      _$SearchArtistsRequestSerializer();
}

class _$SearchArtistsRequestSerializer
    implements PrimitiveSerializer<SearchArtistsRequest> {
  @override
  final Iterable<Type> types = const [
    SearchArtistsRequest,
    _$SearchArtistsRequest
  ];

  @override
  final String wireName = r'SearchArtistsRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SearchArtistsRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.dollarSchema != null) {
      yield r'$schema';
      yield serializers.serialize(
        object.dollarSchema,
        specifiedType: const FullType(String),
      );
    }
    if (object.limit != null) {
      yield r'limit';
      yield serializers.serialize(
        object.limit,
        specifiedType: const FullType(int),
      );
    }
    if (object.plugin != null) {
      yield r'plugin';
      yield serializers.serialize(
        object.plugin,
        specifiedType: const FullType(String),
      );
    }
    yield r'query';
    yield serializers.serialize(
      object.query,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    SearchArtistsRequest object, {
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
    required SearchArtistsRequestBuilder result,
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
        case r'limit':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.limit = valueDes;
          break;
        case r'plugin':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.plugin = valueDes;
          break;
        case r'query':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.query = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SearchArtistsRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SearchArtistsRequestBuilder();
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
