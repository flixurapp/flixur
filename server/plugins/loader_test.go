package plugins

import (
	"context"
	"errors"
	"os"
	"path/filepath"
	"testing"

	"forge.xela.codes/xela/flixur/pluginkit"
	pb "forge.xela.codes/xela/flixur/pluginkit/proto"
	"github.com/hashicorp/go-plugin"
)

// mockClientProtocol implements plugin.ClientProtocol for tests.
type mockClientProtocol struct {
	dispense func(string) (interface{}, error)
}

func (m *mockClientProtocol) Close() error { return nil }
func (m *mockClientProtocol) Dispense(name string) (interface{}, error) {
	return m.dispense(name)
}
func (m *mockClientProtocol) Ping() error { return nil }

// mockFlixurPlugin implements pluginkit.FlixurPlugin.
type mockFlixurPlugin struct{}

var _ pluginkit.FlixurPlugin = (*mockFlixurPlugin)(nil)

func (m *mockFlixurPlugin) ArtistGet(context.Context, *pb.ArtistGetRequest) (*pb.ArtistGetResponse, error) {
	return nil, nil
}
func (m *mockFlixurPlugin) ArtistSearch(context.Context, *pb.ArtistSearchRequest) (*pb.ArtistSearchResponse, error) {
	return nil, nil
}
func (m *mockFlixurPlugin) AlbumGet(context.Context, *pb.AlbumGetRequest) (*pb.AlbumGetResponse, error) {
	return nil, nil
}
func (m *mockFlixurPlugin) AlbumSearch(context.Context, *pb.AlbumSearchRequest) (*pb.AlbumSearchResponse, error) {
	return nil, nil
}
func (m *mockFlixurPlugin) TrackGet(context.Context, *pb.TrackGetRequest) (*pb.TrackGetResponse, error) {
	return nil, nil
}
func (m *mockFlixurPlugin) TrackSearch(context.Context, *pb.TrackSearchRequest) (*pb.TrackSearchResponse, error) {
	return nil, nil
}

func TestRegisterPluginsMissingDir(t *testing.T) {
	resetPlugins(t, map[string]*Plugin{})

	RegisterPlugins("/definitely/does/not/exist")
	if len(Plugins) != 0 {
		t.Errorf("expected no plugins, got %d", len(Plugins))
	}
}

func TestRegisterPluginsOnlyLoadsJSON(t *testing.T) {
	resetPlugins(t, map[string]*Plugin{})

	dir := t.TempDir()
	manifests := map[string]string{
		"bar.json":          `{"id":"bar","name":"Bar","bin":"/tmp/bar"}`,
		"baz.json.disabled": `{"id":"baz","name":"Baz","bin":"/tmp/baz"}`,
		"qux.txt":           `{"id":"qux","name":"Qux","bin":"/tmp/qux"}`,
	}
	for name, data := range manifests {
		if err := os.WriteFile(filepath.Join(dir, name), []byte(data), 0644); err != nil {
			t.Fatal(err)
		}
	}
	if err := os.Mkdir(filepath.Join(dir, "sub.json"), 0755); err != nil {
		t.Fatal(err)
	}

	var got []string
	oldFactory := pluginClientFactory
	pluginClientFactory = func(bin string) pluginClient {
		got = append(got, bin)
		return &mockPluginClient{err: errors.New("fail")}
	}
	defer func() { pluginClientFactory = oldFactory }()

	RegisterPlugins(dir)
	if len(got) != 1 || got[0] != "/tmp/bar" {
		t.Errorf("expected factory to only be called for bar.json with /tmp/bar, got %v", got)
	}
}

func TestRegisterPluginsInvalidJSON(t *testing.T) {
	resetPlugins(t, map[string]*Plugin{})

	dir := t.TempDir()
	if err := os.WriteFile(filepath.Join(dir, "bad.json"), []byte(`{not json`), 0644); err != nil {
		t.Fatal(err)
	}

	oldFactory := pluginClientFactory
	pluginClientFactory = func(bin string) pluginClient {
		t.Error("expected factory to not be called for invalid manifest")
		return &mockPluginClient{}
	}
	defer func() { pluginClientFactory = oldFactory }()

	RegisterPlugins(dir)
	if len(Plugins) != 0 {
		t.Errorf("expected no plugins, got %d", len(Plugins))
	}
}

func TestRegisterPluginsDuplicateID(t *testing.T) {
	resetPlugins(t, map[string]*Plugin{})

	dir := t.TempDir()
	dup := `{"id":"dup","name":"Dup","bin":"/tmp/dup"}`
	for _, name := range []string{"a.json", "b.json"} {
		if err := os.WriteFile(filepath.Join(dir, name), []byte(dup), 0644); err != nil {
			t.Fatal(err)
		}
	}

	oldFactory := pluginClientFactory
	pluginClientFactory = func(bin string) pluginClient {
		return &mockPluginClient{proto: &mockClientProtocol{
			dispense: func(string) (interface{}, error) {
				return &mockFlixurPlugin{}, nil
			},
		}}
	}
	defer func() { pluginClientFactory = oldFactory }()

	RegisterPlugins(dir)
	if len(Plugins) != 1 {
		t.Errorf("expected 1 plugin, got %d", len(Plugins))
	}
	if Plugins["dup"] == nil {
		t.Error("expected plugin dup to be registered")
	}
}

func TestInitPluginClientError(t *testing.T) {
	resetPlugins(t, map[string]*Plugin{})

	oldFactory := pluginClientFactory
	pluginClientFactory = func(bin string) pluginClient {
		return &mockPluginClient{err: errors.New("client failed")}
	}
	defer func() { pluginClientFactory = oldFactory }()

	InitPlugin(&pluginkit.PluginManifest{Id: "x", Binary: "/tmp/fake"})
	if len(Plugins) != 0 {
		t.Errorf("expected no plugins, got %d", len(Plugins))
	}
}

func TestInitPluginDispenseError(t *testing.T) {
	resetPlugins(t, map[string]*Plugin{})

	oldFactory := pluginClientFactory
	pluginClientFactory = func(bin string) pluginClient {
		return &mockPluginClient{
			proto: &mockClientProtocol{
				dispense: func(string) (interface{}, error) {
					return nil, errors.New("dispense failed")
				},
			},
		}
	}
	defer func() { pluginClientFactory = oldFactory }()

	InitPlugin(&pluginkit.PluginManifest{Id: "x", Binary: "/tmp/fake"})
	if len(Plugins) != 0 {
		t.Errorf("expected no plugins, got %d", len(Plugins))
	}
}

func TestInitPluginMissingBinary(t *testing.T) {
	resetPlugins(t, map[string]*Plugin{})

	oldFactory := pluginClientFactory
	pluginClientFactory = func(bin string) pluginClient {
		t.Error("expected factory to not be called for manifest without binary")
		return &mockPluginClient{}
	}
	defer func() { pluginClientFactory = oldFactory }()

	InitPlugin(&pluginkit.PluginManifest{Id: "x"})
	if len(Plugins) != 0 {
		t.Errorf("expected no plugins, got %d", len(Plugins))
	}
}

func TestInitPluginDuplicateID(t *testing.T) {
	resetPlugins(t, map[string]*Plugin{
		"existing": {Manifest: &pluginkit.PluginManifest{Id: "existing"}},
	})

	oldFactory := pluginClientFactory
	pluginClientFactory = func(bin string) pluginClient {
		return &mockPluginClient{
			proto: &mockClientProtocol{
				dispense: func(string) (interface{}, error) {
					return &mockFlixurPlugin{}, nil
				},
			},
		}
	}
	defer func() { pluginClientFactory = oldFactory }()

	InitPlugin(&pluginkit.PluginManifest{Id: "existing", Binary: "/tmp/fake"})
	if len(Plugins) != 1 {
		t.Errorf("expected 1 plugin, got %d", len(Plugins))
	}
}

func TestInitPluginSuccess(t *testing.T) {
	resetPlugins(t, map[string]*Plugin{})

	killed := false
	oldFactory := pluginClientFactory
	pluginClientFactory = func(bin string) pluginClient {
		return &mockPluginClient{
			killFunc: func() { killed = true },
			proto: &mockClientProtocol{
				dispense: func(string) (interface{}, error) {
					return &mockFlixurPlugin{}, nil
				},
			},
		}
	}
	defer func() { pluginClientFactory = oldFactory }()

	InitPlugin(&pluginkit.PluginManifest{Id: "new", Binary: "/tmp/fake"})
	if len(Plugins) != 1 {
		t.Fatalf("expected 1 plugin, got %d", len(Plugins))
	}
	if Plugins["new"] == nil {
		t.Fatal("expected plugin new")
	}
	Plugins["new"].destroy()
	if !killed {
		t.Error("expected destroy to call Kill")
	}
}

// mockPluginClient implements pluginClient for tests.
type mockPluginClient struct {
	err      error
	proto    plugin.ClientProtocol
	killFunc func()
}

func (m *mockPluginClient) Client() (plugin.ClientProtocol, error) {
	return m.proto, m.err
}
func (m *mockPluginClient) Kill() {
	if m.killFunc != nil {
		m.killFunc()
	}
}
