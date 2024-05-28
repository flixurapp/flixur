package main

import (
	"os"

	"github.com/flixurapp/flixur/pluginkit"
	protobuf "github.com/flixurapp/flixur/proto/go"
	"github.com/rs/zerolog"
	"github.com/rs/zerolog/log"
	"google.golang.org/protobuf/proto"
)

var INFO = protobuf.PacketInfo{
	Id:          "example",
	Version:     "0.0.0",
	Type:        protobuf.PluginType_SERVER,
	Name:        "Example Plugin",
	Description: "Small example plugin.",
	Author:      "You",
}

func main() {
	log.Logger = log.Output(zerolog.ConsoleWriter{
		Out:        os.Stderr,
		TimeFormat: "3:04:05PM",
	}).With().Str("id", INFO.Id).Logger()

	init, err := pluginkit.ReadMessage(os.Stdin)

	//TODO: actually handle the errors
	if err != nil {
		log.Err(err).Msg("Failed to read init packet.")
		panic(0)
	}
	if init.Type != protobuf.PacketType_INIT {
		log.Error().Interface("type", init.Type).Msg("Initial packet is not INIT.")
		panic(0)
	}

	var data protobuf.PacketInit
	if err = proto.Unmarshal(init.Data, &data); err != nil {
		log.Err(err).Msg("Failed to deserialize init packet.")
		panic(0)
	}

	log.Info().Int32("server_version", data.Version).Msg("Plugin info was requested.")

	err = pluginkit.WriteMessage(&protobuf.PluginPacket{
		Id:   init.Id,
		Type: protobuf.PacketType_INFO,
	}, &INFO, os.Stdout)
	if err != nil {
		log.Err(err).Msg("Failed to write info packet.")
		panic(0)
	}
}
