package settings

// A string setting's properties.
type StringProps struct {
	// Default setting value.
	Default string `json:"default,omitempty"`
	// Maximum character length.
	MaxLength *int `json:"maxLength,omitempty"`
	// Whether this setting value is considered secret. Used for API keys.
	Secret *bool `json:"secret,omitempty"`
}

// Creates a string setting definition with [def] as the default.
func String(id string, def string) StringSetting {
	return StringSetting{SettingsDefinition: SettingsDefinition{
		ID:     id,
		Kind:   KindString,
		String: &StringProps{Default: def},
	}}
}

type StringSetting struct{ SettingsDefinition }

// See [SettingsDefinition.Order]
func (s StringSetting) Order(v int) StringSetting { s.SettingsDefinition.Order = v; return s }

// See [StringProps.MaxLength]
func (s StringSetting) MaxLength(v int) StringSetting { s.String.MaxLength = new(v); return s }

// See [StringProps.Secret]
func (s StringSetting) Secret(v bool) StringSetting { s.String.Secret = new(v); return s }
