package settings

// An int setting's properties.
type IntProps struct {
	// Default setting value.
	Default int64 `json:"default"`
	// Optional lowest value the setting can be.
	Min *int64 `json:"min,omitempty"`
	// Optional highest value the setting can be.
	Max *int64 `json:"max,omitempty"`
	// Optional step value used for sliders on clients.
	Step *int64 `json:"step,omitempty"`
	// A "recommended" minimum, values down to [IntProps.Min] can still be set.
	// This is the slider range start for clients. [IntProps.Min] by default.
	RecommendedMin *int64 `json:"recommendedMin,omitempty"`
	// Slider range end for clients, [IntProps.Max] by default.
	// See [IntProps.RecommendedMin] for details.
	RecommendedMax *int64 `json:"recommendedMax,omitempty"`
}

// Creates an int setting definition with [def] as the default.
func Int(id string, def int64) IntSetting {
	return IntSetting{SettingsDefinition: SettingsDefinition{
		ID:   id,
		Kind: KindInt,
		Int:  &IntProps{Default: def},
	}}
}

type IntSetting struct{ SettingsDefinition }

// See [SettingsDefinition.Order]
func (s IntSetting) Order(v int) IntSetting { s.SettingsDefinition.Order = v; return s }

// See [IntProps.Min]
func (s IntSetting) Min(v int64) IntSetting { s.Int.Min = new(v); return s }

// See [IntProps.Max]
func (s IntSetting) Max(v int64) IntSetting { s.Int.Max = new(v); return s }

// See [IntProps.Step]
func (s IntSetting) Step(v int64) IntSetting { s.Int.Step = new(v); return s }

// See [IntProps.RecommendedMin] and [IntProps.RecommendedMax]
func (s IntSetting) Recommended(min int64, max int64) IntSetting {
	s.Int.RecommendedMin = new(min)
	s.Int.RecommendedMax = new(max)
	return s
}
