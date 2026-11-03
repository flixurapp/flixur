package plugins

import (
	"testing"

	"forge.xela.codes/xela/flixur/pluginkit"
	pb "forge.xela.codes/xela/flixur/pluginkit/proto"
)

func TestPluginHasFeature(t *testing.T) {
	p := &Plugin{Manifest: &pluginkit.PluginManifest{Features: []pb.Feature{pb.Feature_MUSIC_METADATA}}}
	if !p.HasFeature(pb.Feature_MUSIC_METADATA) {
		t.Error("expected plugin to have MUSIC_METADATA")
	}
	if p.HasFeature(pb.Feature(-999)) {
		t.Error("expected plugin not to have unknown feature")
	}
}

func TestFindPluginByID(t *testing.T) {
	resetPlugins(t, map[string]*Plugin{
		"a": {Manifest: &pluginkit.PluginManifest{Id: "a"}},
	})

	if p := FindPluginByID("a"); p == nil {
		t.Error("expected to find plugin a")
	}
	if p := FindPluginByID("b"); p != nil {
		t.Errorf("expected nil, got %v", p)
	}
}

func TestFindPluginsByFeature(t *testing.T) {
	resetPlugins(t, map[string]*Plugin{
		"a": {Manifest: &pluginkit.PluginManifest{Id: "a", Features: []pb.Feature{pb.Feature_MUSIC_METADATA}}},
		"b": {Manifest: &pluginkit.PluginManifest{Id: "b", Features: []pb.Feature{}}},
	})

	found := FindPluginsByFeature(pb.Feature_MUSIC_METADATA)
	if len(found) != 1 || found[0].Manifest.Id != "a" {
		t.Errorf("expected 1 plugin with feature, got %v", found)
	}
}

func TestDestroyAllPlugins(t *testing.T) {
	called := false
	resetPlugins(t, map[string]*Plugin{
		"a": {
			Manifest: &pluginkit.PluginManifest{Id: "a"},
			destroy:  func() { called = true },
		},
	})

	DestroyAllPlugins()
	if !called {
		t.Error("expected destroy callback to be called")
	}
}
