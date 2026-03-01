package pluginkit

import (
	"os"

	"github.com/hashicorp/go-hclog"
	"github.com/hashicorp/go-plugin"
	"github.com/rs/zerolog"
)

// Serve the plugin using a custom log level. (if you arent using zerolog)
func ServeWithLevel(impl FlixurPlugin, logLevel hclog.Level) {
	plugin.Serve(&plugin.ServeConfig{
		HandshakeConfig: HandshakeConfig,
		Plugins: map[string]plugin.Plugin{
			"flixur_plugin": &FlixurGRPCPlugin{Impl: impl},
		},
		GRPCServer: plugin.DefaultGRPCServer,
		// from the official library, just increasing log level to Debug instead of Trace
		Logger: hclog.New(&hclog.LoggerOptions{
			Level:  logLevel,
			Output: os.Stderr,
		}),
	})
}

// Serve is a convenience function for plugins. It sets up the go-plugin framework.
func Serve(impl FlixurPlugin) {
	ServeWithLevel(impl, ZerologLevelToHCLevel(zerolog.GlobalLevel()))
}
