package main

import (
	"context"
	"fmt"
	"os"

	"github.com/flixurapp/flixur/pluginkit"
	pb "github.com/flixurapp/flixur/proto/go"
	"github.com/rs/zerolog"
	"github.com/rs/zerolog/log"
)

var PluginInfo = pb.PluginInfo{
	Id:          "example",
	Name:        "Example Plugin",
	Version:     1,
	MinVersion:  1,
	Features:    []string{"ArtistSearch"},
	Icon:        "mdi:music",
	Description: "Small example plugin.",
	Author:      "You",
	Url:         "https://github.com/flixurapp/flixur/tree/main/plugin-example",
}

type Plugin struct {
	pb.UnimplementedFlixurPluginServer
}

func (p *Plugin) GetPluginInfo(ctx context.Context) (*pb.PluginInfo, error) {
	return &PluginInfo, nil
}

func (p *Plugin) ArtistGet(ctx context.Context, req *pb.ArtistGetRequest) (*pb.ArtistGetResponse, error) {
	// Not implemented in this example
	log.Info().Str("id", req.Id).Msg("ArtistGet called")
	return nil, fmt.Errorf("not implemented")
}

func (p *Plugin) ArtistSearch(ctx context.Context, req *pb.ArtistSearchRequest) (*pb.ArtistSearchResponse, error) {
	log.Info().Str("query", req.Query).Int32("limit", req.Limit).Msg("ArtistSearch called")

	ico := "http://localhost:8787/logo.png"
	return &pb.ArtistSearchResponse{
		Results: []*pb.Artist{
			{
				Id:       "example-1",
				Provider: "example",
				Name:     "Query: " + req.Query,
				Icon:     &ico,
			},
		},
	}, nil
}

func main() {
	log.Logger = log.Output(zerolog.ConsoleWriter{
		Out:        os.Stderr,
		TimeFormat: "3:04:05PM",
		FormatMessage: func(i interface{}) string {
			return fmt.Sprintf("[%s] %s", PluginInfo.Id, i)
		},
	})

	log.Info().Msg("Example plugin starting...")

	pluginkit.Serve(&Plugin{})
}
