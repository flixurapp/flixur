package settings

// A float setting's properties.
type FloatProps struct {
	// Default setting value.
	Default float64 `json:"default"`
	// Optional lowest value the setting can be.
	Min *float64 `json:"min,omitempty"`
	// Optional highest value the setting can be.
	Max *float64 `json:"max,omitempty"`
	// Optional step value used for sliders on clients.
	Step *float64 `json:"step,omitempty"`
	// A "recommended" minimum, values down to [FloatProps.Min] can still be set.
	// This is the slider range start for clients. [FloatProps.Min] by default.
	RecommendedMin *float64 `json:"recommendedMin,omitempty"`
	// Slider range end for clients, [FloatProps.Max] by default.
	// See [FloatProps.RecommendedMin] for details.
	RecommendedMax *float64 `json:"recommendedMax,omitempty"`
}

// Creates a float setting definition with [def] as the default.
func Float(id string, def float64) FloatSetting {
	return FloatSetting{SettingsDefinition: SettingsDefinition{
		ID:    id,
		Kind:  KindFloat,
		Float: &FloatProps{Default: def},
	}}
}

type FloatSetting struct{ SettingsDefinition }

// See [SettingsDefinition.Order]
func (s FloatSetting) Order(v int) FloatSetting { s.SettingsDefinition.Order = v; return s }

// See [FloatProps.Min]
func (s FloatSetting) Min(v float64) FloatSetting { s.Float.Min = new(v); return s }

// See [FloatProps.Max]
func (s FloatSetting) Max(v float64) FloatSetting { s.Float.Max = new(v); return s }

// See [FloatProps.Step]
func (s FloatSetting) Step(v float64) FloatSetting { s.Float.Step = new(v); return s }

// See [FloatProps.RecommendedMin] and [FloatProps.RecommendedMax]
func (s FloatSetting) Recommended(min float64, max float64) FloatSetting {
	s.Float.RecommendedMin = new(min)
	s.Float.RecommendedMax = new(max)
	return s
}
