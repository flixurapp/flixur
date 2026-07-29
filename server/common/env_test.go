package common

import (
	"net"
	"os"
	"strings"
	"testing"

	"github.com/rs/zerolog"
)

func resetConfig(t *testing.T) {
	t.Helper()
	old := Config
	oldLevel := zerolog.GlobalLevel()
	t.Cleanup(func() {
		Config = old
		zerolog.SetGlobalLevel(oldLevel)
	})
}

func setEnvs(t *testing.T, envs map[string]string) {
	t.Helper()
	var keys []string
	for k, v := range envs {
		keys = append(keys, k)
		old, had := os.LookupEnv(k)
		t.Cleanup(func() {
			if had {
				os.Setenv(k, old)
			} else {
				os.Unsetenv(k)
			}
		})
		os.Setenv(k, v)
	}
	t.Cleanup(func() {
		for _, k := range keys {
			os.Unsetenv(k)
		}
	})
}

func TestParseConfigDefaults(t *testing.T) {
	resetConfig(t)
	// ensure no relevant env vars leak from the environment
	for _, k := range os.Environ() {
		if strings.HasPrefix(k, "FLIXUR_") {
			key := strings.SplitN(k, "=", 2)[0]
			os.Unsetenv(key)
			t.Cleanup(func() { os.Setenv(key, strings.SplitN(k, "=", 2)[1]) })
		}
	}

	if err := ParseConfig(); err != nil {
		t.Fatalf("ParseConfig() error = %v", err)
	}

	if Config.Address != "0.0.0.0" {
		t.Errorf("Address = %q, want 0.0.0.0", Config.Address)
	}
	if Config.Port != 8787 {
		t.Errorf("Port = %d, want 8787", Config.Port)
	}
	if Config.LogLevel.Value != zerolog.TraceLevel {
		t.Errorf("LogLevel = %v, want Trace", Config.LogLevel.Value)
	}
	if Config.FrontendDir != "" {
		t.Errorf("FrontendDir = %q, want empty", Config.FrontendDir)
	}
	if Config.PluginDir != "./plugins" {
		t.Errorf("PluginDir = %q, want ./plugins", Config.PluginDir)
	}
	if Config.TrustProxy {
		t.Error("TrustProxy should be false by default")
	}
	if Config.TrustProxyHeader != "X-Forwarded-For" {
		t.Errorf("TrustProxyHeader = %q, want X-Forwarded-For", Config.TrustProxyHeader)
	}
	if len(Config.TrustedProxyCIDRs) != 0 {
		t.Errorf("TrustedProxyCIDRs = %v, want empty", Config.TrustedProxyCIDRs)
	}
	if Config.DevelopmentMode {
		t.Error("DevelopmentMode should be false by default")
	}
	if Config.GeneratorMode {
		t.Error("GeneratorMode should be false by default")
	}
}

func TestParseConfigOverrides(t *testing.T) {
	resetConfig(t)
	setEnvs(t, map[string]string{
		"FLIXUR_ADDRESS":                      "127.0.0.1",
		"FLIXUR_PORT":                         "9999",
		"FLIXUR_LOG_LEVEL":                    "info",
		"FLIXUR_FRONTEND_DIR":                 "/tmp/front",
		"FLIXUR_PLUGIN_DIR":                   "/tmp/plugs",
		"FLIXUR_TRUST_PROXY":                  "true",
		"FLIXUR_TRUST_PROXY_HEADER":           "X-Real-IP",
		"FLIXUR_TRUSTED_PROXY_CIDRS":          "10.0.0.0/8, 192.168.0.0/16",
		"FLIXUR_DEVELOPMENT_MODE":             "true",
		"FLIXUR_DEVELOPMENT_RUN_AS_GENERATOR": "true",
	})

	if err := ParseConfig(); err != nil {
		t.Fatalf("ParseConfig() error = %v", err)
	}

	if Config.Address != "127.0.0.1" {
		t.Errorf("Address = %q", Config.Address)
	}
	if Config.Port != 9999 {
		t.Errorf("Port = %d", Config.Port)
	}
	if Config.LogLevel.Value != zerolog.InfoLevel {
		t.Errorf("LogLevel = %v", Config.LogLevel.Value)
	}
	if Config.FrontendDir != "/tmp/front" {
		t.Errorf("FrontendDir = %q", Config.FrontendDir)
	}
	if Config.PluginDir != "/tmp/plugs" {
		t.Errorf("PluginDir = %q", Config.PluginDir)
	}
	if !Config.TrustProxy {
		t.Error("TrustProxy should be true")
	}
	if Config.TrustProxyHeader != "X-Real-IP" {
		t.Errorf("TrustProxyHeader = %q", Config.TrustProxyHeader)
	}
	if len(Config.TrustedProxyCIDRs) != 2 {
		t.Fatalf("TrustedProxyCIDRs len = %d", len(Config.TrustedProxyCIDRs))
	}
	_, ten, _ := net.ParseCIDR("10.0.0.0/8")
	if Config.TrustedProxyCIDRs[0].String() != ten.String() {
		t.Errorf("TrustedProxyCIDRs[0] = %s", Config.TrustedProxyCIDRs[0])
	}
	if !Config.DevelopmentMode {
		t.Error("DevelopmentMode should be true")
	}
	if !Config.GeneratorMode {
		t.Error("GeneratorMode should be true")
	}
}

func TestParseConfigInvalidLogLevel(t *testing.T) {
	resetConfig(t)
	setEnvs(t, map[string]string{"FLIXUR_LOG_LEVEL": "notalevel"})

	if err := ParseConfig(); err == nil {
		t.Fatal("ParseConfig() expected error for invalid log level")
	}
}

func TestParseConfigInvalidCIDR(t *testing.T) {
	resetConfig(t)
	setEnvs(t, map[string]string{"FLIXUR_TRUSTED_PROXY_CIDRS": "not-a-cidr"})

	if err := ParseConfig(); err == nil {
		t.Fatal("ParseConfig() expected error for invalid CIDR")
	}
}

func TestParseConfigEmptyCIDR(t *testing.T) {
	resetConfig(t)
	setEnvs(t, map[string]string{"FLIXUR_TRUSTED_PROXY_CIDRS": ""})

	if err := ParseConfig(); err != nil {
		t.Fatalf("ParseConfig() error = %v", err)
	}
	if len(Config.TrustedProxyCIDRs) != 0 {
		t.Errorf("TrustedProxyCIDRs = %v, want empty", Config.TrustedProxyCIDRs)
	}
}
