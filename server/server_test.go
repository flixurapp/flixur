package main

import (
	"net/http"
	"net/http/httptest"
	"os"
	"path/filepath"
	"syscall"
	"testing"
	"time"

	"forge.xela.codes/xela/flixur/common"
	"forge.xela.codes/xela/flixur/ent/enttest"
	"github.com/go-chi/chi/v5"

	_ "github.com/mattn/go-sqlite3"
)

func resetGlobals(t *testing.T) {
	t.Helper()
	oldConfig := common.Config
	oldExit := exitFunc
	oldServe := serveFunc
	t.Cleanup(func() {
		common.Config = oldConfig
		exitFunc = oldExit
		serveFunc = oldServe
	})
}

func TestOpenDatabase(t *testing.T) {
	client, err := openDatabase()
	if err != nil {
		t.Fatalf("openDatabase() error = %v", err)
	}
	defer client.Close()
}

func TestBuildRouter(t *testing.T) {
	client := enttest.Open(t, "sqlite3", common.TestDSN(t))
	defer client.Close()

	router := buildRouter(client)
	if router == nil {
		t.Fatal("expected router")
	}

	// make sure api responds to requests
	req := httptest.NewRequest(http.MethodGet, "/api/ping", nil)
	rec := httptest.NewRecorder()
	router.ServeHTTP(rec, req)
	if rec.Code != http.StatusOK {
		t.Errorf("status = %d", rec.Code)
	}
}

func TestServeFrontend(t *testing.T) {
	dir := t.TempDir()
	if err := os.WriteFile(filepath.Join(dir, "index.html"), []byte("<html></html>"), 0644); err != nil {
		t.Fatal(err)
	}
	if err := os.WriteFile(filepath.Join(dir, "asset.txt"), []byte("asset"), 0644); err != nil {
		t.Fatal(err)
	}

	router := chi.NewMux()
	cleanup := serveFrontend(router, dir)
	defer cleanup()

	cases := []struct {
		path     string
		expected string
	}{
		{"/", "<html></html>"},
		{"/asset.txt", "asset"},
		{"/some/spa/route", "<html></html>"},
	}

	for _, tc := range cases {
		req := httptest.NewRequest(http.MethodGet, tc.path, nil)
		rec := httptest.NewRecorder()
		router.ServeHTTP(rec, req)
		if rec.Code != http.StatusOK {
			t.Errorf("%s status = %d, body = %q", tc.path, rec.Code, rec.Body.String())
			continue
		}
		if rec.Body.String() != tc.expected {
			t.Errorf("%s body = %q, want %q", tc.path, rec.Body.String(), tc.expected)
		}
	}
}

func TestServeFrontendBadDir(t *testing.T) {
	router := chi.NewMux()
	cleanup := serveFrontend(router, "/definitely/does/not/exist")
	cleanup()
}

func TestServeSignalShutdown(t *testing.T) {
	resetGlobals(t)
	common.Config.Address = "127.0.0.1"
	common.Config.Port = 0

	router := chi.NewMux()
	sigs := make(chan os.Signal, 1)
	ready := make(chan struct{})

	errCh := make(chan error, 1)
	go func() {
		errCh <- serve(router, sigs, ready)
	}()

	<-ready
	sigs <- syscall.SIGTERM

	select {
	case err := <-errCh:
		if err != nil {
			t.Fatalf("serve() error = %v", err)
		}
	case <-time.After(5 * time.Second):
		t.Fatal("serve did not shut down")
	}
}

func TestServeListenError(t *testing.T) {
	resetGlobals(t)
	common.Config.Address = "not-a-valid-address"
	common.Config.Port = 999999

	router := chi.NewMux()
	err := serve(router, nil, nil)
	if err == nil {
		t.Fatal("expected serve to return error for invalid address")
	}
}

func TestRunServer(t *testing.T) {
	resetGlobals(t)
	t.Setenv("FLIXUR_DEVELOPMENT_RUN_AS_GENERATOR", "true")
	serveCalled := false
	serveFunc = func(chi.Router, <-chan os.Signal, chan<- struct{}) error {
		serveCalled = true
		return nil
	}

	if err := runServer(); err != nil {
		t.Fatalf("runServer() error = %v", err)
	}
	if !serveCalled {
		t.Error("expected serveFunc to be called")
	}
}

func TestRunServerConfigError(t *testing.T) {
	resetGlobals(t)
	t.Setenv("FLIXUR_LOG_LEVEL", "notalevel")
	if err := runServer(); err == nil {
		t.Fatal("expected runServer to return error")
	}
}

func TestRunServerWithFrontendAndPlugins(t *testing.T) {
	resetGlobals(t)
	t.Setenv("FLIXUR_DEVELOPMENT_MODE", "true")
	t.Setenv("FLIXUR_DEVELOPMENT_RUN_AS_GENERATOR", "false")

	pluginDir := t.TempDir()
	frontendDir := t.TempDir()
	if err := os.WriteFile(filepath.Join(frontendDir, "index.html"), []byte("hi"), 0644); err != nil {
		t.Fatal(err)
	}

	t.Setenv("FLIXUR_PLUGIN_DIR", pluginDir)
	t.Setenv("FLIXUR_FRONTEND_DIR", frontendDir)

	serveCalled := false
	serveFunc = func(chi.Router, <-chan os.Signal, chan<- struct{}) error {
		serveCalled = true
		return nil
	}

	if err := runServer(); err != nil {
		t.Fatalf("runServer() error = %v", err)
	}
	if !serveCalled {
		t.Error("expected serveFunc to be called")
	}
}

func TestMainFunc(t *testing.T) {
	resetGlobals(t)
	t.Setenv("FLIXUR_DEVELOPMENT_RUN_AS_GENERATOR", "true")

	exitCode := -1
	exitFunc = func(code int) { exitCode = code }
	serveFunc = func(chi.Router, <-chan os.Signal, chan<- struct{}) error {
		return nil
	}

	main()
	if exitCode != -1 {
		t.Errorf("exit code = %d", exitCode)
	}
}

func TestMainFuncError(t *testing.T) {
	resetGlobals(t)
	t.Setenv("FLIXUR_DEVELOPMENT_RUN_AS_GENERATOR", "true")

	exitCode := -1
	exitFunc = func(code int) { exitCode = code }
	serveFunc = func(chi.Router, <-chan os.Signal, chan<- struct{}) error {
		return os.ErrInvalid
	}

	main()
	if exitCode != 1 {
		t.Errorf("exit code = %d, want 1", exitCode)
	}
}
