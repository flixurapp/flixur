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
	Callback  func(*protobuf.PluginPacket) error
}

type PacketListener struct {
	Type     protobuf.PacketType
	Callback func(*protobuf.PluginPacket) error
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
		Callback: func(pkt *protobuf.PluginPacket) error {
			if res, err := DeserializeNested[T](pkt.Data); err == nil {
				callback(res)
				return nil
			} else {
				return err
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
			// the data gets deserialized into a generic packet, which we don't need
			packet, _, err := ReadMessage[*protobuf.PluginPacket](stream)
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
					if err := cb.Callback(packet); err != nil {
						errors(fmt.Errorf("failed to run SendPacket callback: %w", err))
					}
					callbacks = slices.Delete(callbacks, i, i+1)
					break
				}
			}
			for _, li := range listeners {
				if li.Type == packet.Type {
					if err := li.Callback(packet); err != nil {
						errors(fmt.Errorf("failed to run PacketListener callback: %w", err))
					}
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
		Callback: func(pkt *protobuf.PluginPacket) error {
			if res, err := DeserializeNested[T](pkt.Data); err == nil {
				callback(res, pkt)
				return nil
			} else {
				return err
			}
		},
	})
}
