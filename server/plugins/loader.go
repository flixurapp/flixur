package plugins

import (
	"context"
	"os"
	"os/exec"
	"path/filepath"
	"strings"

	"github.com/flixurapp/flixur/pluginkit"
	"github.com/hashicorp/go-plugin"
	"github.com/rs/zerolog/log"
)

func RegisterPlugins(pluginPath string) {
	dir, err := os.ReadDir(pluginPath)
	if err != nil {
		log.Err(err).Str("path", pluginPath).Msg("Failed to read plugin directory.")
		return
	}

	for _, file := range dir {
		name := file.Name()
		// ignore `.disabled` files
		if strings.HasSuffix(name, ".disabled") {
			continue
		}
		bin := filepath.Join(pluginPath, name)
		InitPlugin(bin)
	}
	log.Info().Msgf("Loaded %d plugins.", len(Plugins))
}

func InitPlugin(bin string) {
	log.Debug().Str("path", bin).Msg("Loading plugin binary...")

	// Create a new plugin client
	client := plugin.NewClient(&plugin.ClientConfig{
		HandshakeConfig:  pluginkit.HandshakeConfig,
		Plugins:          map[string]plugin.Plugin{"flixur_plugin": &pluginkit.FlixurGRPCPlugin{}},
		Cmd:              exec.Command(bin),
		AllowedProtocols: []plugin.Protocol{plugin.ProtocolGRPC},
		Stderr:           os.Stderr, // Plugin logs go to stderr
	})

	// Connect to the plugin
	rpcClient, err := client.Client()
	if err != nil {
		log.Err(err).Str("path", bin).Msg("Failed to connect to plugin.")
		client.Kill()
		return
	}

	// Dispense the plugin
	raw, err := rpcClient.Dispense("flixur_plugin")
	if err != nil {
		log.Err(err).Str("path", bin).Msg("Failed to dispense plugin.")
		client.Kill()
		return
	}

	flixurPlugin := raw.(pluginkit.FlixurPlugin)

	// Get plugin info
	ctx := context.Background()
	info, err := flixurPlugin.GetPluginInfo(ctx)
	if err != nil {
		log.Err(err).Str("path", bin).Msg("Failed to get plugin info.")
		client.Kill()
		return
	}

	// Check if plugin with same ID already exists
	if FindPluginByID(info.Id) != nil {
		log.Warn().Str("id", info.Id).Str("name", info.Name).Msg("Plugin with the same ID already exists. Ignoring...")
		client.Kill()
		return
	}

	// Register the plugin
	plugin := &Plugin{
		Info:    info,
		RPC:     flixurPlugin,
		destroy: client.Kill,
	}
	Plugins[info.Id] = plugin
	log.Info().Interface("info", info).Msg("Loaded plugin.")
}
