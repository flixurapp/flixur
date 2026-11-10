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
import 'package:openapi/src/model/bool_props.dart';
import 'package:openapi/src/model/choice_spec.dart';
import 'package:openapi/src/model/create_settings_profile_request.dart';
import 'package:openapi/src/model/enum_props.dart';
import 'package:openapi/src/model/error_detail.dart';
import 'package:openapi/src/model/error_model.dart';
import 'package:openapi/src/model/float_props.dart';
import 'package:openapi/src/model/int_props.dart';
import 'package:openapi/src/model/oidc_init_body.dart';
import 'package:openapi/src/model/output_success_body.dart';
import 'package:openapi/src/model/ping_body.dart';
import 'package:openapi/src/model/post_auth_login_request.dart';
import 'package:openapi/src/model/post_auth_setup_request.dart';
import 'package:openapi/src/model/rename_settings_profile_request.dart';
import 'package:openapi/src/model/search_artists_request.dart';
import 'package:openapi/src/model/session_token_body.dart';
import 'package:openapi/src/model/setting_profile_body.dart';
import 'package:openapi/src/model/setting_value_entry.dart';
import 'package:openapi/src/model/setting_values_body.dart';
import 'package:openapi/src/model/settings_definition.dart';
import 'package:openapi/src/model/settings_definitions_body.dart';
import 'package:openapi/src/model/settings_group.dart';
import 'package:openapi/src/model/settings_profiles_body.dart';
import 'package:openapi/src/model/string_list_props.dart';
import 'package:openapi/src/model/string_props.dart';
import 'package:openapi/src/model/update_settings_profile_value_request.dart';

part 'serializers.g.dart';

@SerializersFor([
  APIError,
  Artist,
  ArtistSearchBody,
  BoolProps,
  ChoiceSpec,
  CreateSettingsProfileRequest,
  EnumProps,
  ErrorDetail,
  ErrorModel,
  FloatProps,
  IntProps,
  OIDCInitBody,
  OutputSuccessBody,
  PingBody,
  PostAuthLoginRequest,
  PostAuthSetupRequest,
  RenameSettingsProfileRequest,
  SearchArtistsRequest,
  SessionTokenBody,
  SettingProfileBody,
  SettingValueEntry,
  SettingValuesBody,
  SettingsDefinition,
  SettingsDefinitionsBody,
  SettingsGroup,
  SettingsProfilesBody,
  StringListProps,
  StringProps,
  UpdateSettingsProfileValueRequest,
])
Serializers serializers = (_$serializers.toBuilder()
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(SettingsGroup)]),
        () => ListBuilder<SettingsGroup>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(Artist)]),
        () => ListBuilder<Artist>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(ErrorDetail)]),
        () => ListBuilder<ErrorDetail>(),
      )
      ..addBuilderFactory(
        const FullType(
            BuiltMap, [FullType(String), FullType(SettingValueEntry)]),
        () => MapBuilder<String, SettingValueEntry>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(SettingsDefinition)]),
        () => ListBuilder<SettingsDefinition>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(ChoiceSpec)]),
        () => ListBuilder<ChoiceSpec>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(SettingProfileBody)]),
        () => ListBuilder<SettingProfileBody>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(String)]),
        () => ListBuilder<String>(),
      )
      ..add(const OneOfSerializer())
      ..add(const AnyOfSerializer())
      ..add(const DateSerializer())
      ..add(Iso8601DateTimeSerializer()))
    .build();

Serializers standardSerializers =
    (serializers.toBuilder()..addPlugin(StandardJsonPlugin())).build();
