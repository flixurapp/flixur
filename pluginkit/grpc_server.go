package pluginkit

import (
	"context"

	pb "github.com/flixurapp/flixur/proto/go"
	"github.com/hashicorp/go-plugin"
	"google.golang.org/grpc"
)

type grpcServer struct {
	pb.UnimplementedFlixurPluginServer
	Impl FlixurPlugin
}

func (p *FlixurGRPCPlugin) GRPCServer(broker *plugin.GRPCBroker, s *grpc.Server) error {
	pb.RegisterFlixurPluginServer(s, &grpcServer{Impl: p.Impl})
	return nil
}

func (m *grpcServer) GetPluginInfo(ctx context.Context, _ *pb.EmptyRequest) (*pb.PluginInfo, error) {
	return m.Impl.GetPluginInfo(ctx)
}

func (m *grpcServer) ArtistGet(ctx context.Context, req *pb.ArtistGetRequest) (*pb.ArtistGetResponse, error) {
	return m.Impl.ArtistGet(ctx, req)
}

func (m *grpcServer) ArtistSearch(ctx context.Context, req *pb.ArtistSearchRequest) (*pb.ArtistSearchResponse, error) {
	return m.Impl.ArtistSearch(ctx, req)
}

func (m *grpcServer) AlbumGet(ctx context.Context, req *pb.AlbumGetRequest) (*pb.AlbumGetResponse, error) {
	return m.Impl.AlbumGet(ctx, req)
}

func (m *grpcServer) AlbumSearch(ctx context.Context, req *pb.AlbumSearchRequest) (*pb.AlbumSearchResponse, error) {
	return m.Impl.AlbumSearch(ctx, req)
}

func (m *grpcServer) TrackGet(ctx context.Context, req *pb.TrackGetRequest) (*pb.TrackGetResponse, error) {
	return m.Impl.TrackGet(ctx, req)
}

func (m *grpcServer) TrackSearch(ctx context.Context, req *pb.TrackSearchRequest) (*pb.TrackSearchResponse, error) {
	return m.Impl.TrackSearch(ctx, req)
}
