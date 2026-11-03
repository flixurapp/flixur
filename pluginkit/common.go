package pluginkit

import (
	"context"
	"encoding/json"
	"fmt"

	pb "forge.xela.codes/xela/flixur/pluginkit/proto"
	"github.com/hashicorp/go-plugin"
)

// Flixur plugin manifest JSON.
type PluginManifest struct {
	// Unique Plugin ID.
	Id string `json:"id"`
	// Name of the plugin.
	Name string `json:"name"`
	// Version string, formatted YYYY.MM.DD
	Version string `json:"version"`
	// List of plugin IDs that should be loaded before this plugin.
	Dependencies []string `json:"dependencies"`
	// List of feature IDs this plugin implements.
	Features []string `json:"features"`
	// Should be the full identifier of an Iconify icon for this plugin. (https://icon-sets.iconify.design)
	Icon string `json:"icon"`
	// Short description of the plugin.
	Description string `json:"description"`
	// Name of the plugin author.
	Author string `json:"author"`
	// Direct link to the source code of the plugin.
	Url string `json:"url"`
}

// Parse a raw plugin manifest into the struct.
func ParsePluginManifest(data []byte) *PluginManifest {
	var m PluginManifest
	if err := json.Unmarshal(data, &m); err != nil {
		panic(fmt.Sprintf("invalid manifest.json: %v", err))
	}
	return &m
}

var HandshakeConfig = plugin.HandshakeConfig{
	ProtocolVersion:  1,
	MagicCookieKey:   "FLIXUR_PLUGIN_MAGIC",
	MagicCookieValue: "i am REAL",
}

// The flixur plugin implementation. Both client/server implement these functions.
//
//go:generate go run ./generator -dir .
type FlixurPlugin interface {
	// === Artist Methods ===

	// Get a specific artist by ID.
	ArtistGet(ctx context.Context, req *pb.ArtistGetRequest) (*pb.ArtistGetResponse, error)
	// Search for artists by name.
	ArtistSearch(ctx context.Context, req *pb.ArtistSearchRequest) (*pb.ArtistSearchResponse, error)

	// === Album Methods ===

	// Get a specific album by ID.
	AlbumGet(ctx context.Context, req *pb.AlbumGetRequest) (*pb.AlbumGetResponse, error)
	// Search for albums by name.
	AlbumSearch(ctx context.Context, req *pb.AlbumSearchRequest) (*pb.AlbumSearchResponse, error)

	// === Track Methods ===

	// Get a specific track by ID.
	TrackGet(ctx context.Context, req *pb.TrackGetRequest) (*pb.TrackGetResponse, error)
	// Search for tracks by name.
	TrackSearch(ctx context.Context, req *pb.TrackSearchRequest) (*pb.TrackSearchResponse, error)
}

// The go-plugin wrapper that handles gRPC communication.
type FlixurGRPCPlugin struct {
	plugin.NetRPCUnsupportedPlugin
	Impl FlixurPlugin
}
