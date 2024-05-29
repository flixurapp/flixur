package main

import (
	"fmt"
	"net/http"
	"os"
	"path/filepath"
	"strings"

	"github.com/flixurapp/flixur/api"
	"github.com/go-chi/chi/v5"
	"github.com/go-chi/chi/v5/middleware"
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

	// serves the client as static files
	cwd, _ := os.Getwd()
	if Dev {
		//TODO:temp  maybe do this better? good for testing for now
		cwd = filepath.Join(cwd, "../build")
	}
	serveDir := filepath.Join(cwd, "client")
	serve := http.Dir(serveDir)
	router.Get("/*", func(w http.ResponseWriter, r *http.Request) {
		rctx := chi.RouteContext(r.Context())
		pathPrefix := strings.TrimSuffix(rctx.RoutePattern(), "/*")
		fs := http.StripPrefix(pathPrefix, http.FileServer(serve))

		if _, err := os.Stat(filepath.Join(serveDir, r.RequestURI)); os.IsNotExist(err) {
			http.ServeFile(w, r, filepath.Join(serveDir, "index.html"))
			return
		}
		fs.ServeHTTP(w, r)
	})

	log.Info().Int("port", port).Msg("Server is online.")
	http.ListenAndServe(fmt.Sprintf(":%d", port), router)
}
