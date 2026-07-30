package api

import (
	"context"
	"fmt"

	pb "forge.xela.codes/xela/flixur/pluginkit/proto"
	"forge.xela.codes/xela/flixur/plugins"
	"github.com/cardinalby/hureg"
	"github.com/cardinalby/hureg/pkg/huma/op_handler"
)

type ArtistSearchBody struct {
	List []*pb.Artist `json:"list" nullable:"false"`
}

func RegisterMusicArtistsRoutes(reg APIRegistry) {
	api := reg.API.AddOpHandler(op_handler.AddTags("Artists"))

	hureg.Post(WithOptions(api, APIRoute{
		OperationID: "search_artists",
		Name:        "Search Artists",
		Description: "Search for an artist by name.",
	}), "/artists/search", func(ctx context.Context, input *struct {
		Body struct {
			InputLimitParams
			InputPluginParamsOptional
			InputSearchParams
		}
	}) (*Output[ArtistSearchBody], error) {
		if input.Body.Plugin != "" {
			plugin := plugins.FindPluginByID(input.Body.Plugin)
			if plugin == nil {
				return nil, fmt.Errorf("plugin not found")
			}
			if !plugin.HasFeature(pb.Feature_MUSIC_METADATA) {
				return nil, fmt.Errorf("feature not implemented")
			}

			res, err := plugin.RPC.ArtistSearch(ctx, &pb.ArtistSearchRequest{
				Query: input.Body.Query,
				Limit: input.Body.Limit,
			})
			if err != nil {
				return nil, err
			}
			return CreateOutput(ArtistSearchBody{
				List: res.Results,
			}), nil
		} else {
			return nil, fmt.Errorf("not implemented")
		}
	})
}
