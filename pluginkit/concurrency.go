package pluginkit

import (
	"fmt"
	"io"
	"slices"

	protobuf "github.com/flixurapp/flixur/proto/go"
	"github.com/oklog/ulid/v2"
	"google.golang.org/protobuf/proto"
)

type HeldCallback struct {
	RequestID string
	Callback  func(proto.Message)
}

type PacketListener struct {
	Type     protobuf.PacketType
	Callback func(proto.Message, *protobuf.PluginPacket)
}
type PacketListenerAdder = func(PacketListener)

var callbacks []HeldCallback = make([]HeldCallback, 0)

func SendPacket[T proto.Message](stream io.Writer, packetType protobuf.PacketType, message proto.Message, callback func(res T)) {
	pkt := &protobuf.PluginPacket{
		Type: packetType,
		Id:   ulid.Make().String(),
	}
	WriteMessage(pkt, message, stream)
	callbacks = append(callbacks, HeldCallback{
		RequestID: pkt.Id,
		Callback: func(_res proto.Message) {
			// assert type of res
			if res, ok := _res.(T); ok {
				callback(res)
			}
		},
	})
}

// Start reading packets on `stream`.
// Returned function can be used to add listeners for new packets.
func StartReadingPackets(stream io.Reader, errors func(error)) PacketListenerAdder {
	var listeners []PacketListener = make([]PacketListener, 0)

	go func() {
		for {
			packet, data, err := ReadMessage[*protobuf.PacketInit](stream)
			if err != nil {
				// continue if no packet to read
				if err == io.EOF {
					continue
				}
				if err == io.ErrClosedPipe {
					errors(fmt.Errorf("plugin stream closed: %w", err))
					return
				}
				errors(err)
				continue
			}

			for i, cb := range callbacks {
				if cb.RequestID == packet.Id {
					cb.Callback(data)
					callbacks = slices.Delete(callbacks, i, i+1)
					break
				}
			}
			for _, li := range listeners {
				if li.Type == packet.Type {
					li.Callback(data, packet)
				}
			}
		}
	}()

	return func(listener PacketListener) {
		listeners = append(listeners, listener)
	}
}

// Adds a packet listener to a `PacketListenerAdder`.
func AddPacketListener[T proto.Message](adder PacketListenerAdder, packetType protobuf.PacketType, callback func(T, *protobuf.PluginPacket)) {
	adder(PacketListener{
		Type: packetType,
		Callback: func(_res proto.Message, pkt *protobuf.PluginPacket) {
			// assert type of res
			if res, ok := _res.(T); ok {
				callback(res, pkt)
			}
		},
	})
}
