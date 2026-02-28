
# ArtistSearchRequest


## Properties

Name | Type
------------ | -------------
`$schema` | string
`limit` | number
`plugin` | string
`query` | string

## Example

```typescript
import type { ArtistSearchRequest } from ''

// TODO: Update the object below with actual values
const example = {
  "$schema": null,
  "limit": null,
  "plugin": null,
  "query": null,
} satisfies ArtistSearchRequest

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as ArtistSearchRequest
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


