package api

import (
	"context"
	"encoding/json"
	"net/http"
	"net/http/httptest"
	"testing"

	"forge.xela.codes/xela/flixur/common"
	"forge.xela.codes/xela/flixur/ent/enttest"
	"github.com/danielgtaylor/huma/v2/humatest"

	_ "github.com/mattn/go-sqlite3"
)

func setupAuthTest(t *testing.T) humatest.TestAPI {
	t.Helper()
	_, api := newTestAPI(t)
	return api
}

var platformHeaders = []any{
	"X-Platform-Client: test/1.0",
	"X-Platform-Device: testdevice",
	"X-Platform-OS: testos/1",
}

func setupBody(code, username, password string) map[string]string {
	return map[string]string{
		"code":     code,
		"username": username,
		"password": password,
	}
}

func decode[T any](t *testing.T, resp *httptest.ResponseRecorder) T {
	t.Helper()
	var v T
	if err := json.NewDecoder(resp.Body).Decode(&v); err != nil {
		t.Fatal(err)
	}
	return v
}

func TestPing(t *testing.T) {
	SetServerSetupCode(nil)
	api := setupAuthTest(t)

	resp := api.Get("/ping")
	if resp.Code != http.StatusOK {
		t.Fatalf("status = %d", resp.Code)
	}
	body := decode[PingOutputBody](t, resp)

	if body.Version != "0.0.0" {
		t.Errorf("Version = %q", body.Version)
	}
	if body.ProtocolVersion != common.Version {
		t.Errorf("ProtocolVersion = %d", body.ProtocolVersion)
	}
	if !body.IsSetup {
		t.Error("IsSetup should be true when setup code is nil")
	}
	if !body.SupportsPasswordLogin {
		t.Error("SupportsPasswordLogin should be true")
	}
	if body.SupportsOIDCLogin != "Pocket ID" {
		t.Errorf("SupportsOIDCLogin = %q", body.SupportsOIDCLogin)
	}
}

func TestPingNotSetup(t *testing.T) {
	code := "SETUP1"
	SetServerSetupCode(&code)
	t.Cleanup(func() { SetServerSetupCode(nil) })

	api := setupAuthTest(t)
	resp := api.Get("/ping")
	if resp.Code != http.StatusOK {
		t.Fatalf("status = %d", resp.Code)
	}
	body := decode[struct {
		IsSetup bool `json:"isSetup"`
	}](t, resp)
	if body.IsSetup {
		t.Error("IsSetup should be false when setup code is set")
	}
}

func TestSetupSuccess(t *testing.T) {
	api := setupAuthTest(t)
	code := "SETUP1"
	SetServerSetupCode(&code)
	t.Cleanup(func() { SetServerSetupCode(nil) })

	body := setupBody(code, "admin", "password1234")
	resp := api.Post("/auth/setup", append(platformHeaders, body)...)
	if resp.Code != http.StatusOK {
		var errBody APIError
		_ = json.NewDecoder(resp.Body).Decode(&errBody)
		t.Fatalf("status = %d, err = %+v", resp.Code, errBody)
	}

	out := decode[struct {
		SessionToken string `json:"sessionToken"`
	}](t, resp)
	if out.SessionToken == "" {
		t.Fatal("expected session token")
	}

	// second setup should fail
	resp2 := api.Post("/auth/setup", append(platformHeaders, body)...)
	if resp2.Code != http.StatusInternalServerError {
		t.Errorf("second setup status = %d", resp2.Code)
	}
}

func TestSetupWrongCode(t *testing.T) {
	api := setupAuthTest(t)
	code := "SETUP1"
	SetServerSetupCode(&code)
	t.Cleanup(func() { SetServerSetupCode(nil) })

	body := setupBody("WRONG1", "admin", "password1234")
	resp := api.Post("/auth/setup", append(platformHeaders, body)...)
	if resp.Code != http.StatusUnauthorized {
		t.Fatalf("status = %d", resp.Code)
	}
}

func TestSetupValidation(t *testing.T) {
	api := setupAuthTest(t)
	code := "SETUP1"
	SetServerSetupCode(&code)
	t.Cleanup(func() { SetServerSetupCode(nil) })

	cases := []struct {
		name     string
		username string
		password string
		wantCode int
	}{
		{"username too short", "a", "password1234", http.StatusBadRequest},
		{"username too long", string(make([]byte, 65)), "password1234", http.StatusBadRequest},
		{"username invalid", "usér", "password1234", http.StatusBadRequest},
		{"password too short", "admin", "short", http.StatusBadRequest},
		{"password too long", "admin", string(make([]byte, 73)), http.StatusBadRequest},
	}

	for _, tc := range cases {
		t.Run(tc.name, func(t *testing.T) {
			body := setupBody(code, tc.username, tc.password)
			resp := api.Post("/auth/setup", append(platformHeaders, body)...)
			if resp.Code != tc.wantCode {
				t.Errorf("status = %d, want %d", resp.Code, tc.wantCode)
			}
		})
	}
}

func TestOIDCInit(t *testing.T) {
	api := setupAuthTest(t)
	resp := api.Get("/auth/oidc")
	if resp.Code != http.StatusOK {
		t.Fatalf("status = %d", resp.Code)
	}
	body := decode[struct {
		LoginURL string `json:"loginURL"`
	}](t, resp)
	if body.LoginURL != "" {
		t.Errorf("LoginURL = %q, want empty", body.LoginURL)
	}
}

func TestCreateUserSessionToken(t *testing.T) {
	resetConfig(t)
	common.Config.TrustProxy = false
	client := enttest.Open(t, "sqlite3", common.TestDSN(t))
	defer client.Close()

	ctx := context.Background()
	user, err := client.User.Create().SetUsername("tester").SetPassword("password1234").Save(ctx)
	if err != nil {
		t.Fatal(err)
	}

	ctx = context.WithValue(ctx, ctxKeyClientIP{}, "192.168.1.1")
	headers := PlatformHeadersMixin{
		PlatformClient: "client",
		PlatformDevice: "device",
		PlatformOS:     "os",
	}
	token, err := CreateUserSessionToken(ctx, client, user, headers)
	if err != nil {
		t.Fatal(err)
	}
	if token == "" {
		t.Fatal("expected token")
	}

	sessions, err := client.UserSession.Query().All(ctx)
	if err != nil {
		t.Fatal(err)
	}
	if len(sessions) != 1 {
		t.Fatalf("expected 1 session, got %d", len(sessions))
	}
	if sessions[0].Token != common.SHA256Hex(token) {
		t.Error("session token hash mismatch")
	}
	if sessions[0].Platform != "client on device running os" {
		t.Errorf("platform = %q", sessions[0].Platform)
	}
}

func TestSetupStateLifecycle(t *testing.T) {
	client := enttest.Open(t, "sqlite3", common.TestDSN(t))
	defer client.Close()
	ctx := context.Background()

	// no users: setup code is generated
	SetServerSetupCode(nil)
	if err := LoadServerSetupState(ctx, client); err != nil {
		t.Fatal(err)
	}
	if GetServerSetupCode() == nil {
		t.Fatal("expected setup code to be generated")
	}
	if len(*GetServerSetupCode()) != 6 {
		t.Errorf("setup code length = %d", len(*GetServerSetupCode()))
	}

	// after creating a user: setup code is nil
	if _, err := client.User.Create().SetUsername("admin").SetPassword("password1234").Save(ctx); err != nil {
		t.Fatal(err)
	}
	if err := LoadServerSetupState(ctx, client); err != nil {
		t.Fatal(err)
	}
	if GetServerSetupCode() != nil {
		t.Error("expected setup code to be nil after user exists")
	}
}
