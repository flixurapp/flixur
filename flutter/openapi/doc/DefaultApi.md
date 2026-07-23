# openapi.api.DefaultApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to *http://localhost:8787/api*

Method | HTTP request | Description
------------- | ------------- | -------------
[**getGreetingByName**](DefaultApi.md#getgreetingbyname) | **GET** /greeting/{name} | Get greeting by name


# **getGreetingByName**
> GreetingOutputBody getGreetingByName(name)

Get greeting by name

### Example
```dart
import 'package:openapi/api.dart';

final api_instance = DefaultApi();
final name = name_example; // String | Name to greet

try {
    final result = api_instance.getGreetingByName(name);
    print(result);
} catch (e) {
    print('Exception when calling DefaultApi->getGreetingByName: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **name** | **String**| Name to greet | 

### Return type

[**GreetingOutputBody**](GreetingOutputBody.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

