package pluginkit

import (
	"context"

	pb "github.com/flixurapp/flixur/proto/go"
	"github.com/hashicorp/go-plugin"
	"google.golang.org/grpc"
)

type grpcClient struct {
	client pb.FlixurPluginClient
}

func (p *FlixurGRPCPlugin) GRPCClient(ctx context.Context, broker *plugin.GRPCBroker, c *grpc.ClientConn) (interface{}, error) {
	return &grpcClient{client: pb.NewFlixurPluginClient(c)}, nil
}

func (m *grpcClient) GetPluginInfo(ctx context.Context) (*pb.PluginInfo, error) {
	return m.client.GetPluginInfo(ctx, &pb.EmptyRequest{})
}

func (m *grpcClient) ArtistGet(ctx context.Context, req *pb.ArtistGetRequest) (*pb.ArtistGetResponse, error) {
	return m.client.ArtistGet(ctx, req)
}

func (m *grpcClient) ArtistSearch(ctx context.Context, req *pb.ArtistSearchRequest) (*pb.ArtistSearchResponse, error) {
	return m.client.ArtistSearch(ctx, req)
}

func (m *grpcClient) AlbumGet(ctx context.Context, req *pb.AlbumGetRequest) (*pb.AlbumGetResponse, error) {
	return m.client.AlbumGet(ctx, req)
}

func (m *grpcClient) AlbumSearch(ctx context.Context, req *pb.AlbumSearchRequest) (*pb.AlbumSearchResponse, error) {
	return m.client.AlbumSearch(ctx, req)
}

func (m *grpcClient) TrackGet(ctx context.Context, req *pb.TrackGetRequest) (*pb.TrackGetResponse, error) {
	return m.client.TrackGet(ctx, req)
}

func (m *grpcClient) TrackSearch(ctx context.Context, req *pb.TrackSearchRequest) (*pb.TrackSearchResponse, error) {
	return m.client.TrackSearch(ctx, req)
}
