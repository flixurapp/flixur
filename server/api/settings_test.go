// tests for the settings routes
package api

import (
	"fmt"
	"net/http"
	"reflect"
	"strings"
	"testing"

	"forge.xela.codes/xela/flixur/settings"
	"github.com/danielgtaylor/huma/v2/humatest"
)

// Sets up a server with a logged-in account, returning the API and
// the raw session token.
func setupSettingsTest(t *testing.T) (humatest.TestAPI, string) {
	t.Helper()
	_, _, api := newTestAPI(t)

	code := "SETUP1"
	SetServerSetupCode(&code)
	t.Cleanup(func() { SetServerSetupCode(nil) })

	body := setupBody(code, "admin", "password1234")
	resp := api.Post("/auth/setup", append(platformHeaders, body)...)
	if resp.Code != http.StatusOK {
		t.Fatalf("setup status = %d", resp.Code)
	}
	token := decode[struct {
		SessionToken string `json:"sessionToken"`
	}](t, resp).SessionToken
	if token == "" {
		t.Fatal("expected session token")
	}
	return api, token
}

func authHeaders(token string) []any {
	return []any{"Authorization: Bearer " + token}
}

func TestSettingsRequiredAuth(t *testing.T) {
	api, _ := setupSettingsTest(t)

	if resp := api.Get("/settings/definitions"); resp.Code != http.StatusUnauthorized {
		t.Errorf("no token status = %d, want %d", resp.Code, http.StatusUnauthorized)
	}
	if resp := api.Get("/settings/profiles"); resp.Code != http.StatusUnauthorized {
		t.Errorf("no token status = %d, want %d", resp.Code, http.StatusUnauthorized)
	}

	// listing with an invalid token is rejected
	resp := api.Get("/settings/definitions", authHeaders("garbage")...)
	if resp.Code != http.StatusUnauthorized {
		t.Errorf("bad token status = %d, want %d", resp.Code, http.StatusUnauthorized)
	}
}

func TestSettingsDefinitions(t *testing.T) {
	api, token := setupSettingsTest(t)

	resp := api.Get("/settings/definitions", authHeaders(token)...)
	if resp.Code != http.StatusOK {
		t.Fatalf("status = %d", resp.Code)
	}
	body := decode[SettingsDefinitionsBody](t, resp)

	// the response must mirror the client registry
	defs := settings.ClientRegistry.All()
	if len(defs) == 0 {
		t.Fatal("client registry is empty, nothing to verify")
	}
	if len(body.List) != len(defs) {
		t.Fatalf("response has %d definitions, registry has %d", len(body.List), len(defs))
	}

	// every registry definition must survive the JSON round-trip intact
	byID := map[string]*settings.SettingsDefinition{}
	for _, def := range body.List {
		byID[def.ID] = def
	}
	for _, want := range defs {
		got := byID[want.ID]
		if got == nil {
			t.Errorf("missing definition %s", want.ID)
			continue
		}
		if !reflect.DeepEqual(got, want) {
			t.Errorf("definition %s differs from registry:\n wire = %+v\n reg  = %+v", want.ID, got, want)
		}
	}

	// groups too
	groups := settings.ClientRegistry.Groups()
	if len(body.Groups) != len(groups) {
		t.Fatalf("response has %d groups, registry has %d", len(body.Groups), len(groups))
	}
	respGroups := map[string]bool{}
	for _, group := range body.Groups {
		respGroups[group.ID] = true
	}
	for _, want := range groups {
		if !respGroups[want.ID] {
			t.Errorf("missing group %s in the definitions response", want.ID)
		}
	}
}

func TestSettingsProfilesLifecycle(t *testing.T) {
	api, token := setupSettingsTest(t)

	// listing lazily creates the default profile
	resp := api.Get("/settings/profiles", authHeaders(token)...)
	if resp.Code != http.StatusOK {
		t.Fatalf("status = %d", resp.Code)
	}
	profiles := decode[SettingsProfilesBody](t, resp)
	if len(profiles.List) != 1 || profiles.List[0].Name != "Default" {
		t.Fatalf("profiles = %+v", profiles.List)
	}
	defaultProfile := profiles.List[0]

	// repeated listing shouldn't create more profiles
	resp = api.Get("/settings/profiles", authHeaders(token)...)
	if n := len(decode[SettingsProfilesBody](t, resp).List); n != 1 {
		t.Fatalf("repeated listing returned %d profiles", n)
	}

	// create another profile
	resp = api.Post("/settings/profiles", append(authHeaders(token), map[string]string{"name": "Gaming"})...)
	if resp.Code != http.StatusOK {
		t.Fatalf("create status = %d", resp.Code)
	}
	created := decode[SettingProfileBody](t, resp)
	if created.Name != "Gaming" || created.ID == "" {
		t.Fatalf("created = %+v", created)
	}

	// duplicate name (case-insensitive) is rejected
	resp = api.Post("/settings/profiles", append(authHeaders(token), map[string]string{"name": "gaming"})...)
	if resp.Code != http.StatusConflict {
		t.Errorf("duplicate create status = %d", resp.Code)
	}

	// empty name is rejected with code
	resp = api.Post("/settings/profiles", append(authHeaders(token), map[string]string{"name": ""})...)
	if resp.Code != http.StatusBadRequest {
		t.Errorf("empty name status = %d, want 400", resp.Code)
	}
	if body := decode[APIError](t, resp); body.Code != CodeTooShort {
		t.Errorf("empty name code = %q, want %q", body.Code, CodeTooShort)
	}

	// too long of a name is rejected with the proper code
	resp = api.Post("/settings/profiles", append(authHeaders(token), map[string]string{
		"name": strings.Repeat("a", 101),
	})...)
	if resp.Code != http.StatusBadRequest {
		t.Errorf("long name status = %d, want 400", resp.Code)
	}
	if body := decode[APIError](t, resp); body.Code != CodeTooLong {
		t.Errorf("long name code = %q, want %q", body.Code, CodeTooLong)
	}

	// rename works
	resp = api.Put("/settings/profiles/"+created.ID, append(authHeaders(token), map[string]string{"name": "Media"})...)
	if resp.Code != http.StatusOK {
		t.Fatalf("rename status = %d", resp.Code)
	}
	resp = api.Get("/settings/profiles", authHeaders(token)...)
	names := []string{}
	for _, profile := range decode[SettingsProfilesBody](t, resp).List {
		names = append(names, profile.Name)
	}
	if len(names) != 2 || names[0] != "Default" || names[1] != "Media" {
		t.Errorf("after rename = %v", names)
	}

	// renaming onto a taken name is rejected as a conflict
	resp = api.Put("/settings/profiles/"+created.ID, append(authHeaders(token), map[string]string{"name": "default"})...)
	if resp.Code != http.StatusConflict {
		t.Errorf("rename collision status = %d, want 409", resp.Code)
	}

	// delete the extra profile
	resp = api.Delete("/settings/profiles/"+created.ID, authHeaders(token)...)
	if resp.Code != http.StatusOK {
		t.Fatalf("delete status = %d", resp.Code)
	}

	// deleting the last remaining profile is rejected
	resp = api.Delete("/settings/profiles/"+defaultProfile.ID, authHeaders(token)...)
	if resp.Code != http.StatusConflict {
		t.Errorf("last profile delete status = %d, want 409", resp.Code)
	}

	// deleting an unknown profile 404s
	resp = api.Delete("/settings/profiles/unknown123", authHeaders(token)...)
	if resp.Code != http.StatusNotFound {
		t.Errorf("unknown delete status = %d", resp.Code)
	}
}

func TestSettingsProfileValues(t *testing.T) {
	api, token := setupSettingsTest(t)

	// search for a bool and a bounded int setting from the registry so this test
	// doesn't depend on specific setting IDs or their bounds
	var boolDef, intDef *settings.SettingsDefinition
	for _, def := range settings.ClientRegistry.All() {
		switch {
		case def.Bool != nil && boolDef == nil:
			boolDef = def
		case def.Int != nil && def.Int.Min != nil && def.Int.Max != nil && intDef == nil:
			intDef = def
		}
	}
	if boolDef == nil {
		t.Fatal("no bool setting in the client registry")
	}
	if intDef == nil {
		t.Fatal("no bounded int setting in the client registry")
	}

	resp := api.Get("/settings/profiles", authHeaders(token)...)
	profiles := decode[SettingsProfilesBody](t, resp)
	profileID := profiles.List[0].ID

	// set a bool override
	resp = api.Put("/settings/profiles/"+profileID+"/values/"+boolDef.ID,
		append(authHeaders(token), map[string]any{"value": "false"})...)
	if resp.Code != http.StatusOK {
		t.Fatalf("put bool status = %d, body = %s", resp.Code, resp.Body.String())
	}
	entry := decode[SettingValueEntry](t, resp)
	if entry.Value != "false" || entry.UpdatedAt.IsZero() {
		t.Errorf("bool value entry = %+v", entry)
	}

	// get values contains it
	resp = api.Get("/settings/profiles/"+profileID+"/values", authHeaders(token)...)
	values := decode[SettingValuesBody](t, resp)
	if len(values.Values) != 1 || values.Values[boolDef.ID].Value != "false" {
		t.Fatalf("values = %+v", values.Values)
	}

	// update overwrites
	resp = api.Put("/settings/profiles/"+profileID+"/values/"+boolDef.ID,
		append(authHeaders(token), map[string]any{"value": "true"})...)
	if resp.Code != http.StatusOK {
		t.Fatalf("re-put bool status = %d", resp.Code)
	}
	resp = api.Get("/settings/profiles/"+profileID+"/values", authHeaders(token)...)
	if n := len(decode[SettingValuesBody](t, resp).Values); n != 1 {
		t.Errorf("expected 1 override, got %d", n)
	}

	// invalid value for the kind is rejected
	resp = api.Put("/settings/profiles/"+profileID+"/values/"+boolDef.ID,
		append(authHeaders(token), map[string]any{"value": "\"nope\""})...)
	if resp.Code != http.StatusBadRequest {
		t.Errorf("invalid bool status = %d", resp.Code)
	}

	// out-of-bounds int is rejected
	resp = api.Put("/settings/profiles/"+profileID+"/values/"+intDef.ID,
		append(authHeaders(token), map[string]any{"value": fmt.Sprintf("%d", *intDef.Int.Max+1)})...)
	if resp.Code != http.StatusBadRequest {
		t.Errorf("out of bounds int status = %d", resp.Code)
	}

	// unknown setting 404s
	resp = api.Put("/settings/profiles/"+profileID+"/values/ui.unknown.setting",
		append(authHeaders(token), map[string]any{"value": "1"})...)
	if resp.Code != http.StatusNotFound {
		t.Errorf("unknown setting status = %d", resp.Code)
	}

	// unknown profile 404s
	resp = api.Get("/settings/profiles/unknown123/values", authHeaders(token)...)
	if resp.Code != http.StatusNotFound {
		t.Errorf("unknown profile status = %d", resp.Code)
	}
}
