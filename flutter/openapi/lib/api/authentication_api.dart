//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class AuthenticationApi {
  AuthenticationApi([ApiClient? apiClient])
      : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Initialize an OIDC login request.
  ///
  /// Initializes an OIDC login request returning the URL for authorization.
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> oidcWithHttpInfo() async {
    // ignore: prefer_const_declarations
    final path = r'/auth/oidc';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];

    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Initialize an OIDC login request.
  ///
  /// Initializes an OIDC login request returning the URL for authorization.
  Future<OIDCInitOutputBody?> oidc() async {
    final response = await oidcWithHttpInfo();
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty &&
        response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(
        await _decodeBodyBytes(response),
        'OIDCInitOutputBody',
      ) as OIDCInitOutputBody;
    }
    return null;
  }

  /// Test server connectivity.
  ///
  /// Can be used to test the server connectivity and version.
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> pingWithHttpInfo() async {
    // ignore: prefer_const_declarations
    final path = r'/ping';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];

    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Test server connectivity.
  ///
  /// Can be used to test the server connectivity and version.
  Future<PingOutputBody?> ping() async {
    final response = await pingWithHttpInfo();
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty &&
        response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(
        await _decodeBodyBytes(response),
        'PingOutputBody',
      ) as PingOutputBody;
    }
    return null;
  }

  /// Setup Server
  ///
  /// Creates the initial admin account and sets up the server.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [SetupRequest] setupRequest (required):
  Future<Response> setupWithHttpInfo(
    SetupRequest setupRequest,
  ) async {
    // ignore: prefer_const_declarations
    final path = r'/auth/setup';

    // ignore: prefer_final_locals
    Object? postBody = setupRequest;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>['application/json'];

    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Setup Server
  ///
  /// Creates the initial admin account and sets up the server.
  ///
  /// Parameters:
  ///
  /// * [SetupRequest] setupRequest (required):
  Future<OutputSuccessBody?> setup(
    SetupRequest setupRequest,
  ) async {
    final response = await setupWithHttpInfo(
      setupRequest,
    );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty &&
        response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(
        await _decodeBodyBytes(response),
        'OutputSuccessBody',
      ) as OutputSuccessBody;
    }
    return null;
  }
}
