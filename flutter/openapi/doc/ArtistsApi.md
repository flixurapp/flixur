# openapi.api.ArtistsApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to *http://127.0.0.1:18787/api*

Method | HTTP request | Description
------------- | ------------- | -------------
[**searchArtists**](ArtistsApi.md#searchartists) | **POST** /artists/search | Search Artists


# **searchArtists**
> ArtistSearchBody searchArtists(searchArtistsRequest)

Search Artists

Search for an artist by name.

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getArtistsApi();
final SearchArtistsRequest searchArtistsRequest = ; // SearchArtistsRequest | 

try {
    final response = api.searchArtists(searchArtistsRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ArtistsApi->searchArtists: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **searchArtistsRequest** | [**SearchArtistsRequest**](SearchArtistsRequest.md)|  | 

### Return type

[**ArtistSearchBody**](ArtistSearchBody.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

