package api

import (
	"context"
	"fmt"

	"github.com/danielgtaylor/huma/v2"
	"github.com/danielgtaylor/huma/v2/adapters/humachi"
	"github.com/go-chi/chi/v5"
	"github.com/go-chi/cors"

	_ "github.com/danielgtaylor/huma/v2/formats/cbor"
)

// base reusable structs

type InputSearchParams struct {
	Query string `json:"query" example:"Jerry Springer" minLength:"1" maxLength:"250"`
}
type InputLimitParams struct {
	Limit int `json:"limit" default:"10" example:"100" minimum:"1" maximum:"100"`
}
type InputPluginParamsOptional struct {
	Plugin string `json:"plugin,omitempty" doc:"Plugin ID to use for the request. Omit to use the local server."`
}

// GreetingOutput represents the greeting operation response.
type GreetingOutput struct {
	Body struct {
		Message string `json:"message" example:"Hello, world!" doc:"Greeting message"`
	}
}

func RegisterAPI(router chi.Router) {
	config := huma.DefaultConfig("Flixur API", "0.0.1")
	config.Servers = []*huma.Server{{URL: "/api"}}

	router.Route("/api", func(r chi.Router) {
		// allow CORS on api routes (so other clients can connect)
		r.Use(cors.Handler(cors.Options{
			AllowedOrigins: []string{"https://*", "http://*"},
			AllowedMethods: []string{"GET", "POST", "PUT", "DELETE", "OPTIONS"},
			AllowedHeaders: []string{"Accept", "Authorization", "Content-Type", "X-CSRF-Token"},
			MaxAge:         300,
		}))

		api := humachi.New(r, config)

		RegisterMusicArtistsAPI(api)

		//TODO:testing
		// Register GET /greeting/{name} handler.
		huma.Get(api, "/greeting/{name}", func(ctx context.Context, input *struct {
			Name string `path:"name" maxLength:"30" example:"world" doc:"Name to greet"`
		}) (*GreetingOutput, error) {
			resp := &GreetingOutput{}
			resp.Body.Message = fmt.Sprintf("Hello, %s!", input.Name)
			return resp, nil
		})
	})
}
