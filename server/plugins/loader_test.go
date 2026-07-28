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
type mockFlixurPlugin struct {
	info *pb.PluginInfo
	err  error
}

var _ pluginkit.FlixurPlugin = (*mockFlixurPlugin)(nil)

func (m *mockFlixurPlugin) GetPluginInfo(context.Context) (*pb.PluginInfo, error) {
	return m.info, m.err
}
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

func TestRegisterPluginsIgnoresDisabled(t *testing.T) {
	resetPlugins(t, map[string]*Plugin{})

	dir := t.TempDir()
	if err := os.WriteFile(filepath.Join(dir, "plugin.disabled"), []byte(""), 0644); err != nil {
		t.Fatal(err)
	}
	if err := os.WriteFile(filepath.Join(dir, "not-disabled"), []byte(""), 0644); err != nil {
		t.Fatal(err)
	}

	called := false
	oldFactory := pluginClientFactory
	pluginClientFactory = func(bin string) pluginClient {
		called = true
		return &mockPluginClient{err: errors.New("fail")}
	}
	defer func() { pluginClientFactory = oldFactory }()

	RegisterPlugins(dir)
	if !called {
		t.Error("expected InitPlugin to be called for non-disabled file")
	}
}

func TestInitPluginClientError(t *testing.T) {
	resetPlugins(t, map[string]*Plugin{})

	oldFactory := pluginClientFactory
	pluginClientFactory = func(bin string) pluginClient {
		return &mockPluginClient{err: errors.New("client failed")}
	}
	defer func() { pluginClientFactory = oldFactory }()

	InitPlugin("/tmp/fake")
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

	InitPlugin("/tmp/fake")
	if len(Plugins) != 0 {
		t.Errorf("expected no plugins, got %d", len(Plugins))
	}
}

func TestInitPluginInfoError(t *testing.T) {
	resetPlugins(t, map[string]*Plugin{})

	oldFactory := pluginClientFactory
	pluginClientFactory = func(bin string) pluginClient {
		return &mockPluginClient{
			proto: &mockClientProtocol{
				dispense: func(string) (interface{}, error) {
					return &mockFlixurPlugin{err: errors.New("info failed")}, nil
				},
			},
		}
	}
	defer func() { pluginClientFactory = oldFactory }()

	InitPlugin("/tmp/fake")
	if len(Plugins) != 0 {
		t.Errorf("expected no plugins, got %d", len(Plugins))
	}
}

func TestInitPluginDuplicateID(t *testing.T) {
	resetPlugins(t, map[string]*Plugin{
		"existing": {Info: &pb.PluginInfo{Id: "existing"}},
	})

	oldFactory := pluginClientFactory
	pluginClientFactory = func(bin string) pluginClient {
		return &mockPluginClient{
			proto: &mockClientProtocol{
				dispense: func(string) (interface{}, error) {
					return &mockFlixurPlugin{info: &pb.PluginInfo{Id: "existing", Name: "Dup"}}, nil
				},
			},
		}
	}
	defer func() { pluginClientFactory = oldFactory }()

	InitPlugin("/tmp/fake")
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
					return &mockFlixurPlugin{info: &pb.PluginInfo{Id: "new", Name: "New"}}, nil
				},
			},
		}
	}
	defer func() { pluginClientFactory = oldFactory }()

	InitPlugin("/tmp/fake")
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
