# openapi.api.AuthenticationApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to *http://127.0.0.1:8787/api*

Method | HTTP request | Description
------------- | ------------- | -------------
[**ping**](AuthenticationApi.md#ping) | **GET** /ping | Test server connectivity.


# **ping**
> PingOutputBody ping()

Test server connectivity.

Can be used to test the server connectivity and version.

### Example
```dart
import 'package:openapi/api.dart';

final api_instance = AuthenticationApi();

try {
    final result = api_instance.ping();
    print(result);
} catch (e) {
    print('Exception when calling AuthenticationApi->ping: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**PingOutputBody**](PingOutputBody.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

