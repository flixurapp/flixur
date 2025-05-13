package plugins

import (
	"io"
	"slices"

	protobuf "github.com/flixurapp/flixur/proto/go"
)

type Plugin struct {
	*protobuf.PacketInfo
	Input  io.Writer
	Output io.Reader
}

var Plugins map[string]*Plugin = make(map[string]*Plugin)

// Find specific plugin by ID.
func FindPluginByID(id string) *Plugin {
	for _, plugin := range Plugins {
		if plugin.Id == id {
			return plugin
		}
	}
	return nil
}

// Find all plugins by
func FingPluginsByFeature(feature protobuf.Features) []*Plugin {
	list := []*Plugin{}
	for _, plugin := range Plugins {
		if slices.Contains(plugin.Features, feature) {
			list = append(list, plugin)
		}
	}
	return list
}
