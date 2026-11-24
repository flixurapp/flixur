package settings

import pb "forge.xela.codes/xela/flixur/pluginkit/proto"

// Creates a string setting definition with [def] as the default.
func String(id string, def string) StringSetting {
	return StringSetting{&Def{&pb.SettingsDefinition{
		Id:      id,
		Kind:    pb.Kind_STRING,
		String_: &pb.StringProps{DefaultValue: def},
	}}}
}

type StringSetting struct{ *Def }

// See [pb.SettingsDefinition.Order]
func (s StringSetting) Order(v int) StringSetting { s.SettingsDefinition.Order = int32(v); return s }

// See [pb.StringProps.MaxLength]
func (s StringSetting) MaxLength(v int) StringSetting {
	s.String_.MaxLength = new(int64(v))
	return s
}

// See [pb.StringProps.Secret]
func (s StringSetting) Secret(v bool) StringSetting { s.String_.Secret = new(v); return s }
