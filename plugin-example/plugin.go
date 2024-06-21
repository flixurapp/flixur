package main

import (
	"fmt"
	"os"
	"sync"

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
		FormatMessage: func(i interface{}) string {
			return fmt.Sprintf("[%s] %s", INFO.Id, i)
		},
	})

	log.Info().Msg("Initializing plugin...")

	if err := pluginkit.WriteMessage(&protobuf.PluginPacket{
		Id:   ulid.Make().String(),
		Type: protobuf.PacketType_INFO,
	}, &INFO, os.Stdout); err != nil {
		log.Err(err).Msg("Failed to write info packet.")
		panic(0)
	}

	listener := pluginkit.StartReadingPackets(os.Stdin, func(err error) {
		log.Err(err).Msg("Failed to read packet from stdin.")
	})
	pluginkit.AddPacketListener(listener, protobuf.PacketType_ARTIST_SEARCH, func(data *protobuf.PacketArtistSearch, pkt *protobuf.PluginPacket) {
		log.Info().Interface("d", data).Msg("plugin got packet")

		pluginkit.WriteMessage(&protobuf.PluginPacket{
			Id:   pkt.Id,
			Type: protobuf.PacketType_ARTIST_SEARCH_RESULT,
		},
			&protobuf.PacketArtistSearchResult{
				Results: make([]*protobuf.Artist, 0),
			}, os.Stdout)
	})

	// never exit
	var wg sync.WaitGroup
	wg.Add(1)
	wg.Wait()
}
