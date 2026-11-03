package pluginkit

import (
	"encoding/json"
	"os"
	"sort"
	"strings"
	"testing"

	pb "forge.xela.codes/xela/flixur/pluginkit/proto"
	jsonschema "github.com/santhosh-tekuri/jsonschema/v5"
)

// Path to the example plugin's manifest, relative to this package.
const exampleManifestPath = "../plugin-example/manifest.json"

func TestParsePluginManifest(t *testing.T) {
	raw, err := os.ReadFile(exampleManifestPath)
	if err != nil {
		t.Fatalf("reading %s: %v", exampleManifestPath, err)
	}

	m, err := ParsePluginManifest(raw)
	if err != nil {
		t.Fatalf("parsing manifest: %v", err)
	}

	if m.Id != "example" {
		t.Errorf("Id = %q, want %q", m.Id, "example")
	}
	if m.Name != "Example Plugin" {
		t.Errorf("Name = %q, want %q", m.Name, "Example Plugin")
	}
	if m.Version != "2023.10.19" {
		t.Errorf("Version = %q, want %q", m.Version, "2023.10.19")
	}
	if m.Icon != "mdi:music" {
		t.Errorf("Icon = %q, want %q", m.Icon, "mdi:music")
	}
	if m.Description != "Small example plugin." {
		t.Errorf("Description = %q, want %q", m.Description, "Small example plugin.")
	}
	if m.Author != "You" {
		t.Errorf("Author = %q, want %q", m.Author, "You")
	}
	if m.Url != "https://forge.xela.codes/xela/flixur/src/branch/master/plugin-example" {
		t.Errorf("Url = %q, want example plugin URL", m.Url)
	}
	if m.Dependencies != nil {
		t.Errorf("Dependencies = %v, want nil", m.Dependencies)
	}

	wantFeatures := []pb.Feature{pb.Feature_MUSIC_METADATA}
	if len(m.Features) != len(wantFeatures) {
		t.Fatalf("Features = %v, want %v", m.Features, wantFeatures)
	}
	for i, want := range wantFeatures {
		if m.Features[i] != want {
			t.Errorf("Features[%d] = %v, want %v", i, m.Features[i], want)
		}
	}
}

func TestParsePluginManifestUnknownFeature(t *testing.T) {
	_, err := ParsePluginManifest([]byte(`{"id":"x","features":["NOPE"]}`))
	if err == nil {
		t.Fatal("expected error for unknown feature, got nil")
	}
}

func TestParsePluginManifestNoFeatures(t *testing.T) {
	m, err := ParsePluginManifest([]byte(`{"id":"x","features":[]}`))
	if err != nil {
		t.Fatalf("parsing manifest: %v", err)
	}
	if len(m.Features) != 0 {
		t.Errorf("Features = %v, want empty", m.Features)
	}
}

func TestParsePluginManifestInvalidJSON(t *testing.T) {
	_, err := ParsePluginManifest([]byte(`{not json`))
	if err == nil {
		t.Fatal("expected error for invalid JSON, got nil")
	}
}

// Generated JSON schema for plugin manifests, checked to match the Go struct.
const manifestSchemaPath = "manifest.schema.json"

func compileManifestSchema(t *testing.T) *jsonschema.Schema {
	t.Helper()
	s, err := jsonschema.Compile(manifestSchemaPath)
	if err != nil {
		t.Fatalf("compiling %s: %v", manifestSchemaPath, err)
	}
	return s
}

func TestManifestSchemaExampleValid(t *testing.T) {
	raw, err := os.ReadFile(exampleManifestPath)
	if err != nil {
		t.Fatalf("reading %s: %v", exampleManifestPath, err)
	}
	var instance any
	if err := json.Unmarshal(raw, &instance); err != nil {
		t.Fatalf("decoding %s: %v", exampleManifestPath, err)
	}
	if err := compileManifestSchema(t).Validate(instance); err != nil {
		t.Fatalf("%s does not match %s: %v", exampleManifestPath, manifestSchemaPath, err)
	}
}

func TestManifestSchemaRejects(t *testing.T) {
	base := map[string]any{
		"$schema":     "https://forge.xela.codes/xela/flixur/raw/branch/master/pluginkit/manifest.schema.json",
		"id":          "x",
		"name":        "x",
		"version":     "2024.01.01",
		"features":    []any{},
		"icon":        "mdi:check",
		"description": "x",
		"author":      "x",
		"url":         "https://example.com",
	}
	set := func(m map[string]any, k string, v any) map[string]any {
		c := make(map[string]any, len(m)+1)
		for key, val := range m {
			c[key] = val
		}
		if v == nil {
			delete(c, k)
		} else {
			c[k] = v
		}
		return c
	}
	tests := []struct {
		name     string
		instance map[string]any
	}{
		{"unknown feature", set(base, "features", []any{"NOPE"})},
		{"unspecified feature", set(base, "features", []any{"UNSPECIFIED"})},
		{"unknown property", set(base, "feature", []any{"MUSIC_METADATA"})},
		{"bad version", set(base, "version", "2024-01-01")},
		{"bad icon", set(base, "icon", "music")},
		{"missing required", set(base, "name", nil)},
		{"empty id", set(base, "id", "")},
	}
	s := compileManifestSchema(t)
	for _, test := range tests {
		t.Run(test.name, func(t *testing.T) {
			if err := s.Validate(test.instance); err == nil {
				t.Errorf("schema accepted invalid manifest %v", test.instance)
			}
		})
	}
}

// The schema's feature list must stay in sync with the Feature enum.
func TestManifestSchemaFeatureEnumSync(t *testing.T) {
	raw, err := os.ReadFile(manifestSchemaPath)
	if err != nil {
		t.Fatalf("reading %s: %v", manifestSchemaPath, err)
	}
	var doc struct {
		Properties struct {
			Features struct {
				Items struct {
					Enum []string `json:"enum"`
				} `json:"items"`
			} `json:"features"`
		} `json:"properties"`
	}
	if err := json.Unmarshal(raw, &doc); err != nil {
		t.Fatalf("decoding %s: %v", manifestSchemaPath, err)
	}

	pairs := make([]struct {
		num  int32
		name string
	}, 0, len(pb.Feature_value))
	for name, num := range pb.Feature_value {
		short := strings.TrimPrefix(name, "FEATURE_")
		if short == "UNSPECIFIED" {
			continue
		}
		pairs = append(pairs, struct {
			num  int32
			name string
		}{num, short})
	}
	sort.Slice(pairs, func(i, j int) bool { return pairs[i].num < pairs[j].num })
	want := make([]string, len(pairs))
	for i, pair := range pairs {
		want[i] = pair.name
	}
	if strings.Join(doc.Properties.Features.Items.Enum, ",") != strings.Join(want, ",") {
		t.Errorf("schema feature enum = %v, want %v (run go generate ./schemagen)", doc.Properties.Features.Items.Enum, want)
	}
}
