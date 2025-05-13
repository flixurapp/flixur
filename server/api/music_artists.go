package api

import (
	"context"
	"fmt"
	"net/http"

	"github.com/danielgtaylor/huma/v2"
	"github.com/flixurapp/flixur/pluginkit"
	"github.com/flixurapp/flixur/plugins"
	protobuf "github.com/flixurapp/flixur/proto/go"
)

type ArtistSearchOutput struct {
	Body struct {
		List []*protobuf.Artist `json:"list"`
	}
}

func RegisterMusicArtistsAPI(api huma.API) {
	huma.Register(api, huma.Operation{
		OperationID: "artist-search",
		Method:      http.MethodPost,
		Path:        "/music/artists/search",
		Summary:     "Search for artists.",
		Description: "Search for an artist by name.",
		Tags:        []string{"Music", "Artists", "Search"},
	}, func(ctx context.Context, input *struct {
		Body struct {
			InputLimitParams
			InputPluginParamsOptional
			InputSearchParams
		}
	}) (*ArtistSearchOutput, error) {
		response := &ArtistSearchOutput{}

		if input.Body.Plugin != "" {
			plugin := plugins.FindPluginByID(input.Body.Plugin)
			if plugin == nil {
				return nil, fmt.Errorf("plugin not found")
			}

			if res, err := pluginkit.FeatureRequest[*protobuf.FeatureArtistSearchResponse](plugin.Input, protobuf.Features_ARTIST_SEARCH, &protobuf.FeatureArtistSearchRequest{
				Query: input.Body.Query,
			}); err != nil {
				return nil, err
			} else {
				response.Body.List = res.Results
				return response, nil
			}
		} else {
			return nil, fmt.Errorf("not implemented")
		}
	})
}
