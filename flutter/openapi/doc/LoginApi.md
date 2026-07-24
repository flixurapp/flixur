# openapi.api.LoginApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to *http://127.0.0.1:8787/api*

Method | HTTP request | Description
------------- | ------------- | -------------
[**oidcInit**](LoginApi.md#oidcinit) | **GET** /oidc_init | Initialize an OIDC login request.


# **oidcInit**
> OIDCInitOutputBody oidcInit()

Initialize an OIDC login request.

Initializes an OIDC login request returning the URL for authorization.

### Example
```dart
import 'package:openapi/api.dart';

final api_instance = LoginApi();

try {
    final result = api_instance.oidcInit();
    print(result);
} catch (e) {
    print('Exception when calling LoginApi->oidcInit: $e\n');
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

