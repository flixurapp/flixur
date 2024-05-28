package main

import (
	"fmt"
	"net/http"
	"os"

	"github.com/flixurapp/flixur/api"
	"github.com/go-chi/chi/middleware"
	"github.com/go-chi/chi/v5"
	"github.com/rs/zerolog"
	"github.com/rs/zerolog/log"
)

var port = 8787

func main() {
	log.Logger = log.Output(zerolog.ConsoleWriter{
		Out:        os.Stdout,
		TimeFormat: "3:04:05PM",
	})

	router := chi.NewMux()
	router.Use(middleware.Compress(5))
	router.Use(middleware.Recoverer)
	router.Use(middleware.RequestID)
	router.Use(middleware.RequestID)

	api.RegisterAPI(router)

	if Dev {
		log.Info().Msg("Running in development mode.")
	}

	RegisterPlugins("/home/meow/Documents/flixur/test/plugins")

	log.Info().Int("port", port).Msg("Server is online.")
	http.ListenAndServe(fmt.Sprintf(":%d", port), router)
}
