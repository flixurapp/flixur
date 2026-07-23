# openapi.api.ArtistsApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to *http://localhost:8787/api*

Method | HTTP request | Description
------------- | ------------- | -------------
[**artistSearch**](ArtistsApi.md#artistsearch) | **POST** /music/artists/search | Search for artists.


# **artistSearch**
> ArtistSearchOutputBody artistSearch(artistSearchRequest)

Search for artists.

Search for an artist by name.

### Example
```dart
import 'package:openapi/api.dart';

final api_instance = ArtistsApi();
final artistSearchRequest = ArtistSearchRequest(); // ArtistSearchRequest | 

try {
    final result = api_instance.artistSearch(artistSearchRequest);
    print(result);
} catch (e) {
    print('Exception when calling ArtistsApi->artistSearch: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **artistSearchRequest** | [**ArtistSearchRequest**](ArtistSearchRequest.md)|  | 

### Return type

[**ArtistSearchOutputBody**](ArtistSearchOutputBody.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

