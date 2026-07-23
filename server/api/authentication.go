// methods for authenticating with the server
package api

import (
	"context"
	"net/http"

	"github.com/danielgtaylor/huma/v2"
)

type PingOutput struct {
	Body struct {
		Version string `json:"version"`
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
		return response, nil
	})
}
