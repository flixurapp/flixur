package settings

import (
	"forge.xela.codes/xela/flixur/pluginkit"
	pb "forge.xela.codes/xela/flixur/pluginkit/proto"
	s "forge.xela.codes/xela/flixur/pluginkit/settings"
)

// Prefix all plugin settings are registered under.
const PluginNamespacePrefix = "plugins"

// Settings registry for server-scoped settings.
// These settings are global to the server and include plugins.
var ServerRegistry = NewServerRegistry()

// Creates the registry for server settings.
func NewServerRegistry() *s.Registry {
	reg := s.NewRegistry()

	reg.RegisterGroup(s.Group("testing").Order(1))

	reg.Register(s.Bool("testing.bool", false).Order(1))
	reg.Register(s.Int("testing.int", 0).Order(1))
	reg.Register(s.Int("testing.int_min", 0).Min(0).Order(1))
	reg.Register(s.Int("testing.int_max", 0).Max(100).Order(1))
	reg.Register(s.Int("testing.int_combined", 0).Min(1000).Max(2500).Step(50).Order(1))
	reg.Register(s.Int("testing.int_combined_rec", 0).Min(0).Max(300).Recommended(150, 200).Step(3).Order(1))
	reg.Register(s.Float("testing.float", 0).Order(1))
	reg.Register(s.Float("testing.float_min", 0).Min(0).Order(1))
	reg.Register(s.Float("testing.float_max", 0).Max(1).Order(1))
	reg.Register(s.Float("testing.float_01", 0).Min(0).Max(1).Order(1))
	reg.Register(s.Float("testing.float_combined", 1).Min(1).Max(3).Step(0.5).Order(1))
	reg.Register(s.Float("testing.float_combined_rec", 0).Min(0).Max(10).Recommended(2, 5).Step(0.25).Order(1))
	reg.Register(s.String("testing.str", "").Order(1))
	reg.Register(s.String("testing.str_secret", "").Secret(true).Order(1))
	reg.Register(s.String("testing.str_max", "").MaxLength(16).Order(1))
	reg.Register(s.String("testing.str_secret_max", "").Secret(true).MaxLength(128).Order(1))
	reg.Register(s.Enum("testing.enum", "").AddChoice("x", "x").AddChoice("y").AddChoice("extra_super_long_choice", "phone-disconnect").Order(1))
	reg.Register(s.StringList("testing.stringlist", []string{}).AddChoice("x", "x").AddChoice("y").AddChoice("extra_super_long_choice", "phone-disconnect").Order(1))
	reg.Register(s.StringList("testing.stringlist_nochoice", []string{}).MaxItems(4).Order(1))
	reg.Register(s.StringList("testing.stringlist_lim", []string{}).AddChoice("x", "x").AddChoiceWithDescription("y").AddChoice("extra_super_long_choice", "phone-disconnect").MaxItems(2).Order(1))
	reg.Register(s.StringList("testing.stringlist_mul", []string{}).AddChoice("x", "x").AddChoice("y").AddChoice("extra_super_long_choice", "phone-disconnect").AllowDuplicates(true).Order(1))

	return reg
}

// Merges a plugin's settings into [ServerRegistry].
// See [s.Merge]
func MergePluginSettings(manifest *pluginkit.PluginManifest, groups []*pb.SettingsGroup, defs []*pb.SettingsDefinition) error {
	// plugins without settings do nothing
	if len(groups) == 0 && len(defs) == 0 {
		return nil
	}

	// create the shared plugin group if its missing
	if ServerRegistry.FindGroup(PluginNamespacePrefix) == nil {
		ServerRegistry.RegisterGroup(s.Group(PluginNamespacePrefix).Icon("puzzle-piece").Order(2))
	}

	prefix := PluginNamespacePrefix + "." + manifest.Id
	// the plugin's group has its manifest icon
	return ServerRegistry.Merge(prefix, s.Group(prefix).Icon(manifest.Icon).Order(1), groups, defs)
}
