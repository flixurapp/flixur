package settings

import pb "forge.xela.codes/xela/flixur/pluginkit/proto"

// Creates an int setting definition with [def] as the default.
func Int(id string, def int64) IntSetting {
	return IntSetting{&Def{&pb.SettingsDefinition{
		Id:   id,
		Kind: pb.Kind_INT,
		Int:  &pb.IntProps{DefaultValue: def},
	}}}
}

type IntSetting struct{ *Def }

// See [pb.SettingsDefinition.Order]
func (s IntSetting) Order(v int) IntSetting { s.SettingsDefinition.Order = int32(v); return s }

// See [pb.IntProps.Min]
func (s IntSetting) Min(v int64) IntSetting { s.Int.Min = new(v); return s }

// See [pb.IntProps.Max]
func (s IntSetting) Max(v int64) IntSetting { s.Int.Max = new(v); return s }

// See [pb.IntProps.Step]
func (s IntSetting) Step(v int64) IntSetting { s.Int.Step = new(v); return s }

// See [pb.IntProps.RecommendedMin] and [pb.IntProps.RecommendedMax]
func (s IntSetting) Recommended(min int64, max int64) IntSetting {
	s.Int.RecommendedMin = new(min)
	s.Int.RecommendedMax = new(max)
	return s
}
