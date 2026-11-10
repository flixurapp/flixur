package settings

// An enum setting's properties.
type EnumProps struct {
	// Default setting value.
	Default string `json:"defaultValue"`
	// Available choices as [ChoiceSpec]s.
	Choices []ChoiceSpec `json:"choices"`
}

// Creates an enum setting definition with [def] as the default.
func Enum(id string, def string) EnumSetting {
	return EnumSetting{SettingsDefinition: SettingsDefinition{
		ID:   id,
		Kind: KindEnum,
		Enum: &EnumProps{Default: def},
	}}
}

type EnumSetting struct{ SettingsDefinition }

// See [SettingsDefinition.Order]
func (s EnumSetting) Order(v int) EnumSetting { s.SettingsDefinition.Order = v; return s }

// Adds a new choice with [value] and optional Iconify icon name. See [EnumProps.Choices]
func (s EnumSetting) AddChoice(value string, icon ...string) EnumSetting {
	s.Enum.Choices = append(s.Enum.Choices, newChoice(value, icon...))
	return s
}
