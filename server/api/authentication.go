// methods for authenticating with the server
package api

import (
	"context"
	"net/http"

	"forge.xela.codes/xela/flixur/common"
	"github.com/danielgtaylor/huma/v2"
)

type PingOutput struct {
	Body struct {
		// SemVer version of the server.
		Version string `json:"version"`
		// Current numeric protocol version of the server.
		ProtocolVersion int32 `json:"protocolVersion"`
		// If the server has been set up already. Used to redirect to server setup screen.
		IsSetup bool `json:"isSetup"`
	}
}

func RegisterAuthenticationRoutes(api huma.API) {
	huma.Register(api, huma.Operation{
		OperationID: "ping",
		Method:      http.MethodGet,
		Path:        "/ping",
		Summary:     "Test server connectivity.",
		Description: "Can be used to test the server connectivity and version.",
		Tags:        []string{"Authentication", "Connectivity"},
	}, func(ctx context.Context, _ *struct{}) (*PingOutput, error) {
		response := &PingOutput{}
		//TODO: return an actual version
		response.Body.Version = "0.0.0"
		response.Body.ProtocolVersion = common.Version
		//TODO: once setup is a thing change this
		response.Body.IsSetup = true
		return response, nil
	})
}
