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
> SessionTokenOutputBody setup(xPlatformClient, xPlatformDevice, xPlatformOS, setupRequest)

Setup Server

Creates the initial admin account and sets up the server.

### Example
```dart
import 'package:openapi/api.dart';

final api_instance = SetupApi();
final xPlatformClient = xPlatformClient_example; // String | Client Name/Version
final xPlatformDevice = xPlatformDevice_example; // String | Device Name
final xPlatformOS = xPlatformOS_example; // String | Operating System/Version
final setupRequest = SetupRequest(); // SetupRequest | 

try {
    final result = api_instance.setup(xPlatformClient, xPlatformDevice, xPlatformOS, setupRequest);
    print(result);
} catch (e) {
    print('Exception when calling SetupApi->setup: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **xPlatformClient** | **String**| Client Name/Version | 
 **xPlatformDevice** | **String**| Device Name | 
 **xPlatformOS** | **String**| Operating System/Version | 
 **setupRequest** | [**SetupRequest**](SetupRequest.md)|  | 

### Return type

[**SessionTokenOutputBody**](SessionTokenOutputBody.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

