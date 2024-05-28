package pluginkit

import (
	"encoding/binary"
	"fmt"
	"io"

	protobuf "github.com/flixurapp/flixur/proto/go"
	"google.golang.org/protobuf/proto"
)

// Reads a packet from a reader.
func ReadMessage(stream io.Reader) (*protobuf.IncomingPluginPacket, error) {
	// get length of incoming packet
	var messageLength uint32
	if err := binary.Read(stream, binary.LittleEndian, &messageLength); err != nil {
		return nil, fmt.Errorf("Failed to read length prefix: %w", err)
	}

	// read incoming packet
	buf := make([]byte, messageLength)
	if _, err := stream.Read(buf); err != nil {
		return nil, fmt.Errorf("Failed to read protobuf: %w", err)
	}

	// deserialize packet
	packet := &protobuf.IncomingPluginPacket{}
	if err := proto.Unmarshal(buf, packet); err != nil {
		return nil, fmt.Errorf("Failed to deserialize protobuf: %w", err)
	}

	return packet, nil
}
