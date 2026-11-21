// Additions to the feature enum to make it work with huma.
package proto

import (
	"cmp"
	"encoding/json"
	"slices"
	"strings"

	"github.com/danielgtaylor/huma/v2"
)

// converts a protobuf feature name into its short manifest name
func featureID(name string) string {
	return strings.TrimPrefix(name, "FEATURE_")
}

// for ordering the feature enum by its protobuf number.
type featurePair struct {
	num  int32
	name string
}

// returns all valid feature IDs in order, excluding UNSPECIFIED.
func featureIDs() []string {
	pairs := make([]featurePair, 0, len(Feature_value))
	for name, num := range Feature_value {
		if name == "FEATURE_UNSPECIFIED" {
			continue
		}
		pairs = append(pairs, featurePair{num: num, name: featureID(name)})
	}
	slices.SortFunc(pairs, func(a, b featurePair) int { return cmp.Compare(a.num, b.num) })
	ids := make([]string, len(pairs))
	for i, pair := range pairs {
		ids[i] = pair.name
	}
	return ids
}

// marshals a feature to JSON as its string ID instead of int
func (x Feature) MarshalJSON() ([]byte, error) {
	return json.Marshal(featureID(Feature_name[int32(x)]))
}

// tells huma that [Feature] is a proper enum
func (Feature) Schema(_ huma.Registry) *huma.Schema {
	ids := featureIDs()
	enum := make([]any, len(ids))
	for i, id := range ids {
		enum[i] = id
	}
	return &huma.Schema{
		Type: huma.TypeString,
		Enum: enum,
	}
}
