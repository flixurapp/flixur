package settings

import (
	"strings"
	"testing"

	"forge.xela.codes/xela/flixur/common"
	plugsettings "forge.xela.codes/xela/flixur/pluginkit/settings"
)

// Swaps the settings key config for the duration of the test.
func setKey(t *testing.T, key string) {
	t.Helper()
	old := common.Config.SettingsKey
	common.Config.SettingsKey = key
	t.Cleanup(func() { common.Config.SettingsKey = old })
}

// Encrypts plaintext with a valid key, failing the test on errors.
func mustSeal(t *testing.T, plain string) string {
	t.Helper()
	setKey(t, strings.Repeat("ab", 32))
	sealed, err := EncryptSecret(plain)
	if err != nil {
		t.Fatal(err)
	}
	return sealed
}

func TestSecretRoundTrip(t *testing.T) {
	setKey(t, strings.Repeat("ab", 32))

	sealed, err := EncryptSecret(`"hello"`)
	if err != nil {
		t.Fatal(err)
	}
	if !strings.HasPrefix(sealed, encryptedPrefix) || strings.Contains(sealed, "hello") {
		t.Errorf("encrypted form = %q", sealed)
	}
	plain, err := DecryptSecret(sealed)
	if err != nil || plain != `"hello"` {
		t.Errorf("decrypt = %q, %v", plain, err)
	}
}

// Without a configured key, secret values degrade to plaintext storage.
func TestSecretNoKeyPassthrough(t *testing.T) {
	setKey(t, "")

	sealed, err := EncryptSecret(`"hello"`)
	if err != nil {
		t.Fatal(err)
	}
	if sealed != `"hello"` {
		t.Errorf("without a key, encrypt should pass the plaintext through, got %q", sealed)
	}
}

// Reading encrypted values without (or with an incorrect) key errors instead of
// handing out ciphertext.
func TestSecretDecryptErrors(t *testing.T) {
	sealed := mustSeal(t, `"hello"`)

	t.Run("no key", func(t *testing.T) {
		setKey(t, "")
		if _, err := DecryptSecret(sealed); err == nil {
			t.Error("expected an error decrypting without a key")
		}
	})
	t.Run("incorrect key", func(t *testing.T) {
		setKey(t, strings.Repeat("cd", 32))
		if _, err := DecryptSecret(sealed); err == nil {
			t.Error("expected an error decrypting with the incorrect key")
		}
	})
}

func TestCheckSecretKey(t *testing.T) {
	// no secret settings registered: anything is fine
	setKey(t, "")
	if err := CheckSecretKey(); err != nil {
		t.Errorf("no secret settings, err = %v", err)
	}

	// register a secret setting
	ServerRegistry.RegisterGroup(plugsettings.Group("test"))
	ServerRegistry.Register(plugsettings.String("test.secretCheck", "").Secret(true).Order(1))

	// a missing key degrades to plaintext with a warning
	setKey(t, "")
	if err := CheckSecretKey(); err != nil {
		t.Errorf("missing key, err = %v", err)
	}

	// an invalid configured key still fails at startup
	setKey(t, "zz")
	if err := CheckSecretKey(); err == nil {
		t.Error("invalid key was not rejected")
	}
	setKey(t, strings.Repeat("ab", 32))
	if err := CheckSecretKey(); err != nil {
		t.Errorf("valid key, err = %v", err)
	}
}
