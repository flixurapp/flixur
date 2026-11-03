package plugins

import (
	"fmt"
	"os"
	"os/exec"
	"path/filepath"

	"forge.xela.codes/xela/flixur/pluginkit"
	"github.com/hashicorp/go-hclog"
	"github.com/hashicorp/go-plugin"
	"github.com/rs/zerolog"
	"github.com/rs/zerolog/log"
)

// Base plugin client for test implementation.
type pluginClient interface {
	Client() (plugin.ClientProtocol, error)
	Kill()
}

// Create a production plugin client.
func newPluginClient(bin string) pluginClient {
	return plugin.NewClient(&plugin.ClientConfig{
		HandshakeConfig:  pluginkit.HandshakeConfig,
		Plugins:          map[string]plugin.Plugin{"flixur_plugin": &pluginkit.FlixurGRPCPlugin{}},
		Cmd:              exec.Command(bin),
		AllowedProtocols: []plugin.Protocol{plugin.ProtocolGRPC},
		Stderr:           os.Stderr, // passthrough plugin stderr
		Logger: hclog.New(&hclog.LoggerOptions{
			Name:   "plugin",
			Level:  pluginkit.ZerologLevelToHCLevel(zerolog.GlobalLevel()),
			Output: os.Stderr,
			SubloggerHook: func(sub hclog.Logger) hclog.Logger {
				// override the internal logger that forwards stderr
				if sub.Name() == fmt.Sprintf("plugin.%s", filepath.Base(bin)) {
					// since logs are already passed to parent stderr, turn it off
					return hclog.New(&hclog.LoggerOptions{Level: hclog.Off})
				} else {
					return sub
				}
			},
		}),
	})
}

// Creates a pluginClient for a given binary path, overridable for tests.
var pluginClientFactory = newPluginClient

func RegisterPlugins(pluginPath string) {
	dir, err := os.ReadDir(pluginPath)
	if err != nil {
		log.Err(err).Str("path", pluginPath).Msg("Failed to read plugin directory.")
		return
	}

	for _, file := range dir {
		name := file.Name()
		// only load `.json` manifest files
		if file.IsDir() || filepath.Ext(name) != ".json" {
			continue
		}
		data, err := os.ReadFile(filepath.Join(pluginPath, name))
		if err != nil {
			log.Err(err).Str("path", name).Msg("Failed to read plugin manifest.")
			continue
		}
		manifest, err := pluginkit.ParsePluginManifest(data)
		if err != nil {
			log.Err(err).Str("path", name).Msg("Failed to parse plugin manifest.")
			continue
		}
		InitPlugin(manifest)
	}
	log.Info().Msgf("Loaded %d plugins.", len(Plugins))
}

func InitPlugin(manifest *pluginkit.PluginManifest) {
	initPlugin(manifest, pluginClientFactory)
}

func initPlugin(manifest *pluginkit.PluginManifest, factory func(string) pluginClient) {
	if manifest.Binary == "" {
		log.Warn().Str("id", manifest.Id).Str("name", manifest.Name).Msg("Plugin manifest has no binary path. Ignoring...")
		return
	}

	log.Debug().Str("id", manifest.Id).Str("path", manifest.Binary).Msg("Loading plugin binary...")

	client := factory(manifest.Binary)

	// Connect to the plugin
	rpcClient, err := client.Client()
	if err != nil {
		log.Err(err).Str("path", manifest.Binary).Msg("Failed to connect to plugin.")
		client.Kill()
		return
	}

	// Dispense the plugin
	raw, err := rpcClient.Dispense("flixur_plugin")
	if err != nil {
		log.Err(err).Str("path", manifest.Binary).Msg("Failed to dispense plugin.")
		client.Kill()
		return
	}

	flixurPlugin := raw.(pluginkit.FlixurPlugin)

	// Check if plugin with same ID already exists
	if FindPluginByID(manifest.Id) != nil {
		log.Warn().Str("id", manifest.Id).Str("name", manifest.Name).Msg("Plugin with the same ID already exists. Ignoring...")
		client.Kill()
		return
	}

	// Register the plugin
	plugin := &Plugin{
		Manifest: manifest,
		RPC:      flixurPlugin,
		destroy:  client.Kill,
	}
	Plugins[manifest.Id] = plugin
	log.Info().Interface("info", manifest).Msg("Loaded plugin.")
}
