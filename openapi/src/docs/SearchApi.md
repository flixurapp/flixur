# SearchApi

All URIs are relative to *http://localhost:8787/api*

| Method | HTTP request | Description |
|------------- | ------------- | -------------|
| [**artistSearch**](SearchApi.md#artistsearchoperation) | **POST** /music/artists/search | Search for artists. |



## artistSearch

> ArtistSearchOutputBody artistSearch(artistSearchRequest)

Search for artists.

Search for an artist by name.

### Example

```ts
import {
  Configuration,
  SearchApi,
} from '';
import type { ArtistSearchOperationRequest } from '';

async function example() {
  console.log("🚀 Testing  SDK...");
  const api = new SearchApi();

  const body = {
    // ArtistSearchRequest
    artistSearchRequest: ...,
  } satisfies ArtistSearchOperationRequest;

  try {
    const data = await api.artistSearch(body);
    console.log(data);
  } catch (error) {
    console.error(error);
  }
}

// Run the test
example().catch(console.error);
```

### Parameters


| Name | Type | Description  | Notes |
|------------- | ------------- | ------------- | -------------|
| **artistSearchRequest** | [ArtistSearchRequest](ArtistSearchRequest.md) |  | |

### Return type

[**ArtistSearchOutputBody**](ArtistSearchOutputBody.md)

### Authorization

No authorization required

### HTTP request headers

- **Content-Type**: `application/json`
- **Accept**: `application/json`, `application/problem+json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | OK |  -  |
| **0** | Error |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)

