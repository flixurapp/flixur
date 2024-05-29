package main

import (
	"context"
	"io"
	"os"
	"os/exec"
	"path/filepath"
	"strings"

	"github.com/flixurapp/flixur/pluginkit"
	protobuf "github.com/flixurapp/flixur/proto/go"
	"github.com/rs/zerolog/log"
	"google.golang.org/protobuf/proto"
)

type Plugin struct {
	*protobuf.PacketInfo
}

var Plugins []Plugin = make([]Plugin, 0)

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
	cmd := exec.CommandContext(context.Background(), bin)
	reader, writer := io.Pipe()
	cmd.Stderr = os.Stdout // redirect logs to stdout
	cmd.Stdout = writer

	if err := cmd.Start(); err != nil {
		log.Err(err).Str("path", bin).Msg("Failed to load plugin.")
		return
	}
	log.Debug().Str("path", bin).Msg("Loading plugin binary...")
	go (func() {
		cmd.Wait()
		reader.Close()
		writer.Close()
	})()

	_, info, err := pluginkit.ReadMessage[*protobuf.PacketInfo](reader)
	if err != nil {
		log.Err(err).Str("path", bin).Msg("Failed to read plugin info.")
		return
	}

	for _, plugin := range Plugins {
		if plugin.Id == info.Id {
			log.Warn().Str("id", info.Id).Interface("details", info).Msg("Plugin with the same ID already exists. Ignoring...")
			return
		}
	}

	Plugins = append(Plugins, Plugin{
		PacketInfo: info,
	})
	log.Info().Str("id", info.Id).Str("version", info.Version).Str("author", info.Author).Msgf("Loaded plugin %s.", info.Name)

	SendPacket(protobuf.PacketType_ARTIST_SEARCH, &protobuf.PacketArtistSearch{
		Query: "artist name",
	}, func(res *protobuf.PacketArtistSearchResult) {
		// Handle response
	})

	/* init plugin
	if err := pluginkit.WriteMessage(
		&protobuf.PluginPacket{
			Id:   "0",
			Type: protobuf.PacketType_INIT,
		},
		&protobuf.PacketInit{
			Version: 0,
		}, cmd.Stdout); err != nil {
		log.Err(err).Str("path", bin).Msg("Failed to init plugin.")
		return
	}
	*/
}

func SendPacket[T proto.Message](packetType protobuf.PacketType, message proto.Message, callback func(res T)) {

}
