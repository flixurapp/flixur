package main

import (
	"embed"
	"fmt"
	"io/fs"
	"net/http"
	"os"
	"path/filepath"
	"strings"

	"github.com/flixurapp/flixur/api"
	"github.com/flixurapp/flixur/common"
	"github.com/flixurapp/flixur/plugins"
	"github.com/go-chi/chi/v5"
	"github.com/go-chi/chi/v5/middleware"
	"github.com/rs/zerolog"
	"github.com/rs/zerolog/log"

	_ "embed"
)

var port = 8787

//go:embed static/*
var static embed.FS

type spaFileSystem struct {
	fs       http.FileSystem
	fallback string
}

func (spa spaFileSystem) Open(name string) (http.File, error) {
	// Strip leading slash (if any)
	name = strings.TrimPrefix(name, "/")

	// Try to open the requested file
	file, err := spa.fs.Open(name)
	if err != nil {
		// If file not found, fall back to index.html
		return spa.fs.Open(spa.fallback)
	}

	// Check if it's a directory and return index.html if it is
	stat, err := file.Stat()
	if err == nil && stat.IsDir() {
		return spa.fs.Open(spa.fallback)
	}

	// Return the found file
	return file, nil
}

func main() {
	log.Logger = log.Output(zerolog.ConsoleWriter{
		Out:        os.Stdout,
		TimeFormat: "3:04:05PM",
	})

	router := chi.NewMux()
	router.Use(middleware.Compress(5))
	router.Use(middleware.Recoverer)
	router.Use(middleware.RequestID)

	api.RegisterAPI(router)

	if common.Dev {
		log.Info().Msg("Running in development mode.")
	}

	cwd, _ := os.Getwd()
	pluginDir := cwd
	if common.Dev {
		//TODO:temp  maybe do this better? good for testing for now
		pluginDir = filepath.Join(pluginDir, "../test")
	}
	pluginDir = filepath.Join(pluginDir, "plugins")
	plugins.RegisterPlugins(pluginDir)

	// serves the client as static files

	serveDir := cwd
	if common.Dev {
		//TODO:temp  maybe do this better? good for testing for now
		serveDir = filepath.Join(serveDir, "../build")
	}
	serveDir = filepath.Join(serveDir, "client")
	serve := http.Dir(serveDir)

	staticSub, _ := fs.Sub(static, "static")
	fileServer := http.FileServer(spaFileSystem{
		fs:       http.FS(staticSub),
		fallback: "index.html",
	})
	if common.Dev {
		fileServer = http.FileServer(serve)
	}

	router.Get("/*", func(w http.ResponseWriter, r *http.Request) {
		if r.URL.Path == "/" {
			http.ServeFileFS(w, r, staticSub, "index.html")
		} else {
			rctx := chi.RouteContext(r.Context())
			pathPrefix := strings.TrimSuffix(rctx.RoutePattern(), "/*")
			fs := http.StripPrefix(pathPrefix, fileServer)

			fs.ServeHTTP(w, r)
		}
	})

	log.Info().Int("port", port).Msg("Server is online.")
	http.ListenAndServe(fmt.Sprintf(":%d", port), router)
}
