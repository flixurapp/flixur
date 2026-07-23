package pluginkit

import (
	"context"

	pb "forge.xela.codes/xela/flixur/pluginkit/proto"
	"github.com/hashicorp/go-plugin"
)

var HandshakeConfig = plugin.HandshakeConfig{
	ProtocolVersion:  1,
	MagicCookieKey:   "FLIXUR_PLUGIN_MAGIC",
	MagicCookieValue: "i am REAL",
}

// The flixur plugin implementation. Both client/server implement these functions.
//
//go:generate go run ./generator -dir .
type FlixurPlugin interface {
	// Get plugin metadata and capabilities.
	GetPluginInfo(ctx context.Context) (*pb.PluginInfo, error)

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
