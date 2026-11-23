package pluginkit

import (
	"context"

	pb "forge.xela.codes/xela/flixur/pluginkit/proto"
	"github.com/hashicorp/go-plugin"
	"google.golang.org/grpc"
)

func (p *FlixurGRPCPlugin) GRPCServer(broker *plugin.GRPCBroker, s *grpc.Server) error {
	pb.RegisterFlixurPluginServiceServer(s, p.Impl)
	return nil
}

func (p *FlixurGRPCPlugin) GRPCClient(ctx context.Context, broker *plugin.GRPCBroker, c *grpc.ClientConn) (any, error) {
	return pb.NewFlixurPluginServiceClient(c), nil
}
