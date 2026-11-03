package pluginkit

import (
	"os"
	"testing"

	pb "forge.xela.codes/xela/flixur/pluginkit/proto"
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

	wantFeatures := []pb.Feature{pb.Feature_FEATURE_MUSIC_METADATA}
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
