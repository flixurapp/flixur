# openapi.api.SetupApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to *http://127.0.0.1:18787/api*

Method | HTTP request | Description
------------- | ------------- | -------------
[**setup**](SetupApi.md#setup) | **POST** /auth/setup | Setup Server


# **setup**
> OutputSuccessBody setup(setupRequest)

Setup Server

Creates the initial admin account and sets up the server.

### Example
```dart
import 'package:openapi/api.dart';

final api_instance = SetupApi();
final setupRequest = SetupRequest(); // SetupRequest | 

try {
    final result = api_instance.setup(setupRequest);
    print(result);
} catch (e) {
    print('Exception when calling SetupApi->setup: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **setupRequest** | [**SetupRequest**](SetupRequest.md)|  | 

### Return type

[**OutputSuccessBody**](OutputSuccessBody.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

