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

	//TODO: add settings

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
