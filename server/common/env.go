package common

import (
	"github.com/caarlos0/env/v11"
	"github.com/rs/zerolog/log"
)

type config struct {
	// IP address for the server to listen on.
	Address string `env:"ADDRESS" envDefault:"0.0.0.0"`
	// Port for the server to listen on.
	Port int `env:"PORT" envDefault:"8787"`
}

var Config config

func ParseConfig() {
	err := env.ParseWithOptions(&Config, env.Options{
		Prefix: "FLIXUR_",
	})
	if err != nil {
		log.Err(err).Msg("Failed to parse env variables.")
	} else {
		log.Trace().Msg("Successfully parsed env variables.")
	}
}
