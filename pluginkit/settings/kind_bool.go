package settings

import pb "forge.xela.codes/xela/flixur/pluginkit/proto"

// Creates a bool setting definition with [def] as the default.
func Bool(id string, def bool) BoolSetting {
	return BoolSetting{&Def{&pb.SettingsDefinition{
		Id:   id,
		Kind: pb.Kind_BOOL,
		Bool: &pb.BoolProps{DefaultValue: def},
	}}}
}

type BoolSetting struct{ *Def }

// See [pb.SettingsDefinition.Order]
func (s BoolSetting) Order(v int) BoolSetting { s.SettingsDefinition.Order = int32(v); return s }
