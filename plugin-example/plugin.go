package main

import (
	"context"
	"embed"

	"forge.xela.codes/xela/flixur/pluginkit"
	pb "forge.xela.codes/xela/flixur/pluginkit/proto"
	"forge.xela.codes/xela/flixur/pluginkit/settings"
	"github.com/rs/zerolog/log"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
)

//go:embed manifest.json
var manifest embed.FS
var Manifest = pluginkit.LoadPluginManifest(manifest)

// registry for this plugin's server-side settings.
var registry = settings.NewRegistry()

// Tracks the latest values received from the server.
var SettingValues = settings.NewSettingsTracker()

func init() {
	registry.RegisterGroup(settings.Group("greeting").Icon("mdi:hand-wave").Order(1))
	registry.Register(settings.String("greeting.apiKey", "").Secret(true).Order(1))
	registry.Register(settings.Int("greeting.greetings", 1).Min(1).Max(10).Order(2))
}

type Plugin struct {
	pb.UnimplementedFlixurPluginServiceServer
}

func (p *Plugin) Init(ctx context.Context, req *pb.InitRequest) (*pb.InitResponse, error) {
	log.Info().Msg("Server requested init handshake.")
	return settings.Snapshot(registry), nil
}

func (p *Plugin) SettingsUpdate(ctx context.Context, req *pb.SettingsUpdateRequest) (*pb.SettingsUpdateResponse, error) {
	SettingValues.Update(req.Values)
	log.Info().Msg("Server settings changed, (re)starting client...")
	// modify an API client or something here
	return &pb.SettingsUpdateResponse{}, nil
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
