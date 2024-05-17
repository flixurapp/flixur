package main

import (
	"context"
	"fmt"
	"net/http"

	"github.com/danielgtaylor/huma/v2"
	"github.com/danielgtaylor/huma/v2/adapters/humachi"
	"github.com/go-chi/chi/v5"

	_ "github.com/danielgtaylor/huma/v2/formats/cbor"
)

// GreetingOutput represents the greeting operation response.
type GreetingOutput struct {
	Body struct {
		Message string `json:"message" example:"Hello, world!" doc:"Greeting message"`
	}
}

func main() {
	// Create a new router & API.
	router := chi.NewMux()

	router.Route("/api", func(r chi.Router) {
		config := huma.DefaultConfig("Flixur API", "0.0.1")
		config.Servers = []*huma.Server{{URL: "/api"}}
		api := humachi.New(r, config)

		// Register GET /greeting/{name} handler.
		huma.Get(api, "/greeting/{name}", func(ctx context.Context, input *struct {
			Name string `path:"name" maxLength:"30" example:"world" doc:"Name to greet"`
		}) (*GreetingOutput, error) {
			resp := &GreetingOutput{}
			resp.Body.Message = fmt.Sprintf("Hello, %s!", input.Name)
			return resp, nil
		})
	})

	// Start the server!
	http.ListenAndServe("127.0.0.1:8888", router)
}
