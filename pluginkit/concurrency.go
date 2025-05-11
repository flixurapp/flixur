package pluginkit

import (
	"fmt"
	"io"
	"os"
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
					go func() {
						if err := cb.Callback(packet); err != nil {
							errors(fmt.Errorf("failed to run SendPacket callback: %w", err))
						}
						callbacks = slices.Delete(callbacks, i, i+1)
					}()
					break
				}
			}
			for _, li := range listeners {
				if li.Type == packet.Type {
					go func() {
						if err := li.Callback(packet); err != nil {
							errors(fmt.Errorf("failed to run PacketListener callback: %w", err))
						}
					}()
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
		Callback: func(packet *protobuf.PluginPacket) error {
			if res, err := DeserializeNested[T](packet.Data); err == nil {
				callback(res, packet)
				return nil
			} else {
				return err
			}
		},
	})
}

// Automatically listens for feature request packets for the specific feature.
func ImplementFeature[REQ proto.Message, RES proto.Message](adder PacketListenerAdder, feature protobuf.Features, callback func(REQ, *protobuf.PluginPacket) RES) {
	// Listen for feature requests.
	//TODO: use AddPacketListener instead? maybe ties into efficiency below
	adder(PacketListener{
		Type: protobuf.PacketType_FEATURE_REQUEST,
		Callback: func(packet *protobuf.PluginPacket) error {
			if requestPacket, err := DeserializeNested[*protobuf.PacketFeatureRequest](packet.Data); err == nil {
				//TODO: maybe theres a more efficient way to do this?
				// ignore any requests that do not match the given feature
				if feature != requestPacket.Feature {
					return nil
				}
				// deserialize the request payload
				if requestPayload, err := DeserializeNested[REQ](requestPacket.Payload); err == nil {
					response := callback(requestPayload, packet)
					if any(response) != nil {
						if payload, err := proto.Marshal(response); err == nil {
							WriteMessage(&protobuf.PluginPacket{
								Id:   packet.Id,
								Type: protobuf.PacketType_FEATURE_RESPONSE,
							},
								&protobuf.PacketFeatureResponse{
									Feature: feature,
									Payload: payload,
									//TODO: allow choosing other writers than STDOUT?
								}, os.Stdout)
						} else {
							return fmt.Errorf("failed to serialize feature payload: %w", err)
						}
					}
					return nil
				} else {
					return err
				}
			} else {
				return err
			}
		},
	})
}

func FeatureRequest[REQ proto.Message, RES proto.Message](stream io.Writer, feature protobuf.Features, request REQ, callback func(RES, error)) {
	// only way i could think of doing this
	var undefined *RES = nil
	payload, err := proto.Marshal(request)
	if err != nil {
		callback(*undefined, fmt.Errorf("failed to serialize feature request payload: %w", err))
		return
	}
	SendPacket(stream, protobuf.PacketType_FEATURE_REQUEST, &protobuf.PacketFeatureRequest{
		Feature: feature,
		Payload: payload,
	}, func(res *protobuf.PacketFeatureResponse) {
		if payload, err := DeserializeNested[RES](res.Payload); err == nil {
			callback(payload, nil)
		} else {
			callback(*undefined, err)
		}
	})
}
