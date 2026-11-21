package proto

import (
	"encoding/json"
	"testing"
)

func TestFeatureMarshalJSON(t *testing.T) {
	b, err := json.Marshal(Feature_MUSIC_METADATA)
	if err != nil {
		t.Fatalf("marshalling feature: %v", err)
	}
	if string(b) != `"MUSIC_METADATA"` {
		t.Errorf("marshalled feature = %s, want %q", b, "MUSIC_METADATA")
	}
}

func TestFeatureIDs(t *testing.T) {
	ids := featureIDs()

	// must cover every feature except UNSPECIFIED
	if len(ids) != len(Feature_value)-1 {
		t.Errorf("featureIDs() covers %d features, want %d", len(ids), len(Feature_value)-1)
	}

	// must use manifest-style IDs, ordered by enum number, without duplicates
	prev := int32(-1)
	seen := make(map[string]bool, len(ids))
	for _, id := range ids {
		num, ok := Feature_value["FEATURE_"+id]
		if !ok {
			t.Errorf("featureIDs() contains unknown feature ID %q", id)
			continue
		}
		if seen[id] {
			t.Errorf("featureIDs() contains duplicate feature ID %q", id)
		}
		seen[id] = true
		if num <= prev {
			t.Errorf("feature %q (num %d) is out of enum order after num %d", id, num, prev)
		}
		prev = num
	}
}

func TestFeatureSchema(t *testing.T) {
	s := Feature(0).Schema(nil)
	if s.Type != "string" {
		t.Errorf("schema type = %q, want %q", s.Type, "string")
	}

	// must cover every feature except UNSPECIFIED
	if len(s.Enum) != len(Feature_value)-1 {
		t.Errorf("schema enum covers %d features, want %d", len(s.Enum), len(Feature_value)-1)
	}

	for _, value := range s.Enum {
		id, ok := value.(string)
		if !ok {
			t.Errorf("schema enum value %v is not a string", value)
			continue
		}
		if _, ok := Feature_value["FEATURE_"+id]; !ok {
			t.Errorf("schema enum contains unknown feature ID %q", id)
		}
	}
}
