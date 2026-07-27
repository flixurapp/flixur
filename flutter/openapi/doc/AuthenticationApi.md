# openapi.api.AuthenticationApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to *http://127.0.0.1:18787/api*

Method | HTTP request | Description
------------- | ------------- | -------------
[**oidc**](AuthenticationApi.md#oidc) | **GET** /auth/oidc | Initialize an OIDC login request.
[**ping**](AuthenticationApi.md#ping) | **GET** /ping | Ping Server
[**setup**](AuthenticationApi.md#setup) | **POST** /auth/setup | Setup Server


# **oidc**
> OIDCInitOutputBody oidc()

Initialize an OIDC login request.

Initializes an OIDC login request returning the URL for authorization.

### Example
```dart
import 'package:openapi/api.dart';

final api_instance = AuthenticationApi();

try {
    final result = api_instance.oidc();
    print(result);
} catch (e) {
    print('Exception when calling AuthenticationApi->oidc: $e\n');
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

# **ping**
> PingOutputBody ping()

Ping Server

Can be used to test the server connectivity and return version/feature info.

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

# **setup**
> SessionTokenOutputBody setup(xPlatformClient, xPlatformDevice, xPlatformOS, setupRequest)

Setup Server

Creates the initial admin account and sets up the server.

### Example
```dart
import 'package:openapi/api.dart';

final api_instance = AuthenticationApi();
final xPlatformClient = xPlatformClient_example; // String | Client Name/Version
final xPlatformDevice = xPlatformDevice_example; // String | Device Name
final xPlatformOS = xPlatformOS_example; // String | Operating System/Version
final setupRequest = SetupRequest(); // SetupRequest | 

try {
    final result = api_instance.setup(xPlatformClient, xPlatformDevice, xPlatformOS, setupRequest);
    print(result);
} catch (e) {
    print('Exception when calling AuthenticationApi->setup: $e\n');
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

