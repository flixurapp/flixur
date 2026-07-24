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
		// Whether the server has been set up already. Used to redirect to server setup screen.
		IsSetup bool `json:"isSetup"`
		// Whether the server supports logging in via username/password.
		SupportsPasswordLogin bool `json:"supportsPasswordLogin"`
		// If set, the server supports logging in via a configured OIDC provider with this name.
		SupportsOIDCLogin string `json:"supportsOIDCLogin"`
	} // additional auth methods could be added in the future
}

type OIDCInitOutput struct {
	Body struct {
		// The URL to use for logging in via OIDC.
		LoginURL string `json:"loginURL"`
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
		response.Body.SupportsOIDCLogin = "Pocket ID"
		response.Body.SupportsPasswordLogin = true
		return response, nil
	})

	huma.Register(api, huma.Operation{
		OperationID: "oidc_init",
		Method:      http.MethodGet,
		Path:        "/oidc_init",
		Summary:     "Initialize an OIDC login request.",
		Description: "Initializes an OIDC login request returning the URL for authorization.",
		Tags:        []string{"Authentication", "Login"},
	}, func(ctx context.Context, _ *struct{}) (*OIDCInitOutput, error) {
		response := &OIDCInitOutput{}
		//TODO: oidc
		response.Body.LoginURL = ""
		return response, nil
	})
}
