import "package:openapi/api.dart";

// re-export several extensions on the context so we arent duplicating
export "package:flixur/ui/responsiveness.dart";
export "package:flixur/ui/theme.dart";
export "package:go_router/go_router.dart";

sealed class ApiResult<T> {
  const ApiResult();
}

class ApiSuccess<T> extends ApiResult<T> {
  const ApiSuccess(this.data);
  final T data;
}

class ApiFailure<T> extends ApiResult<T> {
  const ApiFailure(this.err);
  final ApiException err;
}

// safely make a request and return the error if it occurs
Future<ApiResult<T>> safeGet<T>(Future<T?> Function() request) async {
  try {
    final result = await request();
    if (result == null) throw ApiException(0, "No request body was returned.");
    return ApiSuccess(result);
  } on ApiException catch (err) {
    return ApiFailure(err);
  }
}
