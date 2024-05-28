package main

import (
	"os"

	"github.com/flixurapp/flixur/pluginkit"
	protobuf "github.com/flixurapp/flixur/proto/go"
	"github.com/oklog/ulid/v2"
	"github.com/rs/zerolog"
	"github.com/rs/zerolog/log"
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

	log.Info().Msg("Initializing plugin...")

	if err := pluginkit.WriteMessage(&protobuf.PluginPacket{
		Id:   ulid.Make().String(),
		Type: protobuf.PacketType_INFO,
	}, &INFO, os.Stdout); err != nil {
		log.Err(err).Msg("Failed to write info packet.")
		panic(0)
	}
}
