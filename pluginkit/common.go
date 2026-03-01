package pluginkit

import (
	"context"

	pb "github.com/flixurapp/flixur/proto/go"
	"github.com/hashicorp/go-plugin"
)

var HandshakeConfig = plugin.HandshakeConfig{
	ProtocolVersion:  1,
	MagicCookieKey:   "FLIXUR_PLUGIN_MAGIC",
	MagicCookieValue: "i am REAL",
}

// The flixur plugin implementation. Both client/server implement these functions.
type FlixurPlugin interface {
	GetPluginInfo(ctx context.Context) (*pb.PluginInfo, error)
	ArtistGet(ctx context.Context, req *pb.ArtistGetRequest) (*pb.ArtistGetResponse, error)
	ArtistSearch(ctx context.Context, req *pb.ArtistSearchRequest) (*pb.ArtistSearchResponse, error)
	AlbumGet(ctx context.Context, req *pb.AlbumGetRequest) (*pb.AlbumGetResponse, error)
	AlbumSearch(ctx context.Context, req *pb.AlbumSearchRequest) (*pb.AlbumSearchResponse, error)
	TrackGet(ctx context.Context, req *pb.TrackGetRequest) (*pb.TrackGetResponse, error)
	TrackSearch(ctx context.Context, req *pb.TrackSearchRequest) (*pb.TrackSearchResponse, error)
}

// The go-plugin wrapper that handles gRPC communication.
type FlixurGRPCPlugin struct {
	plugin.NetRPCUnsupportedPlugin
	Impl FlixurPlugin
}
