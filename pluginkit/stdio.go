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
	var packetLength uint32
	// get length of incoming packet
	if err := binary.Read(stream, binary.LittleEndian, packetLength); err != nil {
		return nil, fmt.Errorf("Failed to read length prefix: %w", err)
	}

	// read incoming packet
	buf := make([]byte, packetLength)
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

// Writes a packet to a writer.
func WriteMessage(message proto.Message, stream io.Writer) error {
	// serialize packet
	serialized, err := proto.Marshal(message)
	if err != nil {
		return fmt.Errorf("Failed to serialize packet: %w", err)
	}

	// calculate length of packet
	packetLength := uint32(len(serialized))

	// write length of packet
	if err := binary.Write(stream, binary.LittleEndian, packetLength); err != nil {
		return fmt.Errorf("Failed to write length prefix: %w", err)
	}

	// write the packet
	if _, err := stream.Write(serialized); err != nil {
		return fmt.Errorf("Failed to write packet: %w", err)
	}

	return nil
}
