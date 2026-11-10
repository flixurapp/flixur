# openapi.api.SettingsApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to *http://127.0.0.1:18787/api*

Method | HTTP request | Description
------------- | ------------- | -------------
[**createSettingsProfile**](SettingsApi.md#createsettingsprofile) | **POST** /settings/profiles | Create Settings Profile
[**deleteSettingsProfile**](SettingsApi.md#deletesettingsprofile) | **DELETE** /settings/profiles/{profile} | Delete Settings Profile
[**getClientSettingsDefinitions**](SettingsApi.md#getclientsettingsdefinitions) | **GET** /settings/definitions | Get Client Settings Definitions
[**getSettingsProfileValues**](SettingsApi.md#getsettingsprofilevalues) | **GET** /settings/profiles/{profile}/values | Get Settings Profile Values
[**getSettingsProfiles**](SettingsApi.md#getsettingsprofiles) | **GET** /settings/profiles | Get Settings Profiles
[**renameSettingsProfile**](SettingsApi.md#renamesettingsprofile) | **PUT** /settings/profiles/{profile} | Rename Settings Profile
[**updateSettingsProfileValue**](SettingsApi.md#updatesettingsprofilevalue) | **PUT** /settings/profiles/{profile}/values/{settingID} | Update Settings Profile Value


# **createSettingsProfile**
> SettingProfileBody createSettingsProfile(createSettingsProfileRequest)

Create Settings Profile

Creates a new settings profile.

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getSettingsApi();
final CreateSettingsProfileRequest createSettingsProfileRequest = ; // CreateSettingsProfileRequest | 

try {
    final response = api.createSettingsProfile(createSettingsProfileRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling SettingsApi->createSettingsProfile: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **createSettingsProfileRequest** | [**CreateSettingsProfileRequest**](CreateSettingsProfileRequest.md)|  | 

### Return type

[**SettingProfileBody**](SettingProfileBody.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deleteSettingsProfile**
> OutputSuccessBody deleteSettingsProfile(profile)

Delete Settings Profile

Deletes a setting profile and all of its overrides.

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getSettingsApi();
final String profile = profile_example; // String | 

try {
    final response = api.deleteSettingsProfile(profile);
    print(response);
} on DioException catch (e) {
    print('Exception when calling SettingsApi->deleteSettingsProfile: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **profile** | **String**|  | 

### Return type

[**OutputSuccessBody**](OutputSuccessBody.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getClientSettingsDefinitions**
> SettingsDefinitionsBody getClientSettingsDefinitions()

Get Client Settings Definitions

Gets all client setting definitions and groups.

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getSettingsApi();

try {
    final response = api.getClientSettingsDefinitions();
    print(response);
} on DioException catch (e) {
    print('Exception when calling SettingsApi->getClientSettingsDefinitions: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**SettingsDefinitionsBody**](SettingsDefinitionsBody.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getSettingsProfileValues**
> SettingValuesBody getSettingsProfileValues(profile)

Get Settings Profile Values

Gets all setting overrides in a profile.

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getSettingsApi();
final String profile = profile_example; // String | 

try {
    final response = api.getSettingsProfileValues(profile);
    print(response);
} on DioException catch (e) {
    print('Exception when calling SettingsApi->getSettingsProfileValues: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **profile** | **String**|  | 

### Return type

[**SettingValuesBody**](SettingValuesBody.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getSettingsProfiles**
> SettingsProfilesBody getSettingsProfiles()

Get Settings Profiles

Lists the setting profiles of the current user.

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getSettingsApi();

try {
    final response = api.getSettingsProfiles();
    print(response);
} on DioException catch (e) {
    print('Exception when calling SettingsApi->getSettingsProfiles: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**SettingsProfilesBody**](SettingsProfilesBody.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **renameSettingsProfile**
> OutputSuccessBody renameSettingsProfile(profile, renameSettingsProfileRequest)

Rename Settings Profile

Renames a settings profile.

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getSettingsApi();
final String profile = profile_example; // String | 
final RenameSettingsProfileRequest renameSettingsProfileRequest = ; // RenameSettingsProfileRequest | 

try {
    final response = api.renameSettingsProfile(profile, renameSettingsProfileRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling SettingsApi->renameSettingsProfile: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **profile** | **String**|  | 
 **renameSettingsProfileRequest** | [**RenameSettingsProfileRequest**](RenameSettingsProfileRequest.md)|  | 

### Return type

[**OutputSuccessBody**](OutputSuccessBody.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateSettingsProfileValue**
> SettingValueEntry updateSettingsProfileValue(profile, settingID, updateSettingsProfileValueRequest)

Update Settings Profile Value

Sets a setting override in a profile.

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getSettingsApi();
final String profile = profile_example; // String | 
final String settingID = settingID_example; // String | 
final UpdateSettingsProfileValueRequest updateSettingsProfileValueRequest = ; // UpdateSettingsProfileValueRequest | 

try {
    final response = api.updateSettingsProfileValue(profile, settingID, updateSettingsProfileValueRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling SettingsApi->updateSettingsProfileValue: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **profile** | **String**|  | 
 **settingID** | **String**|  | 
 **updateSettingsProfileValueRequest** | [**UpdateSettingsProfileValueRequest**](UpdateSettingsProfileValueRequest.md)|  | 

### Return type

[**SettingValueEntry**](SettingValueEntry.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

