# openapi.api.LoginApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to *http://127.0.0.1:18787/api*

Method | HTTP request | Description
------------- | ------------- | -------------
[**oidc**](LoginApi.md#oidc) | **GET** /auth/oidc | Initialize an OIDC login request.


# **oidc**
> OIDCInitOutputBody oidc()

Initialize an OIDC login request.

Initializes an OIDC login request returning the URL for authorization.

### Example
```dart
import 'package:openapi/api.dart';

final api_instance = LoginApi();

try {
    final result = api_instance.oidc();
    print(result);
} catch (e) {
    print('Exception when calling LoginApi->oidc: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**OIDCInitOutputBody**](OIDCInitOutputBody.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

