package settings

// A boolean setting's properties.
type BoolProps struct {
	// Default setting value.
	Default bool `json:"defaultValue"`
}

// Creates a bool setting definition with [def] as the default.
func Bool(id string, def bool) BoolSetting {
	return BoolSetting{SettingsDefinition: SettingsDefinition{
		ID:   id,
		Kind: KindBool,
		Bool: &BoolProps{Default: def},
	}}
}

type BoolSetting struct{ SettingsDefinition }

// See [SettingsDefinition.Order]
func (s BoolSetting) Order(v int) BoolSetting { s.SettingsDefinition.Order = v; return s }
