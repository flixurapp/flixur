import "package:dio/dio.dart";
import "package:flixur/storage.dart";
import "package:openapi/openapi.dart";

class Api {
  static Openapi client = .new();
  static void setBaseUrl(String? url) {
    client = Openapi(basePathOverride: url);
  }

  static void init() {
    Storage.serverUrl.addListener(() => setBaseUrl(Storage.serverUrl.value));
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
      // attempt to deseriaize API error
      if (data != null) {
        final apiError = standardSerializers.deserializeWith(
          APIError.serializer,
          data,
        );
        if (apiError != null) return ApiFailure(err, apiError);
      }
      // otherwise return a generic error
      return ApiFailure(err, null);
    }
  }
}

sealed class ApiResult<T> {
  const ApiResult();
}

class ApiSuccess<T> extends ApiResult<T> {
  const ApiSuccess(this.data, this.response);
  final T data;
  final Response<T> response;
}

class ApiFailure<T> extends ApiResult<T> {
  const ApiFailure(this.rawException, this.err);
  final APIError? err;
  final DioException rawException;

  String get message => err == null
      ? rawException.message ?? rawException.type.name
      : "${err?.code} ${err?.detail ?? ""}".trim();
}

extension APIErrorKey on APIError {
  /// Return a formatted translation key for the error.
  String get key => "$code${detail != null ? ".$detail" : ""}";
}
