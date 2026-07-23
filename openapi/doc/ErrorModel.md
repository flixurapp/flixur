# openapi.model.ErrorModel

## Load the model package
```dart
import 'package:openapi/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**dollarSchema** | **String** | A URL to the JSON Schema for this object. | [optional] [readonly] 
**detail** | **String** | A human-readable explanation specific to this occurrence of the problem. | [optional] 
**errors** | [**List<ErrorDetail>**](ErrorDetail.md) | Optional list of individual error details | [optional] [default to const []]
**instance** | **String** | A URI reference that identifies the specific occurrence of the problem. | [optional] 
**status** | **int** | HTTP status code | [optional] 
**title** | **String** | A short, human-readable summary of the problem type. This value should not change between occurrences of the error. | [optional] 
**type** | **String** | A URI reference to human-readable documentation for the error. | [optional] [default to 'about:blank']

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


