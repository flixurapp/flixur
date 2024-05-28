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
		bin := path.Join(pluginPath, name)
		InitPlugin(bin)
	}
}

func InitPlugin(bin string) {
	cmd := exec.CommandContext(context.Background(), bin)

	if err := cmd.Start(); err != nil {
		log.Err(err).Str("path", bin).Msg("Failed to load plugin.")
		return
	}

	reader, writer := io.Pipe()
	cmd.Stderr = os.Stdout // redirect logs to stdout
	cmd.Stdout = writer

	go cmd.Wait()

	pluginkit.WriteMessage(
		&protobuf.PluginPacket{
			Id:   "0",
			Type: protobuf.PacketType_INIT,
		},
		&protobuf.PacketInit{
			Version: 0,
		}, writer)
	pluginkit.ReadMessage(reader)
}
