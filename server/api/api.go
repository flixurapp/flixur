package api

import (
	"forge.xela.codes/xela/flixur/ent"
	"github.com/danielgtaylor/huma/v2"
	"github.com/danielgtaylor/huma/v2/adapters/humachi"
	"github.com/go-chi/chi/v5"
	"github.com/go-chi/cors"

	_ "github.com/danielgtaylor/huma/v2/formats/cbor"
)

// struct of data passed to api builders
type APIRegistry struct {
	// Huma API instance.
	API huma.API
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

type OutputSuccess struct {
	Body struct {
		// If the request was successfully fulfilled.
		Success bool `json:"success"`
	}
}

func RegisterAPI(router chi.Router, client *ent.Client) {
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
		registry := APIRegistry{
			API:    api,
			DB:     client,
			Router: router,
		}

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
}
