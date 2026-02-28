package pluginkit

import (
	"context"

	pb "github.com/flixurapp/flixur/proto/go"
	pbmusic "github.com/flixurapp/flixur/proto/go"
	"github.com/hashicorp/go-plugin"
	"google.golang.org/grpc"
)

var HandshakeConfig = plugin.HandshakeConfig{
	ProtocolVersion:  1,
	MagicCookieKey:   "FLIXUR_PLUGIN_MAGIC",
	MagicCookieValue: "i am REAL",
}

type FlixurPlugin interface {
	GetPluginInfo(ctx context.Context) (*pb.PluginInfo, error)
	ArtistGet(ctx context.Context, req *pbmusic.ArtistGetRequest) (*pbmusic.ArtistGetResponse, error)
	ArtistSearch(ctx context.Context, req *pbmusic.ArtistSearchRequest) (*pbmusic.ArtistSearchResponse, error)
	AlbumGet(ctx context.Context, req *pbmusic.AlbumGetRequest) (*pbmusic.AlbumGetResponse, error)
	AlbumSearch(ctx context.Context, req *pbmusic.AlbumSearchRequest) (*pbmusic.AlbumSearchResponse, error)
	TrackGet(ctx context.Context, req *pbmusic.TrackGetRequest) (*pbmusic.TrackGetResponse, error)
	TrackSearch(ctx context.Context, req *pbmusic.TrackSearchRequest) (*pbmusic.TrackSearchResponse, error)
}

// The go-plugin wrapper that handles gRPC communication.
type FlixurGRPCPlugin struct {
	plugin.NetRPCUnsupportedPlugin
	Impl FlixurPlugin
}

func (p *FlixurGRPCPlugin) GRPCServer(broker *plugin.GRPCBroker, s *grpc.Server) error {
	pb.RegisterFlixurPluginServer(s, &grpcServer{Impl: p.Impl})
	return nil
}

func (p *FlixurGRPCPlugin) GRPCClient(ctx context.Context, broker *plugin.GRPCBroker, c *grpc.ClientConn) (interface{}, error) {
	return &grpcClient{client: pb.NewFlixurPluginClient(c)}, nil
}

// Implements FlixurPlugin by making gRPC calls to the plugin process.
type grpcClient struct {
	client pb.FlixurPluginClient
}

func (m *grpcClient) GetPluginInfo(ctx context.Context) (*pb.PluginInfo, error) {
	return m.client.GetPluginInfo(ctx, &pb.EmptyRequest{})
}

func (m *grpcClient) ArtistGet(ctx context.Context, req *pbmusic.ArtistGetRequest) (*pbmusic.ArtistGetResponse, error) {
	return m.client.ArtistGet(ctx, req)
}

func (m *grpcClient) ArtistSearch(ctx context.Context, req *pbmusic.ArtistSearchRequest) (*pbmusic.ArtistSearchResponse, error) {
	return m.client.ArtistSearch(ctx, req)
}

func (m *grpcClient) AlbumGet(ctx context.Context, req *pbmusic.AlbumGetRequest) (*pbmusic.AlbumGetResponse, error) {
	return m.client.AlbumGet(ctx, req)
}

func (m *grpcClient) AlbumSearch(ctx context.Context, req *pbmusic.AlbumSearchRequest) (*pbmusic.AlbumSearchResponse, error) {
	return m.client.AlbumSearch(ctx, req)
}

func (m *grpcClient) TrackGet(ctx context.Context, req *pbmusic.TrackGetRequest) (*pbmusic.TrackGetResponse, error) {
	return m.client.TrackGet(ctx, req)
}

func (m *grpcClient) TrackSearch(ctx context.Context, req *pbmusic.TrackSearchRequest) (*pbmusic.TrackSearchResponse, error) {
	return m.client.TrackSearch(ctx, req)
}

// Implements the gRPC FlixurPluginServer by delegating to the Impl.
type grpcServer struct {
	pb.UnimplementedFlixurPluginServer
	Impl FlixurPlugin
}

func (m *grpcServer) GetPluginInfo(ctx context.Context, _ *pb.EmptyRequest) (*pb.PluginInfo, error) {
	return m.Impl.GetPluginInfo(ctx)
}

func (m *grpcServer) ArtistGet(ctx context.Context, req *pbmusic.ArtistGetRequest) (*pbmusic.ArtistGetResponse, error) {
	return m.Impl.ArtistGet(ctx, req)
}

func (m *grpcServer) ArtistSearch(ctx context.Context, req *pbmusic.ArtistSearchRequest) (*pbmusic.ArtistSearchResponse, error) {
	return m.Impl.ArtistSearch(ctx, req)
}

func (m *grpcServer) AlbumGet(ctx context.Context, req *pbmusic.AlbumGetRequest) (*pbmusic.AlbumGetResponse, error) {
	return m.Impl.AlbumGet(ctx, req)
}

func (m *grpcServer) AlbumSearch(ctx context.Context, req *pbmusic.AlbumSearchRequest) (*pbmusic.AlbumSearchResponse, error) {
	return m.Impl.AlbumSearch(ctx, req)
}

func (m *grpcServer) TrackGet(ctx context.Context, req *pbmusic.TrackGetRequest) (*pbmusic.TrackGetResponse, error) {
	return m.Impl.TrackGet(ctx, req)
}

func (m *grpcServer) TrackSearch(ctx context.Context, req *pbmusic.TrackSearchRequest) (*pbmusic.TrackSearchResponse, error) {
	return m.Impl.TrackSearch(ctx, req)
}

// Serve is a convenience function for plugins. It sets up the go-plugin framework.
func Serve(impl FlixurPlugin) {
	plugin.Serve(&plugin.ServeConfig{
		HandshakeConfig: HandshakeConfig,
		Plugins: map[string]plugin.Plugin{
			"flixur_plugin": &FlixurGRPCPlugin{Impl: impl},
		},
		GRPCServer: plugin.DefaultGRPCServer,
	})
}
