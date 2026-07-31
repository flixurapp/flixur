//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_import

import 'package:one_of_serializer/any_of_serializer.dart';
import 'package:one_of_serializer/one_of_serializer.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';
import 'package:built_value/iso_8601_date_time_serializer.dart';
import 'package:openapi/src/date_serializer.dart';
import 'package:openapi/src/model/date.dart';

import 'package:openapi/src/model/api_error.dart';
import 'package:openapi/src/model/artist.dart';
import 'package:openapi/src/model/artist_search_body.dart';
import 'package:openapi/src/model/error_detail.dart';
import 'package:openapi/src/model/error_model.dart';
import 'package:openapi/src/model/oidc_init_body.dart';
import 'package:openapi/src/model/ping_body.dart';
import 'package:openapi/src/model/post_auth_login_request.dart';
import 'package:openapi/src/model/post_auth_setup_request.dart';
import 'package:openapi/src/model/search_artists_request.dart';
import 'package:openapi/src/model/session_token_body.dart';

part 'serializers.g.dart';

@SerializersFor([
  APIError,
  Artist,
  ArtistSearchBody,
  ErrorDetail,
  ErrorModel,
  OIDCInitBody,
  PingBody,
  PostAuthLoginRequest,
  PostAuthSetupRequest,
  SearchArtistsRequest,
  SessionTokenBody,
])
Serializers serializers = (_$serializers.toBuilder()
      ..add(const OneOfSerializer())
      ..add(const AnyOfSerializer())
      ..add(const DateSerializer())
      ..add(Iso8601DateTimeSerializer()))
    .build();

Serializers standardSerializers =
    (serializers.toBuilder()..addPlugin(StandardJsonPlugin())).build();
