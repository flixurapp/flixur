// methods for authenticating with the server
package api

import (
	"context"
	"crypto/rand"
	"fmt"
	"net/http"
	"sync/atomic"

	"forge.xela.codes/xela/flixur/common"
	"forge.xela.codes/xela/flixur/ent"
	"forge.xela.codes/xela/flixur/ent/user"
	"github.com/cardinalby/hureg"
	"github.com/cardinalby/hureg/pkg/huma/op_handler"
	"github.com/danielgtaylor/huma/v2"
	"github.com/oklog/ulid/v2"
	"github.com/rs/zerolog/log"
)

// Platform headers used to
type PlatformHeadersMixin struct {
	PlatformClient string `header:"X-Platform-Client" required:"true" minLength:"1" doc:"Client Name/Version"`
	PlatformDevice string `header:"X-Platform-Device" required:"true" minLength:"1" doc:"Device Name"`
	PlatformOS     string `header:"X-Platform-OS" required:"true" minLength:"1" doc:"Operating System/Version"`
}

type PingBody struct {
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
	// ^^ additional auth methods could be added in the future
}

type OIDCInitBody struct {
	// The URL to use for logging in via OIDC.
	LoginURL string `json:"loginURL"`
}

type SessionTokenBody struct {
	SessionToken string `json:"sessionToken"`
}

func RegisterAuthenticationRoutes(reg APIRegistry) {
	api := reg.API.AddOpHandler(op_handler.AddTags("Authentication"))

	hureg.Get(WithDocs(api, huma.Operation{
		Summary:     "Ping Server",
		Description: "Can be used to test the server connectivity and return version/feature info.",
	}, nil), "/ping", func(ctx context.Context, _ *struct{}) (*Output[PingBody], error) {
		return CreateOutput(PingBody{
			//TODO: return an actual version
			Version:               "0.0.0",
			ProtocolVersion:       common.Version,
			IsSetup:               GetServerSetupCode() == nil,
			SupportsOIDCLogin:     "Pocket ID",
			SupportsPasswordLogin: true,
		}), nil
	})

	// all following routes are at /auth
	api = api.AddBasePath("/auth")

	hureg.Post(WithDocs(api, huma.Operation{
		Path:        "/setup",
		Summary:     "Setup Server",
		Description: "Creates the initial admin account and sets up the server.",
	}, &APIErrorCodes{
		CodeDatabaseError:     "Failed to write to database.",
		CodeIncorrectPassword: "The setup code is incorrect.",
		CodeInvalidInput:      "Username contains non-ASCII character.",
		CodeTooLong:           "Username/password is too long.",
		CodeTooShort:          "Username/password is too short.",
	}), "/setup", func(ctx context.Context, input *struct {
		PlatformHeadersMixin
		Body struct {
			// Setup code for the server. This is logged in the console.
			Code string `json:"code" example:"XXXXXX"`
			// Username for the initial admin account.
			Username string `json:"username" example:"peppa.pig"`
			// Password for the initial admin account.
			Password string `json:"password"`
		}
	}) (*Output[SessionTokenBody], error) {
		setupCode := GetServerSetupCode()
		if setupCode == nil {
			return nil, huma.Error400BadRequest("server is already setup")
		}
		if input.Body.Code != *setupCode {
			return nil, CreateAPIError(CodeIncorrectPassword)
		}

		var err error = fmt.Errorf("error")
		// disable setups in-memory (prevent concurrent requests, albeit rare)
		SetServerSetupCode(nil)
		defer func() {
			// reset setup code on error
			if err != nil {
				SetServerSetupCode(setupCode)
			}
		}()

		// validate username
		if len(input.Body.Username) < common.USERNAME_MIN_LENGTH {
			return nil, CreateAPIErrorDetail(CodeTooShort, "username")
		}
		if len(input.Body.Username) > common.USERNAME_MAX_LENGTH {
			return nil, CreateAPIErrorDetail(CodeTooLong, "username")
		}
		if !common.IsValidUsername(input.Body.Username) {
			return nil, CreateAPIErrorDetail(CodeInvalidInput, "username")
		}

		// validate password
		if len(input.Body.Password) < common.PASSWORD_MIN_LENGTH {
			return nil, CreateAPIErrorDetail(CodeTooShort, "password")
		}
		if len(input.Body.Password) > common.PASSWORD_MAX_LENGTH {
			return nil, CreateAPIErrorDetail(CodeTooLong, "password")
		}

		tx, err := reg.DB.Tx(ctx)
		if err != nil {
			log.Err(err).Msg("Failed to start transaction for initial admin user creation.")
			return nil, CreateAPIError(CodeDatabaseError)
		}

		// roll back on error path
		defer func() {
			if err != nil {
				if rerr := tx.Rollback(); rerr != nil {
					log.Err(rerr).Msg("Failed to rollback transaction.")
				}
			}
		}()

		// create user in database
		user, err := tx.User.Create().
			SetUsername(input.Body.Username).
			SetPassword(input.Body.Password).
			SetIsAdmin(true).
			Save(ctx)
		if err != nil {
			log.Err(err).Msg("Failed to create initial admin user.")
			return nil, CreateAPIError(CodeDatabaseError)
		}

		// create new user session
		sessionToken, err := CreateUserSessionToken(ctx, tx.Client(), user, input.PlatformHeadersMixin)
		if err != nil {
			log.Err(err).Msg("Failed to create session for initial admin user.")
			return nil, CreateAPIError(CodeDatabaseError)
		}

		// all done with database work
		if err = tx.Commit(); err != nil {
			log.Err(err).Msg("Failed to commit initial admin user creation.")
			return nil, CreateAPIError(CodeDatabaseError)
		}

		log.Info().Msg("Successfully set up server!")

		// success
		return CreateOutput(SessionTokenBody{
			SessionToken: sessionToken,
		}), nil
	})

	// we really only need to block the login routes from working without the server being set up
	// the above methods don't really matter as they require authentication
	api = api.AddMiddlewares(func(ctx huma.Context, next func(huma.Context)) {
		if GetServerSetupCode() != nil {
			huma.WriteErr(api.GetHumaAPI(), ctx, http.StatusServiceUnavailable, "server not set up")
			return
		}
		next(ctx)
	})

	hureg.Post(WithDocs(api, huma.Operation{
		Summary:     "Login",
		Description: "Login with username/password.",
	}, &APIErrorCodes{
		CodeIncorrectUsername: "Username not found.",
		CodeIncorrectPassword: "Incorrect password.",
	}), "/login", func(ctx context.Context, input *struct {
		PlatformHeadersMixin
		Body struct {
			Username string `json:"username"`
			Password string `json:"password"`
		}
	}) (*Output[SessionTokenBody], error) {
		user, err := reg.DB.User.Query().
			Where(user.UsernameEqualFold(input.Body.Username)).
			First(ctx)
		if err != nil {
			return nil, CreateAPIError(CodeIncorrectUsername)
		}

		//TODO:
		if user != nil {
			return nil, nil
		}

		return CreateOutput(SessionTokenBody{
			SessionToken: "",
		}), nil
	})

	hureg.Get(WithDocs(api, huma.Operation{
		Summary:     "OIDC Login",
		Description: "Initializes an OIDC login request returning the URL for authorization.",
	}, nil), "/oidc_url", func(ctx context.Context, _ *struct{}) (*Output[OIDCInitBody], error) {
		//TODO: oidc
		return CreateOutput(OIDCInitBody{
			LoginURL: "",
		}), nil
	})
}

func CreateUserSessionToken(ctx context.Context, client *ent.Client, user *ent.User, headers PlatformHeadersMixin) (string, error) {
	token := rand.Text()

	_, err := client.UserSession.Create().
		SetToken(token).
		SetIPAddress(GetClientIP(ctx)).
		SetPlatform(fmt.Sprintf("%s on %s running %s", headers.PlatformClient, headers.PlatformDevice, headers.PlatformOS)).
		SetUser(user).Save(ctx)
	if err != nil {
		return "", err
	}
	return token, nil
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
