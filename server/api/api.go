package api

import (
	"context"
	"net"
	"net/http"
	"strings"

	"forge.xela.codes/xela/flixur/common"
	"forge.xela.codes/xela/flixur/ent"
	"github.com/cardinalby/hureg"
	"github.com/cardinalby/hureg/pkg/huma/op_handler"
	"github.com/danielgtaylor/huma/v2"
	"github.com/danielgtaylor/huma/v2/adapters/humachi"
	"github.com/go-chi/chi/v5"
	"github.com/go-chi/cors"

	_ "github.com/danielgtaylor/huma/v2/formats/cbor"
)

// struct of data passed to api builders
type APIRegistry struct {
	// Huma API instance.
	API hureg.APIGen
	// Database client.
	DB *ent.Client
	// Router instance.
	Router chi.Router
}

// base reusable structs

type InputSearchParams struct {
	Query string `json:"query" example:"Jerry Springer" minLength:"1" maxLength:"250"`
}
type InputLimitParams struct {
	Limit int32 `json:"limit,omitempty" default:"10" example:"100" minimum:"1" maximum:"100"`
}
type InputPluginParamsOptional struct {
	Plugin string `json:"plugin,omitempty" doc:"Plugin ID to use for the request. Omit to use the local server."`
}

type Output[T any] struct {
	Body T
}
type OutputSuccessBody struct {
	// If the request was successfully fulfilled.
	Success bool `json:"success"`
}

type APIRoute struct {
	// Set custom operation ID.
	OperationID string
	// Sets the `summary`, functions as an operation name.
	Name string
	// Sets the operation `description`.
	Description string
	// Sets operation non-200 `responses` to the unpacked error codes.
	Errors APIErrorCodes
	// If true, endpoint will not require the server to be set up to be called.
	NoSetup bool
	// If true, endpoint will not require bearer token to be called.
	NoAuth bool
}

// Sets ID/summary/description/responses on an APIGen instance.
func WithDocs(api hureg.APIGen, opts APIRoute) hureg.APIGen {
	handlers := []op_handler.OperationHandler{}
	middlewares := []func(huma.Context, func(huma.Context)){}

	if opts.OperationID != "" {
		handlers = append(handlers, func(o *huma.Operation) {
			o.OperationID = opts.OperationID
		})
	}
	if opts.Name != "" {
		handlers = append(handlers, op_handler.SetSummary(opts.Name, true))
	}
	if opts.Description != "" {
		handlers = append(handlers, op_handler.SetDescription(opts.Description, true))
	}

	// unpack error codes
	if len(opts.Errors) > 0 {
		responses := APIErrorResponses(api, opts.Errors)
		handlers = append(handlers, func(o *huma.Operation) {
			o.Responses = responses
		})
	}

	// require server to be set up
	if !opts.NoSetup {
		middlewares = append(middlewares, (func(ctx huma.Context, next func(huma.Context)) {
			if GetServerSetupCode() != nil {
				huma.WriteErr(api.GetHumaAPI(), ctx, http.StatusServiceUnavailable, "server not set up")
				return
			}
			next(ctx)
		}))
	}

	if !opts.NoAuth {
		//TODO: auth middleware
	}

	return api.
		AddOpHandler(handlers...).
		AddMiddlewares(middlewares...)
}

// Shorthand to create an output body struct.
func CreateOutput[T any](payload T) *Output[T] {
	return &Output[T]{
		Body: payload,
	}
}

func RegisterAPI(router chi.Router, client *ent.Client) APIRegistry {
	config := huma.DefaultConfig("Flixur API", "0.0.1")
	config.Servers = []*huma.Server{{URL: "/api"}}

	// Saved registry to be returned for tests.
	var registry = APIRegistry{
		DB:     client,
		Router: router,
	}
	router.Route("/api", func(r chi.Router) {
		// allow CORS on api routes (so other clients can connect)
		r.Use(cors.Handler(cors.Options{
			AllowedOrigins: []string{"https://*", "http://*"},
			AllowedMethods: []string{"GET", "POST", "PUT", "DELETE", "OPTIONS"},
			AllowedHeaders: []string{"Accept", "Authorization", "Content-Type", "X-CSRF-Token"},
			MaxAge:         300,
		}))

		registry.API = hureg.NewAPIGen(humachi.New(r, config)).
			AddMiddlewares(ipMiddleware)

		RegisterAuthenticationRoutes(registry)
		RegisterMusicArtistsRoutes(registry)

		//TODO:testing
		/*
			huma.Get(api, "/greeting/{name}", func(ctx context.Context, input *struct {
				Name string `path:"name" maxLength:"30" example:"world" doc:"Name to greet"`
			}) (*GreetingOutput, error) {
				resp := &GreetingOutput{}
				resp.Body.Message = fmt.Sprintf("Hello, %s!", input.Name)
				return resp, nil
			})
		*/
	})
	return registry
}

// key identifying the client IP
type ctxKeyClientIP struct{}

func isTrustedProxy(ip string) bool {
	if len(common.Config.TrustedProxyCIDRs) == 0 {
		return true
	}
	parsed := net.ParseIP(ip)
	if parsed == nil {
		return false
	}
	for _, cidr := range common.Config.TrustedProxyCIDRs {
		if cidr.Contains(parsed) {
			return true
		}
	}
	return false
}
func ipMiddleware(ctx huma.Context, next func(huma.Context)) {
	clientIP, _, err := net.SplitHostPort(ctx.RemoteAddr())
	// on failure just use raw addr
	if err != nil {
		clientIP = ctx.RemoteAddr()
	}

	// if we trust the proxy, then use its header for IP
	if common.Config.TrustProxy && isTrustedProxy(clientIP) {
		headerVal := ctx.Header(common.Config.TrustProxyHeader)
		if headerVal != "" {
			parts := strings.Split(headerVal, ",")
			// first proxy ip, ignoring any hops
			first := strings.TrimSpace(parts[0])
			if net.ParseIP(first) != nil {
				clientIP = first
			}
		}
	}

	next(huma.WithValue(ctx, ctxKeyClientIP{}, clientIP))
}

// Returns the resolved client IP taking into account proxies.
func GetClientIP(ctx context.Context) string {
	ip, _ := ctx.Value(ctxKeyClientIP{}).(string)
	return ip
}
