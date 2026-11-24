package settings

import (
	"crypto/aes"
	"crypto/cipher"
	"crypto/rand"
	"database/sql/driver"
	"encoding/base64"
	"encoding/hex"
	"errors"
	"fmt"
	"io"
	"strings"

	"forge.xela.codes/xela/flixur/common"
	"github.com/rs/zerolog/log"
)

// Prefix identifying an encrypted setting value.
// Can be rotated in the future.
const encryptedPrefix = "$enc__v1:"

// Length in bytes of the settings encryption key.
const settingsKeyLength = 32

// Returned when no settings key is configured.
var ErrNoSettingsKey = errors.New("no settings key configured (FLIXUR_SETTINGS_KEY)")

// A stored setting value in the database. [SettingText.Secret] determines whether to encrypt at rest.
type SettingText struct {
	// The plaintext JSON-encoded value.
	Raw string
	// Whether this value is encrypted.
	Secret bool
}

func (t SettingText) Value() (driver.Value, error) {
	if !t.Secret {
		return t.Raw, nil
	}
	return EncryptSecret(t.Raw)
}

func (t *SettingText) Scan(src any) error {
	switch value := src.(type) {
	case nil:
		t.Raw, t.Secret = "", false
	case string:
		return t.setText(value)
	case []byte:
		return t.setText(string(value))
	default:
		return fmt.Errorf("unsupported setting value type: %T", src)
	}
	return nil
}

func (t *SettingText) setText(text string) error {
	if !strings.HasPrefix(text, encryptedPrefix) {
		t.Raw, t.Secret = text, false
		return nil
	}
	raw, err := DecryptSecret(text)
	if err != nil {
		return err
	}
	t.Raw, t.Secret = raw, true
	return nil
}

// Encrypts plaintext with the configured key for storage.
// Degrades to plaintext when no key is set.
func EncryptSecret(plain string) (string, error) {
	gcm, err := secretCipher()
	if err != nil {
		// no key configured, store plaintext
		if errors.Is(err, ErrNoSettingsKey) {
			return plain, nil
		}
		return "", err
	}
	nonce := make([]byte, gcm.NonceSize())
	if _, err := io.ReadFull(rand.Reader, nonce); err != nil {
		return "", fmt.Errorf("generating nonce: %w", err)
	}
	sealed := gcm.Seal(nil, nonce, []byte(plain), nil)
	return encryptedPrefix + base64.StdEncoding.EncodeToString(append(nonce, sealed...)), nil
}

// Decrypts text produced by [EncryptSecret].
func DecryptSecret(text string) (string, error) {
	gcm, err := secretCipher()
	if err != nil {
		log.Err(err).Msg("Failed to decrypt secret setting value, the settings key is missing or incorrect.")
		return "", err
	}
	raw, err := base64.StdEncoding.DecodeString(strings.TrimPrefix(text, encryptedPrefix))
	if err != nil {
		log.Err(err).Msg("Failed to decode secret setting value, the settings key is missing or incorrect.")
		return "", fmt.Errorf("decoding secret: %w", err)
	}
	nonceSize := gcm.NonceSize()
	if len(raw) < nonceSize {
		err := errors.New("secret is too short")
		log.Err(err).Msg("Failed to decrypt secret setting value, the settings key is missing or incorrect.")
		return "", err
	}
	plain, err := gcm.Open(nil, raw[:nonceSize], raw[nonceSize:], nil)
	if err != nil {
		log.Err(err).Msg("Failed to decrypt secret setting value, the settings key is missing or incorrect.")
		return "", fmt.Errorf("opening secret: %w", err)
	}
	return string(plain), nil
}

// Creates the cipher from the configured settings key.
func secretCipher() (cipher.AEAD, error) {
	key, err := settingsKey()
	if err != nil {
		return nil, err
	}
	block, err := aes.NewCipher(key)
	if err != nil {
		return nil, err
	}
	return cipher.NewGCM(block)
}

// Loads and validates the settings encryption key from the config.
func settingsKey() ([]byte, error) {
	encoded := common.Config.SettingsKey
	if encoded == "" {
		return nil, ErrNoSettingsKey
	}
	key, err := hex.DecodeString(encoded)
	if err != nil {
		return nil, fmt.Errorf("invalid settings key: %w", err)
	}
	if len(key) != settingsKeyLength {
		return nil, fmt.Errorf("settings key must be %d bytes (%d hex characters)", settingsKeyLength, settingsKeyLength*2)
	}
	return key, nil
}

// Checks the settings key configuration. Meant to be run on startup.
func CheckSecretKey() error {
	_, err := settingsKey()
	if errors.Is(err, ErrNoSettingsKey) {
		log.Warn().Msg("No settings key configured! Secret setting values will be stored as plaintext. It is recommended to configure one with FLIXUR_SETTINGS_KEY.")
		return nil
	}
	return err
}
