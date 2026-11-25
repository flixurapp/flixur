// Additions to the settings types to make them work with huma and JSON.
package proto

import (
	"cmp"
	"encoding/json"
	"fmt"
	"slices"
	"strings"

	"github.com/danielgtaylor/huma/v2"
)

type kindPair struct {
	num  int32
	name string
}

// returns all valid kind IDs in order, excluding UNSPECIFIED.
func kindIDs() []string {
	pairs := make([]kindPair, 0, len(Kind_value))
	for name, num := range Kind_value {
		if name == "KIND_UNSPECIFIED" {
			continue
		}
		pairs = append(pairs, kindPair{num: num, name: kindID(Kind(num))})
	}
	slices.SortFunc(pairs, func(a, b kindPair) int { return cmp.Compare(a.num, b.num) })
	ids := make([]string, len(pairs))
	for i, pair := range pairs {
		ids[i] = pair.name
	}
	return ids
}

// Returns the JSON name of a kind.
func kindID(kind Kind) string {
	if kind == Kind_UNSPECIFIED {
		return ""
	}
	return strings.ToLower(strings.TrimPrefix(Kind_name[int32(kind)], "KIND_"))
}

// Marshals a kind to JSON as its string name instead of int.
func (x Kind) MarshalJSON() ([]byte, error) {
	return json.Marshal(kindID(x))
}

// Unmarshals a kind from its string name.
func (x *Kind) UnmarshalJSON(data []byte) error {
	var name string
	if err := json.Unmarshal(data, &name); err != nil {
		return err
	}
	if name == "" {
		*x = Kind_UNSPECIFIED
		return nil
	}
	kind, ok := Kind_value["KIND_"+strings.ToUpper(name)]
	if !ok {
		return fmt.Errorf("unknown setting kind: %s", name)
	}
	*x = Kind(kind)
	return nil
}

// Tells huma that [Kind] is a proper enum.
func (Kind) Schema(_ huma.Registry) *huma.Schema {
	ids := kindIDs()
	enum := make([]any, len(ids))
	for i, id := range ids {
		enum[i] = id
	}
	return &huma.Schema{
		Type: huma.TypeString,
		Enum: enum,
	}
}

// Whether the definition's value should be treated as a secret.
func (d *SettingsDefinition) IsSecret() bool {
	return d != nil && d.String_ != nil && d.String_.Secret != nil && *d.String_.Secret
}
