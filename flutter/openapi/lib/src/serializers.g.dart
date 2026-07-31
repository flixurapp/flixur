// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'serializers.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializers _$serializers = (Serializers().toBuilder()
      ..add(APIError.serializer)
      ..add(APIErrorCodeEnum.serializer)
      ..add(Artist.serializer)
      ..add(ArtistSearchBody.serializer)
      ..add(ErrorDetail.serializer)
      ..add(ErrorModel.serializer)
      ..add(OIDCInitBody.serializer)
      ..add(PingBody.serializer)
      ..add(PostAuthLoginRequest.serializer)
      ..add(PostAuthSetupRequest.serializer)
      ..add(SearchArtistsRequest.serializer)
      ..add(SessionTokenBody.serializer)
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(Artist)]),
          () => ListBuilder<Artist>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(ErrorDetail)]),
          () => ListBuilder<ErrorDetail>()))
    .build();

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
