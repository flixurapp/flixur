package main

import (
	"context"
	"fmt"
	"io/fs"
	"net/http"
	"os"
	"os/signal"
	"path/filepath"
	"strings"
	"syscall"
	"time"

	"forge.xela.codes/xela/flixur/api"
	"forge.xela.codes/xela/flixur/common"
	"forge.xela.codes/xela/flixur/ent"
	"forge.xela.codes/xela/flixur/plugins"
	"github.com/go-chi/chi/v5"
	"github.com/go-chi/chi/v5/middleware"
	"github.com/rs/zerolog"
	"github.com/rs/zerolog/log"

	// ent isnt importing its runtime for some reason automatically
	_ "forge.xela.codes/xela/flixur/ent/runtime"
	_ "github.com/mattn/go-sqlite3"
)

func main() {
	// log traces until we init the logger and config
	zerolog.SetGlobalLevel(zerolog.TraceLevel)
	log.Logger = log.Output(zerolog.ConsoleWriter{
		Out:        os.Stdout,
		TimeFormat: "3:04:05PM",
	})
	// ParseConfig will set the new log level from the config
	common.ParseConfig()

	// set up database
	//TODO: eventually use postgres
	// https://entgo.io/docs/getting-started/#create-your-first-entity
	client, err := ent.Open("sqlite3", "file:ent?mode=memory&cache=shared&_fk=1")
	if err != nil {
		log.Fatal().Err(err).Msg("failed opening connection to sqlite: %v")
	}
	defer client.Close()

	// set up router and middlewares
	router := chi.NewMux()
	router.Use(middleware.Compress(5))
	router.Use(middleware.Recoverer)
	router.Use(middleware.RequestID)

	// init api
	api.RegisterAPI(router, client)

	if common.Config.DevelopmentMode {
		log.Info().Msg("Running in development mode.")
	}

	if !common.Config.GeneratorMode {
		// finish setting up the database
		log.Info().Msg("Initializing database...")
		// run migrations
		if err := client.Schema.Create(context.Background()); err != nil {
			log.Fatal().Err(err).Msg("failed creating schema resources: %v")
		}
		// load setup state
		if err := api.LoadServerSetupState(context.Background(), client); err != nil {
			log.Fatal().Err(err).Msg("failed loading server setup state: %v")
		}
		log.Info().Msg("Finished database initialization.")

		// load plugins
		pluginDir, err := filepath.Abs(common.Config.PluginDir)
		if err != nil {
			log.Err(err).Msg("Failed to resolve plugin directory.")
		} else {
			plugins.RegisterPlugins(pluginDir)
		}
		defer plugins.DestroyAllPlugins()

		// serve the frontend if available
		if dir := common.Config.FrontendDir; dir != "" {
			// use root to prevent symlink traversal
			root, err := os.OpenRoot(dir)
			if err != nil {
				log.Err(err).Msg("Failed to open frontend directory.")
			}
			defer root.Close()

			fsys := root.FS()
			fileServer := http.FileServer(http.FS(fsys))
			router.NotFound(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
				stat, err := fs.Stat(fsys, strings.TrimPrefix(r.URL.Path, "/"))
				switch {
				// serve actual files
				case err == nil && !stat.IsDir():
					fileServer.ServeHTTP(w, r)
					return
				case err == nil: // we arent listing directories
				default:
					// these just get the default index.html with the app
					r.URL.Path = "/"
					fileServer.ServeHTTP(w, r)
					return
				}
			}))
			log.Trace().Msgf("Serving frontend via '%s'.", dir)
		} else {
			log.Warn().Msg("Not serving the frontend as no frontend path was provided.")
		}
	}

	// create http server/channel and listen
	server := &http.Server{
		Addr:    fmt.Sprintf("%s:%d", common.Config.Address, common.Config.Port),
		Handler: router,
	}
	serverChan := make(chan error, 1)
	go func() {
		log.Info().Str("address", common.Config.Address).Int("port", common.Config.Port).Msg("Server is online.")
		// channel passes any errors back to the signal handler
		serverChan <- server.ListenAndServe()
	}()

	// catch stop signals from system
	sigChan := make(chan os.Signal, 1)
	signal.Notify(sigChan, syscall.SIGINT, syscall.SIGTERM)

	// wait for either server error or stop signal
	select {
	case err := <-serverChan:
		if err != nil && err != http.ErrServerClosed {
			log.Error().Err(err).Msg("Server error")
		}
	case sig := <-sigChan:
		log.Info().Stringer("signal", sig).Msg("Shutdown signal received, gracefully shutting down...")
	}

	// shut down HTTP server with 30sec timeout
	ctx, cancel := context.WithTimeout(context.Background(), 30*time.Second)
	defer cancel()
	if err := server.Shutdown(ctx); err != nil {
		log.Error().Err(err).Msg("Server shutdown error.")
	}

	log.Info().Msg("Goodbye.")
}
