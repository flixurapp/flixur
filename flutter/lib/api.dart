import "dart:async";
import "dart:io";

import "package:dio/dio.dart";
import "package:flixur/router.dart";
import "package:flixur/settings.dart";
import "package:flixur/storage.dart";
import "package:openapi/openapi.dart";

class Api {
  static Openapi client = .new();

  static bool get canMakeAuthenticatedRequests =>
      Storage.has(.serverUrl) && Storage.has(.sessionToken);

  /// Updates the base URL of the stored client.
  static void setBaseUrl(String? url) {
    client = Openapi(basePathOverride: url);
    // re-set the session token when refreshing the client
    setSessionToken(Storage.get(.sessionToken));
  }

  /// Updates the session token associated with the stored client.
  static void setSessionToken(String? token) {
    if (token == null) {
      client.removeBearerAuth("bearerAuth");
    } else {
      client.setBearerAuth("bearerAuth", token);
    }
  }

  static void init() {
    setBaseUrl(Storage.get(.serverUrl));
    setSessionToken(Storage.get(.sessionToken));

    // keep the client in sync with storage changes
    Storage.watch(.serverUrl).listen((event) {
      setBaseUrl(event.deleted ? null : event.value as String?);
    });
    Storage.watch(.sessionToken).listen((event) {
      setSessionToken(event.deleted ? null : event.value as String?);
    });
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
      // attempt to deserialize API error / error model
      // this can fail if server doesnt return a proper response
      if (data != null) {
        try {
          final apiError = standardSerializers.deserializeWith(
            APIError.serializer,
            data,
          );
          if (apiError != null) {
            // log out if we get an invalid session error
            if (err.response?.statusCode == HttpStatus.unauthorized) {
              final code = apiError.code;
              if (code == .SERVER_NOT_SETUP) await logout(full: true);
              if (code == .INVALID_TOKEN) await logout();
            }
            return ApiFailure(err, err: apiError);
          }
        } on Object catch (_) {}
        try {
          final errorModel = standardSerializers.deserializeWith(
            ErrorModel.serializer,
            data,
          );
          if (errorModel != null) {
            return ApiFailure(err, errorModel: errorModel);
          }
        } on Object catch (_) {}
      }
      // otherwise return a generic error
      return ApiFailure(err);
    }
  }

  static Future<void> logout({
    /// Whether to remove the server URL too.
    bool full = false,
  }) async {
    // clear data from storage
    await Storage.delete(.sessionToken);
    await Storage.delete(.playerID);
    if (full) {
      await Storage.delete(.serverUrl);
    }

    await Settings.reset();

    // navigate back to root
    router.go("/");
  }
}

sealed class ApiResult<T>();

class ApiSuccess<T>(final T data, final Response<T> response)
    extends ApiResult<T>;

class ApiFailure<T>(
  final DioException rawException, {
  final APIError? err,
  final ErrorModel? errorModel,
}) extends ApiResult<T> {
  String get message {
    if (err != null) {
      return "${err?.code} ${err?.detail ?? ""}".trim();
    }
    if (errorModel != null) {
      return '''
${errorModel?.status ?? ""} ${errorModel?.title ?? ""}
${errorModel?.detail ?? ""}'''
          .trim();
    }
    return rawException.message ?? rawException.type.name;
  }

  /// Return the translation for [err] or [message].
  String translated(Map<String, String> map) => err?.translated(map) ?? message;
}

extension APIErrorKey on APIError {
  /// Return a formatted translation key for the error.
  String get key => "$code${detail != null ? ".$detail" : ""}";

  /// Return the translation for this error from the given translation [map].
  String? translated(Map<String, String> map) => map[key];
}
