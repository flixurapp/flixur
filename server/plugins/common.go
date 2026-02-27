package plugins

import (
	"io"
	"slices"

	"github.com/flixurapp/flixur/pluginkit"
	protobuf "github.com/flixurapp/flixur/proto/go"
	"github.com/samber/lo"
)

type Plugin struct {
	*protobuf.PacketInfo
	Input    io.Writer
	Output   io.Reader
	Listener pluginkit.PacketListenerAdder
}

var Plugins map[string]*Plugin = make(map[string]*Plugin)

// Find specific plugin by ID.
func FindPluginByID(id string) *Plugin {
	return Plugins[id]
}

// Find all plugins that implement a specific feature.
func FingPluginsByFeature(feature protobuf.Features) []*Plugin {
	return lo.FilterValues(Plugins, func(_ string, plugin *Plugin) bool {
		return slices.Contains(plugin.Features, feature)
	})
}
