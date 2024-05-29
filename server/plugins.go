package main

import (
	"context"
	"io"
	"os"
	"os/exec"
	"path"
	"strings"

	"github.com/flixurapp/flixur/pluginkit"
	protobuf "github.com/flixurapp/flixur/proto/go"
	"github.com/rs/zerolog/log"
	"google.golang.org/protobuf/proto"
)

type Plugin struct {
	protobuf.PacketInfo

	SendPacket func(packetType protobuf.PacketType, message proto.Message, callback func(res proto.Message))
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
		bin := path.Join(pluginPath, name)
		InitPlugin(bin)
	}
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

	log.Info().Str("id", info.Id).Str("version", info.Version).Str("author", info.Author).Msgf("Loaded plugin %s.", info.Name)

	//Plugins[0].SendPacket(protobuf.PacketType_ARTIST_SEARCH, &protobuf.PacketArtistSearch{
	//	Query: "artist name",
	//})

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
