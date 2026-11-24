package settings

import (
	"fmt"

	pb "forge.xela.codes/xela/flixur/pluginkit/proto"
)

// Encodes the definition's default value into JSON.
func DefaultText(def *pb.SettingsDefinition) (string, error) {
	switch def.Kind {
	case pb.Kind_BOOL:
		var value bool
		if p := def.Bool; p != nil {
			value = p.DefaultValue
		}
		return Encode(value)

	case pb.Kind_INT:
		var value int64
		if p := def.Int; p != nil {
			value = p.DefaultValue
		}
		return Encode(value)

	case pb.Kind_FLOAT:
		var value float64
		if p := def.Float; p != nil {
			value = p.DefaultValue
		}
		return Encode(value)

	case pb.Kind_STRING:
		var value string
		if p := def.String_; p != nil {
			value = p.DefaultValue
		}
		return Encode(value)

	case pb.Kind_ENUM:
		var value string
		if p := def.Enum; p != nil {
			value = p.DefaultValue
		}
		return Encode(value)

	case pb.Kind_STRINGLIST:
		var value []string
		if p := def.StringList; p != nil {
			value = p.DefaultValue
		}
		if value == nil {
			value = []string{}
		}
		return Encode(value)
	}

	return "", fmt.Errorf("unknown setting kind: %s", kindName(def.Kind))
}

// Whether the JSON-encoded value text equals the definition's default value.
func IsDefaultValue(def *pb.SettingsDefinition, text string) bool {
	defText, err := DefaultText(def)
	if err != nil {
		return false
	}
	return text == defText
}
