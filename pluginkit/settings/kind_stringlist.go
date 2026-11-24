package settings

import pb "forge.xela.codes/xela/flixur/pluginkit/proto"

// Creates a stringlist setting definition with [def] as the default.
func StringList(id string, def []string) StringListSetting {
	return StringListSetting{&Def{
		&pb.SettingsDefinition{
			Id:         id,
			Kind:       pb.Kind_STRINGLIST,
			StringList: &pb.StringListProps{DefaultValue: def},
		},
	}}
}

type StringListSetting struct{ *Def }

// See [pb.SettingsDefinition.Order]
func (s StringListSetting) Order(v int) StringListSetting {
	s.SettingsDefinition.Order = int32(v)
	return s
}

// Adds a new choice with [value] and optional Iconify icon name. See [pb.StringListProps.Choices]
func (s StringListSetting) AddChoice(value string, icon ...string) StringListSetting {
	s.StringList.Choices = append(s.StringList.Choices, newChoice(value, icon...))
	return s
}

// Adds a new choice with the description flag set true.
// See [StringListSetting.AddChoice]
func (s StringListSetting) AddChoiceWithDescription(value string, icon ...string) StringListSetting {
	s.StringList.Choices = append(s.StringList.Choices, newChoiceWithDescription(value, icon...))
	return s
}

// See [pb.StringListProps.MaxItems]
func (s StringListSetting) MaxItems(v int) StringListSetting {
	s.StringList.MaxItems = new(uint32(v))
	return s
}

// See [pb.StringListProps.AllowDuplicates]
func (s StringListSetting) AllowDuplicates(v bool) StringListSetting {
	s.StringList.AllowDuplicates = new(v)
	return s
}
