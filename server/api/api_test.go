package api

import (
	"context"
	"encoding/json"
	"net"
	"net/http"
	"net/http/httptest"
	"testing"

	"forge.xela.codes/xela/flixur/common"
	"github.com/cardinalby/hureg"
	"github.com/danielgtaylor/huma/v2/humatest"
	"github.com/go-chi/chi/v5"
)

func stringsToAny(ss []string) []any {
	out := make([]any, len(ss))
	for i, s := range ss {
		out[i] = s
	}
	return out
}

func getIP(t *testing.T, api humatest.TestAPI, headers ...string) string {
	t.Helper()
	resp := api.Get("/ip-test", stringsToAny(headers)...)
	if resp.Code != http.StatusOK {
		t.Fatalf("status = %d", resp.Code)
	}
	var body struct {
		IP string `json:"ip"`
	}
	if err := json.NewDecoder(resp.Body).Decode(&body); err != nil {
		t.Fatal(err)
	}
	return body.IP
}

func addIPTestRoute(t *testing.T, api hureg.API) {
	t.Helper()
	hureg.Get(api, "/ip-test", func(ctx context.Context, _ *struct{}) (*struct {
		Body struct {
			IP string `json:"ip"`
		}
	}, error) {
		resp := &struct {
			Body struct {
				IP string `json:"ip"`
			}
		}{}
		resp.Body.IP = GetClientIP(ctx)
		return resp, nil
	})
}

func TestIPMiddlewareDirect(t *testing.T) {
	resetConfig(t)
	common.Config.TrustProxy = false

	_, reg, api := newTestAPI(t)
	addIPTestRoute(t, reg.API)

	if ip := getIP(t, api); ip != "127.0.0.1" {
		t.Errorf("ip = %q, want 127.0.0.1", ip)
	}
}

func TestIPMiddlewareTrustedProxy(t *testing.T) {
	resetConfig(t)
	common.Config.TrustProxy = true
	_, cidr, _ := net.ParseCIDR("127.0.0.0/8")
	common.Config.TrustedProxyCIDRs = []*net.IPNet{cidr}
	common.Config.TrustProxyHeader = "X-Forwarded-For"

	_, reg, api := newTestAPI(t)
	addIPTestRoute(t, reg.API)

	ip := getIP(t, api, "X-Forwarded-For: 1.2.3.4, 5.6.7.8")
	if ip != "1.2.3.4" {
		t.Errorf("ip = %q, want 1.2.3.4", ip)
	}
}

func TestIPMiddlewareUntrustedProxy(t *testing.T) {
	resetConfig(t)
	common.Config.TrustProxy = true
	_, cidr, _ := net.ParseCIDR("10.0.0.0/8")
	common.Config.TrustedProxyCIDRs = []*net.IPNet{cidr}
	common.Config.TrustProxyHeader = "X-Forwarded-For"

	_, reg, api := newTestAPI(t)
	addIPTestRoute(t, reg.API)

	ip := getIP(t, api, "X-Forwarded-For: 1.2.3.4")
	if ip != "127.0.0.1" {
		t.Errorf("ip = %q, want 127.0.0.1", ip)
	}
}

func TestIPMiddlewareBadHeader(t *testing.T) {
	resetConfig(t)
	common.Config.TrustProxy = true
	common.Config.TrustedProxyCIDRs = nil
	common.Config.TrustProxyHeader = "X-Forwarded-For"

	_, reg, api := newTestAPI(t)
	addIPTestRoute(t, reg.API)

	ip := getIP(t, api, "X-Forwarded-For: not-an-ip")
	if ip != "127.0.0.1" {
		t.Errorf("ip = %q, want 127.0.0.1", ip)
	}
}

func TestIPMiddlewareInvalidRemoteAddr(t *testing.T) {
	resetConfig(t)
	common.Config.TrustProxy = false

	client := newTestClient(t)
	router := chi.NewMux()
	reg := RegisterAPI(router, client)

	addIPTestRoute(t, reg.API)

	req := httptest.NewRequest(http.MethodGet, "/api/ip-test", nil)
	req.RemoteAddr = "not-addr"
	rr := httptest.NewRecorder()
	router.ServeHTTP(rr, req)

	if rr.Code != http.StatusOK {
		t.Fatalf("status = %d", rr.Code)
	}

	var body struct {
		IP string `json:"ip"`
	}
	if err := json.NewDecoder(rr.Body).Decode(&body); err != nil {
		t.Fatal(err)
	}
	if body.IP != "not-addr" {
		t.Errorf("ip = %q, want not-addr", body.IP)
	}
}

func TestIsTrustedProxy(t *testing.T) {
	resetConfig(t)

	// empty CIDR list trusts all
	common.Config.TrustedProxyCIDRs = nil
	if !isTrustedProxy("127.0.0.1") {
		t.Error("expected all proxies trusted when CIDR list empty")
	}

	_, cidr, _ := net.ParseCIDR("127.0.0.0/8")
	common.Config.TrustedProxyCIDRs = []*net.IPNet{cidr}

	if !isTrustedProxy("127.0.0.1") {
		t.Error("expected 127.0.0.1 trusted")
	}
	if isTrustedProxy("1.2.3.4") {
		t.Error("expected 1.2.3.4 untrusted")
	}
	if isTrustedProxy("not-an-ip") {
		t.Error("expected non-IP untrusted")
	}
}

func TestCORSHeaders(t *testing.T) {
	_, _, api := newTestAPI(t)

	resp := api.Do(http.MethodOptions, "/ping",
		"Origin: http://example.com",
		"Access-Control-Request-Method: POST",
	)

	if resp.Code != http.StatusOK && resp.Code != http.StatusNoContent {
		t.Fatalf("status = %d", resp.Code)
	}
	if got := resp.Header().Get("Access-Control-Allow-Origin"); got != "http://example.com" {
		t.Errorf("Access-Control-Allow-Origin = %q", got)
	}
}

func TestNoSetupMiddleware(t *testing.T) {
	code := "ABC123"
	SetServerSetupCode(&code)
	t.Cleanup(func() { SetServerSetupCode(nil) })

	_, reg, api := newTestAPI(t)

	// add a route without NoSetup (requires setup)
	hureg.Get(WithOptions(reg.API, reg, APIRoute{
		NoSetup: false,
	}), "/requires-setup", func(ctx context.Context, _ *struct{}) (*Output[string], error) {
		return CreateOutput("ok"), nil
	})

	// route without NoSetup should return unauthorized when setup code exists
	resp := api.Get("/requires-setup")
	if resp.Code != http.StatusUnauthorized {
		t.Errorf("no-NoSetup route: status = %d, want %d", resp.Code, http.StatusUnauthorized)
	}

	// body should be an APIError, not huma's ErrorModel
	body := decode[APIError](t, resp)
	if body.Code != CodeServerNotSetup {
		t.Errorf("no-NoSetup route: code = %q, want %q", body.Code, CodeServerNotSetup)
	}
	if body.Detail != nil {
		t.Errorf("no-NoSetup route: detail = %v, want nil", body.Detail)
	}

	// /ping has NoSetup: true so it should still work
	resp = api.Get("/ping")
	if resp.Code != http.StatusOK {
		t.Errorf("NoSetup route: status = %d, want %d", resp.Code, http.StatusOK)
	}
}

func addAuthTestRoute(t *testing.T, reg APIRegistry, path string) {
	t.Helper()
	hureg.Get(WithOptions(reg.API, reg, APIRoute{}), path, func(ctx context.Context, _ *struct{}) (*Output[string], error) {
		return CreateOutput("ok"), nil
	})
}

func TestAuthMiddlewareInvalidToken(t *testing.T) {
	SetServerSetupCode(nil)
	_, reg, api := newTestAPI(t)
	addAuthTestRoute(t, reg, "/requires-auth")

	// missing authorization header
	resp := api.Get("/requires-auth")
	if resp.Code != http.StatusUnauthorized {
		t.Fatalf("no header: status = %d, want %d", resp.Code, http.StatusUnauthorized)
	}
	body := decode[APIError](t, resp)
	if body.Code != CodeInvalidToken {
		t.Errorf("no header: code = %q, want %q", body.Code, CodeInvalidToken)
	}

	// token that doesn't match any session
	resp = api.Get("/requires-auth", "Authorization: Bearer garbage")
	if resp.Code != http.StatusUnauthorized {
		t.Fatalf("bad token: status = %d, want %d", resp.Code, http.StatusUnauthorized)
	}
	body = decode[APIError](t, resp)
	if body.Code != CodeInvalidToken {
		t.Errorf("bad token: code = %q, want %q", body.Code, CodeInvalidToken)
	}
	if body.Detail != nil {
		t.Errorf("bad token: detail = %v, want nil", body.Detail)
	}
}

func TestAuthMiddlewareDBErrorMapsToInvalidToken(t *testing.T) {
	SetServerSetupCode(nil)
	client, reg, api := newTestAPI(t)
	addAuthTestRoute(t, reg, "/requires-auth-db")

	// a closed database causes the session lookup to fail
	// the middleware should still answer with the INVALID_TOKEN code instead of a raw error
	if err := client.Close(); err != nil {
		t.Fatal(err)
	}

	resp := api.Get("/requires-auth-db", "Authorization: Bearer sometoken")
	if resp.Code != http.StatusUnauthorized {
		t.Fatalf("status = %d, want %d", resp.Code, http.StatusUnauthorized)
	}
	body := decode[APIError](t, resp)
	if body.Code != CodeInvalidToken {
		t.Errorf("code = %q, want %q", body.Code, CodeInvalidToken)
	}
}

func TestHumaValidationErrorsKeepErrorModel(t *testing.T) {
	SetServerSetupCode(nil)
	_, reg, api := newTestAPI(t)

	hureg.Post(WithOptions(reg.API, reg, APIRoute{NoSetup: true, NoAuth: true}), "/val-test",
		func(ctx context.Context, input *struct {
			Body struct {
				Name string `json:"name" minLength:"3"`
			}
		}) (*Output[string], error) {
			return CreateOutput(input.Body.Name), nil
		})

	resp := api.Post("/val-test", map[string]any{"name": "x"})
	if resp.Code != http.StatusUnprocessableEntity {
		t.Fatalf("status = %d, want %d", resp.Code, http.StatusUnprocessableEntity)
	}

	// huma-internal validation errors must keep the default ErrorModel shape
	// the NewErrorWithContext hook must not hijack them into APIErrors
	body := decode[struct {
		Title  string `json:"title"`
		Detail string `json:"detail"`
		Code   string `json:"code"`
	}](t, resp)
	if body.Title == "" {
		t.Error("expected ErrorModel shape (title), got something else")
	}
	if body.Code != "" {
		t.Errorf("code = %q, want empty (hook must not hijack validation errors)", body.Code)
	}
}
