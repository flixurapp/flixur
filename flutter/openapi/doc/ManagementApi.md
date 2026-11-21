# openapi.api.ManagementApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to *http://127.0.0.1:18787/api*

Method | HTTP request | Description
------------- | ------------- | -------------
[**listPlugins**](ManagementApi.md#listplugins) | **GET** /manage/plugins | List Plugins


# **listPlugins**
> PluginsBody listPlugins()

List Plugins

Lists all installed plugins.

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getManagementApi();

try {
    final response = api.listPlugins();
    print(response);
} on DioException catch (e) {
    print('Exception when calling ManagementApi->listPlugins: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**PluginsBody**](PluginsBody.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

