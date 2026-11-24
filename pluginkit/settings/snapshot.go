package settings

import pb "forge.xela.codes/xela/flixur/pluginkit/proto"

// Builds an init handshake response holding the registry's definitions.
func Snapshot(r *Registry) *pb.InitResponse {
	return &pb.InitResponse{
		Groups:      r.Groups(),
		Definitions: r.All(),
	}
}
