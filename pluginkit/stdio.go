package pluginkit

import (
	"encoding/binary"
	"fmt"
	"io"
	"reflect"

	protobuf "github.com/flixurapp/flixur/proto/go"
	"google.golang.org/protobuf/proto"
)

// Deserialize nested packet data into the specified interface.
func DeserializeNested[T proto.Message](bytes []byte) (T, error) {
	var noop T

	data := reflect.New(reflect.TypeOf(T(noop)).Elem()).Interface().(T)
	if err := proto.Unmarshal(bytes, data); err != nil {
		return noop, err
	}

	return data, nil
}

// Reads a packet from a reader.
func ReadMessage[T proto.Message](stream io.Reader) (*protobuf.PluginPacket, T, error) {
	// this is the only way i could think to do this, i dunno
	var noop T

	var packetLength uint32
	// get length of incoming packet
	if err := binary.Read(stream, binary.LittleEndian, &packetLength); err != nil {
		// if pipe is closed then notify
		// also notify on EOF
		if err == io.ErrClosedPipe || err == io.EOF {
			return nil, noop, err
		}
		return nil, noop, fmt.Errorf("failed to read length prefix: %w", err)
	}

	// read incoming packet
	buf := make([]byte, packetLength)
	if _, err := stream.Read(buf); err != nil {
		return nil, noop, fmt.Errorf("failed to read protobuf: %w", err)
	}

	// deserialize packet
	packet := &protobuf.PluginPacket{}
	if err := proto.Unmarshal(buf, packet); err != nil {
		return nil, noop, fmt.Errorf("failed to deserialize protobuf: %w", err)
	}

	data, err := DeserializeNested[T](packet.Data)
	if err != nil {
		return nil, noop, fmt.Errorf("failed to deserialize protobuf data: %w", err)
	}

	return packet, data, nil
}

// Writes a packet to a writer.
func WriteMessage(packet *protobuf.PluginPacket, message proto.Message, stream io.Writer) error {
	// serialize message
	nested, err := proto.Marshal(message)
	if err != nil {
		return fmt.Errorf("failed to serialize packet message: %w", err)
	}

	// overwrite packet data
	packet.Data = nested

	// serialize packet
	serialized, err := proto.Marshal(packet)
	if err != nil {
		return fmt.Errorf("failed to serialize packet: %w", err)
	}

	// calculate length of packet
	packetLength := uint32(len(serialized))

	// write length of packet
	if err := binary.Write(stream, binary.LittleEndian, packetLength); err != nil {
		return fmt.Errorf("failed to write length prefix: %w", err)
	}

	// write the packet
	if _, err := stream.Write(serialized); err != nil {
		return fmt.Errorf("failed to write packet: %w", err)
	}

	return nil
}
