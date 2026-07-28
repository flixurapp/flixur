package main

import (
	"context"
	"fmt"
	"io/fs"
	"net"
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

// Allows tests to replace os.Exit when calling main().
var exitFunc = os.Exit

func main() {
	if err := runServer(); err != nil {
		log.Error().Err(err).Msg("Server failed.")
		exitFunc(1)
	}
}

// Basically the main function.
func runServer() error {
	setupLogger()
	if err := common.ParseConfig(); err != nil {
		return err
	}

	// set up database
	client, err := openDatabase()
	if err != nil {
		return err
	}
	defer client.Close()

	router := buildRouter(client)

	if common.Config.DevelopmentMode {
		log.Info().Msg("Running in development mode.")
	}

	if !common.Config.GeneratorMode {
		// finish setting up the database
		log.Info().Msg("Initializing database...")
		// run migrations
		if err := client.Schema.Create(context.Background()); err != nil {
			return fmt.Errorf("failed creating schema resources: %w", err)
		}
		// load setup state
		if err := api.LoadServerSetupState(context.Background(), client); err != nil {
			return fmt.Errorf("failed loading server setup state: %w", err)
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
			defer serveFrontend(router, dir)()
		} else {
			log.Warn().Msg("Not serving the frontend as no frontend path was provided.")
		}
	}

	return serveFunc(router, nil, nil)
}

// Overridable function to start listening to the server.
var serveFunc = serve

func setupLogger() {
	// log traces until we init the logger and config
	// ParseConfig will set the new log level from the config later on
	zerolog.SetGlobalLevel(zerolog.TraceLevel)
	log.Logger = log.Output(zerolog.ConsoleWriter{
		Out:        os.Stdout,
		TimeFormat: "3:04:05PM",
	})
}

func openDatabase() (*ent.Client, error) {
	//TODO: eventually use postgres
	// https://entgo.io/docs/getting-started/#create-your-first-entity
	client, err := ent.Open("sqlite3", "file:ent?mode=memory&cache=shared&_fk=1")
	if err != nil {
		return nil, fmt.Errorf("failed opening connection to database: %w", err)
	}
	return client, nil
}

func buildRouter(client *ent.Client) chi.Router {
	// set up router and middlewares
	router := chi.NewMux()
	router.Use(middleware.Compress(5))
	router.Use(middleware.Recoverer)
	router.Use(middleware.RequestID)

	// init api
	api.RegisterAPI(router, client)

	return router
}

// Serves the frontend files, returns a cleanp function.
func serveFrontend(router chi.Router, dir string) func() {
	// use root to prevent symlink traversal
	root, err := os.OpenRoot(dir)
	if err != nil {
		log.Err(err).Msg("Failed to open frontend directory.")
		return func() {}
	}

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
	return func() { root.Close() }
}

func serve(router chi.Router, sigs <-chan os.Signal, ready chan<- struct{}) error {
	// create http server/channel and listen
	server := &http.Server{
		Addr:    fmt.Sprintf("%s:%d", common.Config.Address, common.Config.Port),
		Handler: router,
	}
	serverChan := make(chan error, 1)
	go func() {
		log.Info().Str("address", common.Config.Address).Int("port", common.Config.Port).Msg("Server is online.")
		// channel passes any errors back to the signal handler
		ln, err := net.Listen("tcp", server.Addr)
		if err != nil {
			serverChan <- err
			return
		}
		if ready != nil {
			close(ready)
		}
		serverChan <- server.Serve(ln)
	}()

	var sigChan <-chan os.Signal
	if sigs != nil {
		sigChan = sigs
	} else {
		c := make(chan os.Signal, 1)
		signal.Notify(c, syscall.SIGINT, syscall.SIGTERM)
		sigChan = c
	}

	// wait for either server error or stop signal
	var serveErr error
	select {
	case err := <-serverChan:
		if err != nil && err != http.ErrServerClosed {
			serveErr = err
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
	return serveErr
}
