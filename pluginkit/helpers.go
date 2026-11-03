package pluginkit

import (
	"embed"
	"encoding/json"
	"fmt"
	"os"

	"github.com/hashicorp/go-hclog"
	"github.com/rs/zerolog"
	"github.com/rs/zerolog/log"
)

// Convenience function to load the plugin manifest from a go:embed.
func LoadPluginManifest(fs embed.FS) PluginManifest {
	raw, err := fs.ReadFile("manifest.json")
	if err != nil {
		panic(fmt.Sprintf("reading embedded manifest.json: %v", err))
	}
	var m PluginManifest
	if err := json.Unmarshal(raw, &m); err != nil {
		panic(fmt.Sprintf("invalid manifest.json: %v", err))
	}
	return m
}

// Convenience function to set up a zerolog logger for the plugin.
func SetupPluginLogger(manifest *PluginManifest) {
	var logLevel zerolog.Level = zerolog.TraceLevel
	// this should be kept up-to-date with the server env var
	if env := os.Getenv("FLIXUR_LOG_LEVEL"); env != "" {
		logLevel, _ = zerolog.ParseLevel(env)
	}
	zerolog.SetGlobalLevel(logLevel)

	log.Logger = log.Output(zerolog.ConsoleWriter{
		Out:        os.Stderr,
		TimeFormat: "3:04:05PM",
		FormatMessage: func(i any) string {
			return fmt.Sprintf("[%s] %v", manifest.Id, i)
		},
	})
}

// Utility function to convert a zerolog log level to an hclogger level.
func ZerologLevelToHCLevel(level zerolog.Level) hclog.Level {
	switch level {
	case zerolog.TraceLevel:
		return hclog.Trace
	case zerolog.DebugLevel:
		return hclog.Debug
	case zerolog.InfoLevel:
		return hclog.Info
	case zerolog.WarnLevel:
		return hclog.Warn
	case zerolog.ErrorLevel:
	case zerolog.FatalLevel:
	case zerolog.PanicLevel:
		return hclog.Error
	case zerolog.Disabled:
		return hclog.Off
	case zerolog.NoLevel:
	default:
		return hclog.NoLevel
	}
	return hclog.NoLevel
}
