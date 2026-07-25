package common

import (
	"reflect"

	"github.com/caarlos0/env/v11"
	"github.com/rs/zerolog"
	"github.com/rs/zerolog/log"
)

type logLevel struct {
	Value zerolog.Level
}

type config struct {
	// IP address for the server to listen on.
	Address string `env:"ADDRESS" envDefault:"0.0.0.0"`
	// Port for the server to listen on.
	Port int `env:"PORT" envDefault:"8787"`
	// The log level for both server and (most official) spawned plugins.
	//TODO: change default to info for prod
	LogLevel logLevel `env:"LOG_LEVEL" envDefault:"trace"` // realistically this should never change so plugins remain compatible
	// Path to the directory to serve the flutter frontend from.
	// If omitted, the server will not serve a frontend.
	FrontendDir string `env:"FRONTEND_DIR"`
	// Path to the directory to scan for plugins.
	PluginDir string `env:"PLUGIN_DIR" envDefault:"./plugins"`

	/* These are more for development and not really for configuring the server itself. */
	// Runs the server in development mode, some features may act differently.
	DevelopmentMode bool `env:"DEVELOPMENT_MODE" envDefault:"false"`
	// Runs the server in a minimal "generator" mode which is used for the OpenAPI spec generation. Most features are disabled.
	GeneratorMode bool `env:"DEVELOPMENT_RUN_AS_GENERATOR" envDefault:"false"`
}

var Config config

func ParseConfig() {
	err := env.ParseWithOptions(&Config, env.Options{
		Prefix: "FLIXUR_",
		FuncMap: map[reflect.Type]env.ParserFunc{
			// special function to handle log level setting
			reflect.TypeFor[logLevel](): func(v string) (any, error) {
				lvl, err := zerolog.ParseLevel(v)
				if err != nil {
					return nil, err
				}
				// set the log level here so the config trace is properly recorded
				zerolog.SetGlobalLevel(lvl)
				return logLevel{Value: lvl}, nil
			},
		},
	})
	if err != nil {
		log.Err(err).Msg("Failed to parse env variables.")
	} else {
		log.Trace().Msg("Successfully parsed env variables.")
	}
}
