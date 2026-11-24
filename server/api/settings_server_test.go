// tests for the server-scoped settings routes
package api

import (
	"context"
	"database/sql"
	"fmt"
	"net/http"
	"strings"
	"testing"

	"forge.xela.codes/xela/flixur/common"
	"forge.xela.codes/xela/flixur/ent"
	"forge.xela.codes/xela/flixur/pluginkit"
	pb "forge.xela.codes/xela/flixur/pluginkit/proto"
	plugSettings "forge.xela.codes/xela/flixur/pluginkit/settings"
	"forge.xela.codes/xela/flixur/plugins"
	"forge.xela.codes/xela/flixur/settings"
	"github.com/danielgtaylor/huma/v2/humatest"
	"google.golang.org/grpc"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
)

// Sets up a server with both an admin (via setup) and a regular user,
// returning the API, the admin token and the regular user token.
func setupServerSettingsTest(t *testing.T) (humatest.TestAPI, *ent.Client, string, string) {
	t.Helper()
	client, _, api := newTestAPI(t)

	code := "SETUP1"
	SetServerSetupCode(&code)
	t.Cleanup(func() { SetServerSetupCode(nil) })

	body := setupBody(code, "admin", "password1234")
	resp := api.Post("/auth/setup", append(platformHeaders, body)...)
	if resp.Code != http.StatusOK {
		t.Fatalf("setup status = %d", resp.Code)
	}
	adminToken := decode[struct {
		SessionToken string `json:"sessionToken"`
	}](t, resp).SessionToken

	// regular user with no admin rights
	user, err := client.User.Create().
		SetUsername("user").
		SetPassword("password1234").
		Save(context.Background())
	if err != nil {
		t.Fatal(err)
	}
	// sessions require a client IP
	ctx := context.WithValue(context.Background(), ctxKeyClientIP{}, "127.0.0.1")
	userToken, err := CreateUserSessionToken(ctx, client, user, PlatformHeadersMixin{})
	if err != nil {
		t.Fatal(err)
	}

	return api, client, adminToken, userToken
}

// Swaps the server registry for a fresh one for the duration of the test.
func resetServerRegistry(t *testing.T) {
	t.Helper()
	old := settings.ServerRegistry
	settings.ServerRegistry = settings.NewServerRegistry()
	t.Cleanup(func() { settings.ServerRegistry = old })
}

// Swaps the loaded plugins for the duration of the test.
func resetLoadedPlugins(t *testing.T) {
	t.Helper()
	old := plugins.Plugins
	plugins.Plugins = map[string]*plugins.Plugin{}
	t.Cleanup(func() { plugins.Plugins = old })
}

func TestServerSettingsRequiredAuth(t *testing.T) {
	api, _, admin, user := setupServerSettingsTest(t)

	for _, path := range []string{"/admin/settings/definitions", "/admin/settings/values"} {
		if resp := api.Get(path); resp.Code != http.StatusUnauthorized {
			t.Errorf("no token %s status = %d, want %d", path, resp.Code, http.StatusUnauthorized)
		}

		// regular users are forbidden
		resp := api.Get(path, authHeaders(user)...)
		if resp.Code != http.StatusForbidden {
			t.Errorf("non-admin %s status = %d, want %d", path, resp.Code, http.StatusForbidden)
		}
		if body := decode[APIError](t, resp); body.Code != CodeForbidden {
			t.Errorf("non-admin %s code = %q, want %q", path, body.Code, CodeForbidden)
		}

		// admins are allowed
		if resp := api.Get(path, authHeaders(admin)...); resp.Code != http.StatusOK {
			t.Errorf("admin %s status = %d", path, resp.Code)
		}
	}

	// setting values requires admin too
	resp := api.Put("/admin/settings/values/ui.navigation.testing.bool", append(authHeaders(user), map[string]any{"value": "true"})...)
	if resp.Code != http.StatusForbidden {
		t.Errorf("non-admin put status = %d, want %d", resp.Code, http.StatusForbidden)
	}
}

func TestServerSettingsDefinitions(t *testing.T) {
	api, _, admin, _ := setupServerSettingsTest(t)
	resetServerRegistry(t)

	// merge a fake plugin's settings so there is something namespaced to find
	manifest := &pluginkit.PluginManifest{Id: "example", Icon: "mdi:music"}
	groups := []*pb.SettingsGroup{{Id: "greeting", Order: 1}}
	defs := []*pb.SettingsDefinition{
		plugSettings.String("greeting.apiKey", "").Secret(true).Order(1).SettingsDefinition,
	}
	if err := settings.MergePluginSettings(manifest, groups, defs); err != nil {
		t.Fatal(err)
	}

	resp := api.Get("/admin/settings/definitions", authHeaders(admin)...)
	if resp.Code != http.StatusOK {
		t.Fatalf("status = %d", resp.Code)
	}
	body := decode[SettingsDefinitionsBody](t, resp)

	found := false
	for _, def := range body.List {
		if def.Id == "server.plugins.example.greeting.apiKey" {
			found = true
			// the kind round-trips as its string name
			if def.Kind != pb.Kind_STRING {
				t.Errorf("kind = %v, want string", def.Kind)
			}
			if !def.IsSecret() {
				t.Error("secret flag was lost over the wire")
			}
		}
	}
	if !found {
		t.Errorf("namespaced definition missing from response")
	}

	// groups include the whole auto-created chain
	groupIDs := map[string]bool{}
	for _, group := range body.Groups {
		groupIDs[group.Id] = true
	}
	for _, want := range []string{"server", "server.plugins", "server.plugins.example", "server.plugins.example.greeting"} {
		if !groupIDs[want] {
			t.Errorf("missing group %s in response", want)
		}
	}
}

func TestServerSettingValues(t *testing.T) {
	api, _, admin, _ := setupServerSettingsTest(t)
	resetServerRegistry(t)

	// register test settings under the core group
	settings.ServerRegistry.RegisterGroup(plugSettings.Group("server.test"))
	boolDef := settings.ServerRegistry.Register(plugSettings.Bool("server.test.bool", false).Order(1))
	intDef := settings.ServerRegistry.Register(plugSettings.Int("server.test.int", 0).Min(1).Max(10).Order(2))

	// set a bool value
	resp := api.Put("/admin/settings/values/"+boolDef.Id, append(authHeaders(admin), map[string]any{"value": "true"})...)
	if resp.Code != http.StatusOK {
		t.Fatalf("put status = %d, body = %s", resp.Code, resp.Body.String())
	}
	entry := decode[SettingValueEntry](t, resp)
	if entry.Value != "true" || entry.UpdatedAt.IsZero() {
		t.Errorf("entry = %+v", entry)
	}

	// get values contains it
	resp = api.Get("/admin/settings/values", authHeaders(admin)...)
	values := decode[SettingValuesBody](t, resp)
	if len(values.Values) != 1 || values.Values[boolDef.Id].Value != "true" {
		t.Fatalf("values = %+v", values.Values)
	}

	// update overwrites instead of duplicating
	resp = api.Put("/admin/settings/values/"+boolDef.Id, append(authHeaders(admin), map[string]any{"value": "false"})...)
	if resp.Code != http.StatusOK {
		t.Fatalf("re-put status = %d", resp.Code)
	}
	resp = api.Get("/admin/settings/values", authHeaders(admin)...)
	if n := len(decode[SettingValuesBody](t, resp).Values); n != 1 {
		t.Errorf("expected 1 stored value, got %d", n)
	}

	// invalid value for the kind is rejected
	resp = api.Put("/admin/settings/values/"+boolDef.Id, append(authHeaders(admin), map[string]any{"value": `"nope"`})...)
	if resp.Code != http.StatusBadRequest {
		t.Errorf("invalid value status = %d", resp.Code)
	}

	// out-of-bounds int is rejected
	resp = api.Put("/admin/settings/values/"+intDef.Id, append(authHeaders(admin), map[string]any{"value": fmt.Sprintf("%d", *intDef.Int.Max+1)})...)
	if resp.Code != http.StatusBadRequest {
		t.Errorf("out of bounds int status = %d", resp.Code)
	}

	// unknown setting 404s
	resp = api.Put("/admin/settings/values/server.unknown", append(authHeaders(admin), map[string]any{"value": "1"})...)
	if resp.Code != http.StatusNotFound {
		t.Errorf("unknown setting status = %d", resp.Code)
	}
}

func TestServerSettingSecretStorage(t *testing.T) {
	api, _, admin, _ := setupServerSettingsTest(t)
	resetServerRegistry(t)
	resetConfig(t)
	// configure a valid encryption key
	common.Config.SettingsKey = strings.Repeat("ab", 32)

	// register two secret settings, one for each scenario
	settings.ServerRegistry.RegisterGroup(plugSettings.Group("server.test"))
	def := settings.ServerRegistry.Register(plugSettings.String("server.test.apiKey", "").Secret(true).Order(1))
	fallbackDef := settings.ServerRegistry.Register(plugSettings.String("server.test.fallbackKey", "").Secret(true).Order(2))

	// the value comes back unmasked so it can be edited by clients
	resp := api.Put("/admin/settings/values/"+def.Id, append(authHeaders(admin), map[string]any{"value": `"super-secret"`})...)
	if resp.Code != http.StatusOK {
		t.Fatalf("put status = %d, body = %s", resp.Code, resp.Body.String())
	}
	if got := decode[SettingValueEntry](t, resp).Value; got != `"super-secret"` {
		t.Errorf("response value = %q, want the plaintext", got)
	}
	resp = api.Get("/admin/settings/values", authHeaders(admin)...)
	if got := decode[SettingValuesBody](t, resp).Values[def.Id].Value; got != `"super-secret"` {
		t.Errorf("listed value = %q, want the plaintext", got)
	}

	// ...but the database only holds ciphertext (reads transparently decrypt)
	db, err := sql.Open("sqlite3", common.TestDSN(t))
	if err != nil {
		t.Fatal(err)
	}
	defer db.Close()
	var stored string
	if err := db.QueryRow(`SELECT value FROM server_settings WHERE setting_id = ?`, def.Id).Scan(&stored); err != nil {
		t.Fatal(err)
	}
	if strings.Contains(stored, "super-secret") {
		t.Error("plaintext leaked into the database")
	}
	if plain, err := settings.DecryptSecret(stored); err != nil || plain != `"super-secret"` {
		t.Errorf("stored value = %q (decrypt: %v), want a round-tripping ciphertext", stored, err)
	}

	// without a configured key, secret values degrade to plaintext storage
	// (a fresh setting, since the encrypted row above is unreadable without a key)
	common.Config.SettingsKey = ""
	if err := settings.CheckSecretKey(); err != nil {
		t.Errorf("missing key errored: %v", err)
	}
	resp = api.Put("/admin/settings/values/"+fallbackDef.Id, append(authHeaders(admin), map[string]any{"value": `"plain-fallback"`})...)
	if resp.Code != http.StatusOK {
		t.Fatalf("plaintext fallback put status = %d, body = %s", resp.Code, resp.Body.String())
	}
	if err := db.QueryRow(`SELECT value FROM server_settings WHERE setting_id = ?`, fallbackDef.Id).Scan(&stored); err != nil {
		t.Fatal(err)
	}
	if stored != `"plain-fallback"` {
		t.Errorf("stored value = %q, want the plaintext fallback", stored)
	}

	// an invalid configured key still fails at startup
	common.Config.SettingsKey = "zz"
	if err := settings.CheckSecretKey(); err == nil {
		t.Error("invalid key was not rejected")
	}
}

// Minimal plugin RPC mock for the settings routes.
type mockPluginRPC struct {
	pb.FlixurPluginServiceClient
	updates []*pb.SettingsUpdateRequest
}

func (m *mockPluginRPC) Init(ctx context.Context, req *pb.InitRequest, _ ...grpc.CallOption) (*pb.InitResponse, error) {
	return nil, status.Error(codes.Unimplemented, "not implemented")
}

func (m *mockPluginRPC) SettingsUpdate(ctx context.Context, req *pb.SettingsUpdateRequest, _ ...grpc.CallOption) (*pb.SettingsUpdateResponse, error) {
	m.updates = append(m.updates, req)
	return &pb.SettingsUpdateResponse{}, nil
}

func TestServerSettingChangeNotifiesPlugin(t *testing.T) {
	api, _, admin, _ := setupServerSettingsTest(t)
	resetServerRegistry(t)
	resetLoadedPlugins(t)
	// the plugin's setting is secret, so a key is needed to store values
	resetConfig(t)
	common.Config.SettingsKey = strings.Repeat("ab", 32)

	// register a fake loaded plugin with a namespaced setting
	mock := &mockPluginRPC{}
	plugins.Plugins["example"] = &plugins.Plugin{
		Manifest: &pluginkit.PluginManifest{Id: "example", Icon: "mdi:music"},
		RPC:      mock,
	}
	if err := settings.MergePluginSettings(
		&pluginkit.PluginManifest{Id: "example", Icon: "mdi:music"},
		[]*pb.SettingsGroup{{Id: "greeting", Order: 1}},
		[]*pb.SettingsDefinition{plugSettings.String("greeting.apiKey", "").Secret(true).Order(1).SettingsDefinition},
	); err != nil {
		t.Fatal(err)
	}

	resp := api.Put("/admin/settings/values/server.plugins.example.greeting.apiKey",
		append(authHeaders(admin), map[string]any{"value": `"new-key"`})...)
	if resp.Code != http.StatusOK {
		t.Fatalf("put status = %d, body = %s", resp.Code, resp.Body.String())
	}

	// the plugin received a snapshot with the new value
	if len(mock.updates) != 1 {
		t.Fatalf("expected 1 settings push, got %d", len(mock.updates))
	}
	if got := mock.updates[0].Values["server.plugins.example.greeting.apiKey"]; got != `"new-key"` {
		t.Errorf("pushed value = %q", got)
	}
}
