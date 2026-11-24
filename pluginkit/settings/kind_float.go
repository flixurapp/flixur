package settings

import pb "forge.xela.codes/xela/flixur/pluginkit/proto"

// Creates a float setting definition with [def] as the default.
func Float(id string, def float64) FloatSetting {
	return FloatSetting{&Def{&pb.SettingsDefinition{
		Id:    id,
		Kind:  pb.Kind_FLOAT,
		Float: &pb.FloatProps{DefaultValue: def},
	}}}
}

type FloatSetting struct{ *Def }

// See [pb.SettingsDefinition.Order]
func (s FloatSetting) Order(v int) FloatSetting { s.SettingsDefinition.Order = int32(v); return s }

// See [pb.FloatProps.Min]
func (s FloatSetting) Min(v float64) FloatSetting { s.Float.Min = new(v); return s }

// See [pb.FloatProps.Max]
func (s FloatSetting) Max(v float64) FloatSetting { s.Float.Max = new(v); return s }

// See [pb.FloatProps.Step]
func (s FloatSetting) Step(v float64) FloatSetting { s.Float.Step = new(v); return s }

// See [pb.FloatProps.RecommendedMin] and [pb.FloatProps.RecommendedMax]
func (s FloatSetting) Recommended(min float64, max float64) FloatSetting {
	s.Float.RecommendedMin = new(min)
	s.Float.RecommendedMax = new(max)
	return s
}
