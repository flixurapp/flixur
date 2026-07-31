# openapi.api.AuthenticationApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to *http://127.0.0.1:18787/api*

Method | HTTP request | Description
------------- | ------------- | -------------
[**getAuthOidcUrl**](AuthenticationApi.md#getauthoidcurl) | **GET** /auth/oidc_url | OIDC Login
[**getPing**](AuthenticationApi.md#getping) | **GET** /ping | Ping Server
[**postAuthLogin**](AuthenticationApi.md#postauthlogin) | **POST** /auth/login | Login
[**postAuthSetup**](AuthenticationApi.md#postauthsetup) | **POST** /auth/setup | Setup Server


# **getAuthOidcUrl**
> OIDCInitBody getAuthOidcUrl()

OIDC Login

Initializes an OIDC login request returning the URL for authorization.

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getAuthenticationApi();

try {
    final response = api.getAuthOidcUrl();
    print(response);
} on DioException catch (e) {
    print('Exception when calling AuthenticationApi->getAuthOidcUrl: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**OIDCInitBody**](OIDCInitBody.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getPing**
> PingBody getPing()

Ping Server

Can be used to test the server connectivity and return version/feature info.

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getAuthenticationApi();

try {
    final response = api.getPing();
    print(response);
} on DioException catch (e) {
    print('Exception when calling AuthenticationApi->getPing: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**PingBody**](PingBody.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **postAuthLogin**
> SessionTokenBody postAuthLogin(xPlatformClient, xPlatformDevice, xPlatformOS, postAuthLoginRequest)

Login

Login with username/password.

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getAuthenticationApi();
final String xPlatformClient = xPlatformClient_example; // String | Client Name/Version
final String xPlatformDevice = xPlatformDevice_example; // String | Device Name
final String xPlatformOS = xPlatformOS_example; // String | Operating System/Version
final PostAuthLoginRequest postAuthLoginRequest = ; // PostAuthLoginRequest | 

try {
    final response = api.postAuthLogin(xPlatformClient, xPlatformDevice, xPlatformOS, postAuthLoginRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AuthenticationApi->postAuthLogin: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **xPlatformClient** | **String**| Client Name/Version | 
 **xPlatformDevice** | **String**| Device Name | 
 **xPlatformOS** | **String**| Operating System/Version | 
 **postAuthLoginRequest** | [**PostAuthLoginRequest**](PostAuthLoginRequest.md)|  | 

### Return type

[**SessionTokenBody**](SessionTokenBody.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **postAuthSetup**
> SessionTokenBody postAuthSetup(xPlatformClient, xPlatformDevice, xPlatformOS, postAuthSetupRequest)

Setup Server

Creates the initial admin account and sets up the server.

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getAuthenticationApi();
final String xPlatformClient = xPlatformClient_example; // String | Client Name/Version
final String xPlatformDevice = xPlatformDevice_example; // String | Device Name
final String xPlatformOS = xPlatformOS_example; // String | Operating System/Version
final PostAuthSetupRequest postAuthSetupRequest = ; // PostAuthSetupRequest | 

try {
    final response = api.postAuthSetup(xPlatformClient, xPlatformDevice, xPlatformOS, postAuthSetupRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AuthenticationApi->postAuthSetup: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **xPlatformClient** | **String**| Client Name/Version | 
 **xPlatformDevice** | **String**| Device Name | 
 **xPlatformOS** | **String**| Operating System/Version | 
 **postAuthSetupRequest** | [**PostAuthSetupRequest**](PostAuthSetupRequest.md)|  | 

### Return type

[**SessionTokenBody**](SessionTokenBody.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

