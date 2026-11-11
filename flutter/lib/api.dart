import "package:dio/dio.dart";
import "package:flixur/router.dart";
import "package:flixur/storage.dart";
import "package:openapi/openapi.dart";

class Api {
  static Openapi client = .new();

  static void setBaseUrl(String? url) {
    client = Openapi(basePathOverride: url);
    // re-set the session token when refreshing the client
    setSessionToken(Storage.sessionToken.value);
  }

  static void setSessionToken(String? token) {
    if (token == null) {
      client.removeBearerAuth("bearerAuth");
    } else {
      client.setBearerAuth("bearerAuth", token);
    }
  }

  static void init() {
    //! API client is initialized BEFORE storage so that storage listeners
    //! will fire on init
    Storage.serverUrl.addListener(() => setBaseUrl(Storage.serverUrl.value));
    Storage.sessionToken.addListener(
      () => setSessionToken(Storage.sessionToken.value),
    );
  }

  /// Safely make a request and return the error if it occurs.
  static Future<ApiResult<T>> request<T>(
    Future<Response<T>> Function(Openapi a) request,
  ) async {
    try {
      final response = await request(client);
      final data = response.data;
      if (data == null) {
        throw DioException(
          requestOptions: response.requestOptions,
          message: "No request body was returned.",
        );
      }
      return ApiSuccess(data, response);
    } on DioException catch (err) {
      final dynamic data = err.response?.data;
      // attempt to deserialize API error
      // this can fail if server doesnt return a proper response
      if (data != null) {
        try {
          final apiError = standardSerializers.deserializeWith(
            APIError.serializer,
            data,
          );
          if (apiError != null) return ApiFailure(err, apiError);
        } on Object catch (_) {}
      }
      // otherwise return a generic error
      return ApiFailure(err, null);
    }
  }

  static Future<void> logout() async {
    // clear data from storage
    await Storage.setSessionToken(null);
    await Storage.setServerUrl(null);
    await Storage.setPlayerID(null);

    // navigate back to root
    router.go("/");
  }
}

sealed class ApiResult<T>();

class ApiSuccess<T>(final T data, final Response<T> response)
    extends ApiResult<T>;

class ApiFailure<T>(final DioException rawException, final APIError? err)
    extends ApiResult<T> {
  String get message => err == null
      ? rawException.message ?? rawException.type.name
      : "${err?.code} ${err?.detail ?? ""}".trim();
}

extension APIErrorKey on APIError {
  /// Return a formatted translation key for the error.
  String get key => "$code${detail != null ? ".$detail" : ""}";
}
