package settings

import pb "forge.xela.codes/xela/flixur/pluginkit/proto"

// Creates an enum setting definition with [def] as the default.
func Enum(id string, def string) EnumSetting {
	return EnumSetting{&Def{&pb.SettingsDefinition{
		Id:   id,
		Kind: pb.Kind_ENUM,
		Enum: &pb.EnumProps{DefaultValue: def},
	}}}
}

type EnumSetting struct{ *Def }

// See [pb.SettingsDefinition.Order]
func (s EnumSetting) Order(v int) EnumSetting { s.SettingsDefinition.Order = int32(v); return s }

// Adds a new choice with [value] and optional Iconify icon name. See [pb.EnumProps.Choices]
func (s EnumSetting) AddChoice(value string, icon ...string) EnumSetting {
	s.Enum.Choices = append(s.Enum.Choices, newChoice(value, icon...))
	return s
}

// Adds a new choice with the description flag set true.
// See [EnumSetting.AddChoice]
func (s EnumSetting) AddChoiceWithDescription(value string, icon ...string) EnumSetting {
	s.Enum.Choices = append(s.Enum.Choices, newChoiceWithDescription(value, icon...))
	return s
}
