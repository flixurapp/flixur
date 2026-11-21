package api

import (
	"context"
	"slices"
	"strings"

	"forge.xela.codes/xela/flixur/pluginkit"
	"forge.xela.codes/xela/flixur/plugins"
	"github.com/cardinalby/hureg"
	"github.com/cardinalby/hureg/pkg/huma/op_handler"
)

type PluginsBody struct {
	List []*pluginkit.PluginManifest `json:"list" nullable:"false"`
}

func RegisterManageRoutes(reg APIRegistry) {
	api := reg.API.AddOpHandler(op_handler.AddTags("Management"))
	api = api.AddBasePath("/manage")

	//
	// Current Plugins
	//
	hureg.Get(WithOptions(api, reg, APIRoute{
		OperationID: "list_plugins",
		Name:        "List Plugins",
		Description: "Lists all installed plugins.",
	}), "/plugins", func(ctx context.Context, _ *struct{}) (*Output[PluginsBody], error) {
		list := make([]*pluginkit.PluginManifest, 0, len(plugins.Plugins))
		for _, plugin := range plugins.Plugins {
			// clone the manifest so the server-only binary path can be dropped
			manifest := *plugin.Manifest
			manifest.Binary = ""
			list = append(list, &manifest)
		}
		slices.SortFunc(list, func(a, b *pluginkit.PluginManifest) int {
			return strings.Compare(a.Id, b.Id)
		})
		return CreateOutput(PluginsBody{List: list}), nil
	})
}
