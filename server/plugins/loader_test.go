package plugins

import (
	"context"
	"errors"
	"os"
	"path/filepath"
	"testing"

	"forge.xela.codes/xela/flixur/common"
	"forge.xela.codes/xela/flixur/ent/enttest"
	"forge.xela.codes/xela/flixur/pluginkit"
	pb "forge.xela.codes/xela/flixur/pluginkit/proto"
	"forge.xela.codes/xela/flixur/pluginkit/settings"
	serverSettings "forge.xela.codes/xela/flixur/settings"
	"github.com/hashicorp/go-plugin"
	_ "github.com/mattn/go-sqlite3"
	"google.golang.org/grpc"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
)

// mockClientProtocol implements plugin.ClientProtocol for tests.
type mockClientProtocol struct {
	dispense func(string) (any, error)
}

func (m *mockClientProtocol) Close() error { return nil }
func (m *mockClientProtocol) Dispense(name string) (any, error) {
	return m.dispense(name)
}
func (m *mockClientProtocol) Ping() error { return nil }

type mockFlixurPlugin struct {
	pb.FlixurPluginServiceClient
	initResp  *pb.InitResponse
	initErr   error
	initCalls int
	// recorded settings snapshots
	updates   []*pb.SettingsUpdateRequest
	updateErr error
}

var _ pb.FlixurPluginServiceClient = (*mockFlixurPlugin)(nil)

func (m *mockFlixurPlugin) Init(ctx context.Context, req *pb.InitRequest, _ ...grpc.CallOption) (*pb.InitResponse, error) {
	m.initCalls++
	if m.initResp == nil && m.initErr == nil {
		return nil, status.Error(codes.Unimplemented, "not implemented")
	}
	return m.initResp, m.initErr
}

func (m *mockFlixurPlugin) SettingsUpdate(ctx context.Context, req *pb.SettingsUpdateRequest, _ ...grpc.CallOption) (*pb.SettingsUpdateResponse, error) {
	m.updates = append(m.updates, req)
	if m.updateErr != nil {
		return nil, m.updateErr
	}
	return &pb.SettingsUpdateResponse{}, nil
}

func TestRegisterPluginsMissingDir(t *testing.T) {
	resetPlugins(t, map[string]*Plugin{})

	RegisterPlugins("/definitely/does/not/exist", nil)
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

	RegisterPlugins(dir, nil)
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

	RegisterPlugins(dir, nil)
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
			dispense: func(string) (any, error) {
				return &mockFlixurPlugin{}, nil
			},
		}}
	}
	defer func() { pluginClientFactory = oldFactory }()

	RegisterPlugins(dir, nil)
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

	InitPlugin(&pluginkit.PluginManifest{Id: "x", Binary: "/tmp/fake"}, nil)
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
				dispense: func(string) (any, error) {
					return nil, errors.New("dispense failed")
				},
			},
		}
	}
	defer func() { pluginClientFactory = oldFactory }()

	InitPlugin(&pluginkit.PluginManifest{Id: "x", Binary: "/tmp/fake"}, nil)
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

	InitPlugin(&pluginkit.PluginManifest{Id: "x"}, nil)
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
				dispense: func(string) (any, error) {
					return &mockFlixurPlugin{}, nil
				},
			},
		}
	}
	defer func() { pluginClientFactory = oldFactory }()

	InitPlugin(&pluginkit.PluginManifest{Id: "existing", Binary: "/tmp/fake"}, nil)
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
				dispense: func(string) (any, error) {
					return &mockFlixurPlugin{}, nil
				},
			},
		}
	}
	defer func() { pluginClientFactory = oldFactory }()

	InitPlugin(&pluginkit.PluginManifest{Id: "new", Binary: "/tmp/fake"}, nil)
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

// Swaps the server registry for a fresh one for the duration of the test.
func resetServerRegistry(t *testing.T) {
	t.Helper()
	old := serverSettings.ServerRegistry
	serverSettings.ServerRegistry = serverSettings.NewServerRegistry()
	t.Cleanup(func() { serverSettings.ServerRegistry = old })
}

// Creates a test plugin whose mock RPC is configured by the caller.
func mockPlugin(t *testing.T, id string, configure func(*mockFlixurPlugin)) (killed *bool) {
	t.Helper()
	resetPlugins(t, map[string]*Plugin{})
	resetServerRegistry(t)

	wasKilled := false
	killed = &wasKilled
	mock := &mockFlixurPlugin{}
	if configure != nil {
		configure(mock)
	}
	oldFactory := pluginClientFactory
	pluginClientFactory = func(bin string) pluginClient {
		return &mockPluginClient{
			killFunc: func() { *killed = true },
			proto: &mockClientProtocol{
				dispense: func(string) (any, error) {
					return mock, nil
				},
			},
		}
	}
	t.Cleanup(func() { pluginClientFactory = oldFactory })
	return killed
}

func TestInitPluginSettingsRegistered(t *testing.T) {
	killed := mockPlugin(t, "settingsplugin", func(m *mockFlixurPlugin) {
		m.initResp = settings.Snapshot(func() *settings.Registry {
			reg := settings.NewRegistry()
			reg.RegisterGroup(settings.Group("cache").Icon("mdi:cache").Order(1))
			reg.Register(settings.Bool("cache.enabled", true).Order(1))
			reg.Register(settings.String("cache.key", "").Secret(true).Order(2))
			return reg
		}())
	})

	InitPlugin(&pluginkit.PluginManifest{Id: "settingsplugin", Binary: "/tmp/fake", Icon: "mdi:rock"}, nil)
	if *killed {
		t.Fatal("plugin was killed")
	}

	def := serverSettings.ServerRegistry.Find("server.plugins.settingsplugin.cache.enabled")
	if def == nil || def.Bool == nil || !def.Bool.DefaultValue {
		t.Fatalf("definition not namespaced correctly: %+v", def)
	}
	if serverSettings.ServerRegistry.FindGroup("server.plugins") == nil {
		t.Error("auto-created server.plugins group missing")
	}
	pluginGroup := serverSettings.ServerRegistry.FindGroup("server.plugins.settingsplugin")
	if pluginGroup == nil || pluginGroup.Icon == nil || *pluginGroup.Icon != "mdi:rock" {
		t.Errorf("plugin group = %+v", pluginGroup)
	}
}

func TestInitPluginSettingsErrorKillsPlugin(t *testing.T) {
	t.Run("invalid definition", func(t *testing.T) {
		killed := mockPlugin(t, "brokenplugin", func(m *mockFlixurPlugin) {
			// definition without its group
			m.initResp = &pb.InitResponse{
				Definitions: []*pb.SettingsDefinition{settings.Bool("orphan.setting", true).SettingsDefinition},
			}
		})

		InitPlugin(&pluginkit.PluginManifest{Id: "brokenplugin", Binary: "/tmp/fake"}, nil)
		if len(Plugins) != 0 {
			t.Error("broken plugin was still registered")
		}
		if !*killed {
			t.Error("broken plugin was not killed")
		}
	})

	t.Run("handshake error", func(t *testing.T) {
		killed := mockPlugin(t, "errplugin", func(m *mockFlixurPlugin) {
			m.initErr = status.Error(codes.Internal, "boom")
		})

		InitPlugin(&pluginkit.PluginManifest{Id: "errplugin", Binary: "/tmp/fake"}, nil)
		if len(Plugins) != 0 {
			t.Error("failing plugin was still registered")
		}
		if !*killed {
			t.Error("failing plugin was not killed")
		}
	})
}

func TestInitPluginSettingsValuePush(t *testing.T) {
	client := enttest.Open(t, "sqlite3", common.TestDSN(t))
	t.Cleanup(func() { client.Close() })

	var mock *mockFlixurPlugin
	killed := mockPlugin(t, "valuesplugin", func(m *mockFlixurPlugin) {
		mock = m
		m.initResp = settings.Snapshot(func() *settings.Registry {
			reg := settings.NewRegistry()
			reg.RegisterGroup(settings.Group("cache"))
			reg.Register(settings.Int("cache.size", 10).Order(1))
			return reg
		}())
	})

	// store a value for the plugin to receive
	ctx := context.Background()
	if _, err := client.ServerSetting.Create().
		SetSettingID("server.plugins.valuesplugin.cache.size").
		SetValue(serverSettings.SettingText{Raw: "42"}).
		Save(ctx); err != nil {
		t.Fatal(err)
	}

	InitPlugin(&pluginkit.PluginManifest{Id: "valuesplugin", Binary: "/tmp/fake"}, client)
	if *killed {
		t.Fatal("plugin was killed")
	}
	if len(mock.updates) != 1 {
		t.Fatalf("expected 1 settings push, got %d", len(mock.updates))
	}
	snapshot := mock.updates[0]
	if got := snapshot.Values["server.plugins.valuesplugin.cache.size"]; got != "42" {
		t.Errorf("pushed values = %v", snapshot.Values)
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
