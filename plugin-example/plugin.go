package main

import (
	"context"
	"embed"

	"forge.xela.codes/xela/flixur/pluginkit"
	pb "forge.xela.codes/xela/flixur/pluginkit/proto"
	"github.com/rs/zerolog/log"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
)

//go:embed manifest.json
var manifest embed.FS
var Manifest = pluginkit.LoadPluginManifest(manifest)

type Plugin struct {
	pb.UnimplementedFlixurPluginServiceServer
}

func (p *Plugin) ArtistGet(ctx context.Context, req *pb.ArtistGetRequest) (*pb.ArtistGetResponse, error) {
	// Not implemented in this example
	log.Info().Str("id", req.Id).Msg("ArtistGet called")
	return nil, status.Error(codes.Unimplemented, "not implemented")
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
	pluginkit.SetupPluginLogger(Manifest)
	log.Info().Msg("Example plugin starting...")

	pluginkit.Serve(&Plugin{})
}
