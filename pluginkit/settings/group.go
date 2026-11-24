package settings

import pb "forge.xela.codes/xela/flixur/pluginkit/proto"

// A group of settings.
type GroupSetting struct{ *pb.SettingsGroup }

// Creates a settings group for registration.
func Group(id string) GroupSetting {
	return GroupSetting{SettingsGroup: &pb.SettingsGroup{Id: id}}
}

// See [pb.SettingsGroup.Order]
func (g GroupSetting) Order(v int) GroupSetting { g.SettingsGroup.Order = int32(v); return g }

// See [pb.SettingsGroup.Icon]
func (g GroupSetting) Icon(name string) GroupSetting { g.SettingsGroup.Icon = &name; return g }
