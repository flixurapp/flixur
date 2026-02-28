# DefaultApi

All URIs are relative to *http://localhost:8787/api*

| Method | HTTP request | Description |
|------------- | ------------- | -------------|
| [**getGreetingByName**](DefaultApi.md#getgreetingbyname) | **GET** /greeting/{name} | Get greeting by name |



## getGreetingByName

> GreetingOutputBody getGreetingByName(name)

Get greeting by name

### Example

```ts
import {
  Configuration,
  DefaultApi,
} from '';
import type { GetGreetingByNameRequest } from '';

async function example() {
  console.log("🚀 Testing  SDK...");
  const api = new DefaultApi();

  const body = {
    // string | Name to greet
    name: name_example,
  } satisfies GetGreetingByNameRequest;

  try {
    const data = await api.getGreetingByName(body);
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
| **name** | `string` | Name to greet | [Defaults to `undefined`] |

### Return type

[**GreetingOutputBody**](GreetingOutputBody.md)

### Authorization

No authorization required

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/json`, `application/problem+json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | OK |  -  |
| **0** | Error |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)

