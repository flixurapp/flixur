// tests for the settings routes
package api

import (
	"net/http"
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
	if len(body.List) < 6 {
		t.Fatalf("expected at least 6 definitions, got %d", len(body.List))
	}
	if len(body.Groups) < 4 {
		t.Fatalf("expected at least 4 groups, got %d", len(body.Groups))
	}
	registryGroups := map[string]bool{}
	for _, group := range body.Groups {
		registryGroups[group.ID] = true
	}
	for _, expected := range []string{"ui", "ui.navigation", "ui.titlebar", "ui.library"} {
		if !registryGroups[expected] {
			t.Errorf("missing group %s in the definitions response", expected)
		}
	}

	// spot check a bool, an int and a list definition
	byID := map[string]*settings.SettingsDefinition{}
	for _, def := range body.List {
		byID[def.ID] = def
	}
	boolDef := byID["ui.titlebar.startMaximized"]
	if boolDef == nil || boolDef.Kind != settings.KindBool ||
		boolDef.Bool == nil || !boolDef.Bool.Default {
		t.Errorf("startMaximized definition = %+v", boolDef)
	}
	intDef := byID["ui.library.cardsPerRow"]
	if intDef == nil || intDef.Kind != settings.KindInt ||
		intDef.Int == nil || intDef.Int.Default != 6 {
		t.Errorf("cardsPerRow definition = %+v", intDef)
	}
	listDef := byID["ui.navigation.shownSections"]
	if listDef == nil || listDef.StringList == nil || len(listDef.StringList.Default) != 5 {
		t.Errorf("shownSections definition = %+v", listDef)
	}
	if len(listDef.StringList.Choices) != 7 {
		t.Errorf("shownSections choices = %+v", listDef.StringList.Choices)
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

	// empty name is rejected
	resp = api.Post("/settings/profiles", append(authHeaders(token), map[string]string{"name": ""})...)
	if resp.Code != http.StatusUnprocessableEntity {
		t.Errorf("empty name status = %d", resp.Code)
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

	// renaming onto a taken name is rejected
	resp = api.Put("/settings/profiles/"+created.ID, append(authHeaders(token), map[string]string{"name": "default"})...)
	if resp.Code != http.StatusBadRequest {
		t.Errorf("rename collision status = %d", resp.Code)
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

	resp := api.Get("/settings/profiles", authHeaders(token)...)
	profiles := decode[SettingsProfilesBody](t, resp)
	profileID := profiles.List[0].ID

	// set a bool override
	resp = api.Put("/settings/profiles/"+profileID+"/values/ui.titlebar.startMaximized",
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
	if len(values.Values) != 1 || values.Values["ui.titlebar.startMaximized"].Value != "false" {
		t.Fatalf("values = %+v", values.Values)
	}

	// update overwrites
	resp = api.Put("/settings/profiles/"+profileID+"/values/ui.titlebar.startMaximized",
		append(authHeaders(token), map[string]any{"value": "true"})...)
	if resp.Code != http.StatusOK {
		t.Fatalf("re-put bool status = %d", resp.Code)
	}
	resp = api.Get("/settings/profiles/"+profileID+"/values", authHeaders(token)...)
	if n := len(decode[SettingValuesBody](t, resp).Values); n != 1 {
		t.Errorf("expected 1 override, got %d", n)
	}

	// invalid value for the kind is rejected
	resp = api.Put("/settings/profiles/"+profileID+"/values/ui.titlebar.startMaximized",
		append(authHeaders(token), map[string]any{"value": "\"nope\""})...)
	if resp.Code != http.StatusBadRequest {
		t.Errorf("invalid bool status = %d", resp.Code)
	}

	// out-of-bounds int is rejected
	resp = api.Put("/settings/profiles/"+profileID+"/values/ui.library.cardsPerRow",
		append(authHeaders(token), map[string]any{"value": "999999"})...)
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
