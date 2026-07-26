// methods for authenticating with the server
package api

import (
	"context"
	"fmt"
	"net/http"
	"sync/atomic"

	"forge.xela.codes/xela/flixur/common"
	"forge.xela.codes/xela/flixur/ent"
	"github.com/danielgtaylor/huma/v2"
	"github.com/oklog/ulid/v2"
	"github.com/rs/zerolog/log"
)

type UserAgentHeaderMixin struct {
	UserAgent string `header:"User-Agent" required:"true" minLength:"1" doc:"User-Agent is required for platform determination."`
}

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

func RegisterAuthenticationRoutes(reg APIRegistry) {
	huma.Register(reg.API, huma.Operation{
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
		response.Body.IsSetup = GetServerSetupCode() == nil
		response.Body.SupportsOIDCLogin = "Pocket ID"
		response.Body.SupportsPasswordLogin = true
		return response, nil
	})

	huma.Register(reg.API, huma.Operation{
		OperationID: "setup",
		Method:      http.MethodPost,
		Path:        "/auth/setup",
		Summary:     "Setup Server",
		Description: "Creates the initial admin account and sets up the server.",
		Tags:        []string{"Authentication", "Setup"},
		Responses: APIErrorResponses(reg.API, map[APIErrorCode]string{
			CodeDatabaseError:     "Failed to write to database.",
			CodeIncorrectPassword: "The setup code is incorrect.",
			CodeInvalidInput:      "Username contains non-ASCII character.",
			CodeTooLong:           "Username/password is too long.",
			CodeTooShort:          "Username/password is too short.",
		}),
	}, func(ctx context.Context, input *struct {
		UserAgentHeaderMixin
		Body struct {
			// Setup code for the server. This is logged in the console.
			Code string `json:"code" example:"XXXXXX"`
			// Username for the initial admin account.
			Username string `json:"username" example:"peppa.pig"`
			// Password for the initial admin account.
			Password string `json:"password"`
		}
	}) (*OutputSuccess, error) {
		setupCode := GetServerSetupCode()
		if setupCode == nil {
			return nil, fmt.Errorf("server is already setup")
		}
		if input.Body.Code != *setupCode {
			return nil, NewAPIError(CodeIncorrectPassword)
		}

		// validate username
		if len(input.Body.Username) < common.USERNAME_MIN_LENGTH {
			return nil, NewAPIErrorDetail(CodeTooShort, "username")
		}
		if len(input.Body.Username) > common.USERNAME_MAX_LENGTH {
			return nil, NewAPIErrorDetail(CodeTooLong, "username")
		}
		if !common.IsValidUsername(input.Body.Username) {
			return nil, NewAPIErrorDetail(CodeInvalidInput, "username")
		}

		// validate password
		if len(input.Body.Password) < common.PASSWORD_MIN_LENGTH {
			return nil, NewAPIErrorDetail(CodeTooShort, "password")
		}
		if len(input.Body.Password) > common.PASSWORD_MAX_LENGTH {
			return nil, NewAPIErrorDetail(CodeTooLong, "password")
		}

		// create user in database
		user, err := reg.DB.User.Create().
			SetUsername(input.Body.Username).
			SetPassword(input.Body.Password).
			SetIsAdmin(true).
			Save(ctx)
		if err != nil {
			return nil, NewAPIError(CodeDatabaseError)
		}

		// create new user session
		reg.DB.UserSession.Create().
			SetIPAddress(GetClientIP(ctx)).
			//TODO: platform
			SetUser(user).Save(ctx)

		// success
		response := &OutputSuccess{}
		response.Body.Success = true
		return response, nil
	})

	huma.Register(reg.API, huma.Operation{
		OperationID: "oidc",
		Method:      http.MethodGet,
		Path:        "/auth/oidc",
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

// server setup state management
var serverSetupCode atomic.Pointer[string]

// Returns the setup code for the server. If this is nil, the server is set up.
func GetServerSetupCode() *string {
	return serverSetupCode.Load()
}
func SetServerSetupCode(state *string) {
	serverSetupCode.Store(state)
}
func LoadServerSetupState(ctx context.Context, client *ent.Client) error {
	// just check that there is at least 1 user account
	exists, err := client.User.Query().Exist(ctx)
	// exists will be false if error, so generate setup code
	if !exists {
		code := ulid.Make().String()
		code = code[len(code)-6:]
		SetServerSetupCode(&code)
		log.Info().Msgf("Server seup code: \"%s\"", code)
	} else {
		SetServerSetupCode(nil)
	}
	return err
}
