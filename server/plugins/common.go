package plugins

import (
	"slices"

	"forge.xela.codes/xela/flixur/pluginkit"
	pb "forge.xela.codes/xela/flixur/pluginkit/proto"
	"github.com/samber/lo"
)

type Plugin struct {
	Info    *pb.PluginInfo
	RPC     pluginkit.FlixurPlugin
	destroy func()
}

func (p *Plugin) HasFeature(feature pb.Feature) bool {
	// If your Info.Features is a slice of strings, convert the enum to string
	return slices.Contains(p.Info.Features, feature)
}

var Plugins map[string]*Plugin = make(map[string]*Plugin)

// Find specific plugin by ID.
func FindPluginByID(id string) *Plugin {
	return Plugins[id]
}

// Find all plugins that implement a specific feature.
func FindPluginsByFeature(feature pb.Feature) []*Plugin {
	return lo.FilterValues(Plugins, func(_ string, plugin *Plugin) bool {
		return slices.Contains(plugin.Info.Features, feature)
	})
}

// Destroy all loaded plugins and clean up resources.
func DestroyAllPlugins() {
	for _, plugin := range Plugins {
		if plugin.destroy != nil {
			plugin.destroy()
		}
	}
}
