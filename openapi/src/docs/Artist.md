
# Artist


## Properties

Name | Type
------------ | -------------
`description` | string
`followers` | number
`icon` | string
`id` | string
`location` | string
`name` | string
`provider` | string

## Example

```typescript
import type { Artist } from ''

// TODO: Update the object below with actual values
const example = {
  "description": null,
  "followers": null,
  "icon": null,
  "id": null,
  "location": null,
  "name": null,
  "provider": null,
} satisfies Artist

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as Artist
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


