package settings

// A stringlist setting's properties.
type StringListProps struct {
	// Default setting value.
	Default []string `json:"default"`
	// Choices offered to clients for adding items.
	Choices []ChoiceSpec `json:"choices"`
	// Maximum total selected items.
	MaxItems *int `json:"maxItems,omitempty"`
}

// Creates a stringlist setting definition with [def] as the default.
func StringList(id string, def []string) StringListSetting {
	return StringListSetting{SettingsDefinition: SettingsDefinition{
		ID:         id,
		Kind:       KindStringList,
		StringList: &StringListProps{Default: def},
	}}
}

type StringListSetting struct{ SettingsDefinition }

// See [SettingsDefinition.Order]
func (s StringListSetting) Order(v int) StringListSetting { s.SettingsDefinition.Order = v; return s }

// Adds a new choice with [value] and optional Iconify icon name. See [StringListProps.Choices]
func (s StringListSetting) AddChoice(value string, icon ...string) StringListSetting {
	s.StringList.Choices = append(s.StringList.Choices, newChoice(value, icon...))
	return s
}

// See [StringListProps.maxItems]
func (s StringListSetting) MaxItems(v int) StringListSetting {
	s.StringList.MaxItems = new(v)
	return s
}
