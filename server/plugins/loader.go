package plugins

import (
	"context"
	"io"
	"os"
	"os/exec"
	"path/filepath"
	"strings"

	"github.com/flixurapp/flixur/pluginkit"
	protobuf "github.com/flixurapp/flixur/proto/go"
	"github.com/oklog/ulid/v2"
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
	readIn, writeIn := io.Pipe()
	readOut, writeOut := io.Pipe()

	cmd := exec.CommandContext(context.Background(), bin)
	cmd.Stderr = os.Stdout // redirect logs to stdout
	cmd.Stdin = readIn
	cmd.Stdout = writeOut

	if err := cmd.Start(); err != nil {
		log.Err(err).Str("path", bin).Msg("Failed to load plugin.")
		return
	}
	log.Debug().Str("path", bin).Msg("Loading plugin binary...")
	go (func() {
		cmd.Wait()
		readIn.Close()
		writeIn.Close()
		readOut.Close()
		writeOut.Close()
	})()

	_, info, err := pluginkit.ReadMessage[*protobuf.PacketInfo](readOut)
	if err != nil {
		log.Err(err).Str("path", bin).Msg("Failed to read plugin info.")
		return
	}

	if FindPluginByID(info.Id) != nil {
		log.Warn().Str("id", info.Id).Interface("details", info).Msg("Plugin with the same ID already exists. Ignoring...")
		return
	}

	plugin := &Plugin{
		PacketInfo: info,
		Input:      writeIn,
		Output:     readOut,
	}
	Plugins[info.Id] = plugin
	log.Info().Str("id", info.Id).Int32("version", info.Version).Str("author", info.Author).Interface("features", info.Features).Msgf("Loaded plugin %s.", info.Name)

	// Initialize the plugin.
	pluginkit.WriteMessage(&protobuf.PluginPacket{
		Type: protobuf.PacketType_INIT,
		Id:   ulid.Make().String(),
	}, &protobuf.PacketInit{
		Version: 0,
	}, plugin.Input)

	// Start listening for packets.
	listener := pluginkit.StartReadingPackets(plugin.Output, func(err error) {
		log.Err(err).Str("id", info.Id).Msg("Failed to read packet from plugin.")
	})

	// testing:

	pluginkit.AddPacketListener(listener, protobuf.PacketType_FEATURE_RESPONSE,
		func(data *protobuf.PacketFeatureResponse, _ *protobuf.PluginPacket) {
			log.Info().Interface("d", data).Msg("packet from feature listener")
		})

	res, err := pluginkit.FeatureRequest[*protobuf.FeatureArtistSearchResponse](plugin.Input, protobuf.Features_ARTIST_SEARCH, &protobuf.FeatureArtistSearchRequest{
		Query: "frank sinatra",
	})

	log.Info().Interface("d", res.Results).Err(err).Msg("packet from callback")
}
