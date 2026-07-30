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

  /// OIDC Login
  ///
  /// Initializes an OIDC login request returning the URL for authorization.
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> getAuthOidcUrlWithHttpInfo() async {
    // ignore: prefer_const_declarations
    final path = r'/auth/oidc_url';

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

  /// OIDC Login
  ///
  /// Initializes an OIDC login request returning the URL for authorization.
  Future<OIDCInitBody?> getAuthOidcUrl() async {
    final response = await getAuthOidcUrlWithHttpInfo();
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
        'OIDCInitBody',
      ) as OIDCInitBody;
    }
    return null;
  }

  /// Ping Server
  ///
  /// Can be used to test the server connectivity and return version/feature info.
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> getPingWithHttpInfo() async {
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

  /// Ping Server
  ///
  /// Can be used to test the server connectivity and return version/feature info.
  Future<PingBody?> getPing() async {
    final response = await getPingWithHttpInfo();
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
        'PingBody',
      ) as PingBody;
    }
    return null;
  }

  /// Login
  ///
  /// Login with username/password.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] xPlatformClient (required):
  ///   Client Name/Version
  ///
  /// * [String] xPlatformDevice (required):
  ///   Device Name
  ///
  /// * [String] xPlatformOS (required):
  ///   Operating System/Version
  ///
  /// * [PostAuthLoginRequest] postAuthLoginRequest (required):
  Future<Response> postAuthLoginWithHttpInfo(
    String xPlatformClient,
    String xPlatformDevice,
    String xPlatformOS,
    PostAuthLoginRequest postAuthLoginRequest,
  ) async {
    // ignore: prefer_const_declarations
    final path = r'/auth/login';

    // ignore: prefer_final_locals
    Object? postBody = postAuthLoginRequest;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    headerParams[r'X-Platform-Client'] = parameterToString(xPlatformClient);
    headerParams[r'X-Platform-Device'] = parameterToString(xPlatformDevice);
    headerParams[r'X-Platform-OS'] = parameterToString(xPlatformOS);

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

  /// Login
  ///
  /// Login with username/password.
  ///
  /// Parameters:
  ///
  /// * [String] xPlatformClient (required):
  ///   Client Name/Version
  ///
  /// * [String] xPlatformDevice (required):
  ///   Device Name
  ///
  /// * [String] xPlatformOS (required):
  ///   Operating System/Version
  ///
  /// * [PostAuthLoginRequest] postAuthLoginRequest (required):
  Future<SessionTokenBody?> postAuthLogin(
    String xPlatformClient,
    String xPlatformDevice,
    String xPlatformOS,
    PostAuthLoginRequest postAuthLoginRequest,
  ) async {
    final response = await postAuthLoginWithHttpInfo(
      xPlatformClient,
      xPlatformDevice,
      xPlatformOS,
      postAuthLoginRequest,
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
        'SessionTokenBody',
      ) as SessionTokenBody;
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
  /// * [String] xPlatformClient (required):
  ///   Client Name/Version
  ///
  /// * [String] xPlatformDevice (required):
  ///   Device Name
  ///
  /// * [String] xPlatformOS (required):
  ///   Operating System/Version
  ///
  /// * [PostAuthSetupRequest] postAuthSetupRequest (required):
  Future<Response> postAuthSetupWithHttpInfo(
    String xPlatformClient,
    String xPlatformDevice,
    String xPlatformOS,
    PostAuthSetupRequest postAuthSetupRequest,
  ) async {
    // ignore: prefer_const_declarations
    final path = r'/auth/setup';

    // ignore: prefer_final_locals
    Object? postBody = postAuthSetupRequest;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    headerParams[r'X-Platform-Client'] = parameterToString(xPlatformClient);
    headerParams[r'X-Platform-Device'] = parameterToString(xPlatformDevice);
    headerParams[r'X-Platform-OS'] = parameterToString(xPlatformOS);

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
  /// * [String] xPlatformClient (required):
  ///   Client Name/Version
  ///
  /// * [String] xPlatformDevice (required):
  ///   Device Name
  ///
  /// * [String] xPlatformOS (required):
  ///   Operating System/Version
  ///
  /// * [PostAuthSetupRequest] postAuthSetupRequest (required):
  Future<SessionTokenBody?> postAuthSetup(
    String xPlatformClient,
    String xPlatformDevice,
    String xPlatformOS,
    PostAuthSetupRequest postAuthSetupRequest,
  ) async {
    final response = await postAuthSetupWithHttpInfo(
      xPlatformClient,
      xPlatformDevice,
      xPlatformOS,
      postAuthSetupRequest,
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
        'SessionTokenBody',
      ) as SessionTokenBody;
    }
    return null;
  }
}
