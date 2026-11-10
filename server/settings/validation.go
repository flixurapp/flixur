// Validation of setting values against their definitions.
package settings

import (
	"encoding/json"
	"errors"
	"fmt"
	"slices"
)

// Encode a value to the JSON text used for storage.
func Encode(value any) (string, error) {
	raw, err := json.Marshal(value)
	if err != nil {
		return "", err
	}
	return string(raw), nil
}

// Validates JSON-encoded text against the given setting definition.
// Returns a re-[Encode]d value on success.
func ValidateValue(def *SettingsDefinition, text string) (string, error) {
	if !json.Valid(json.RawMessage(text)) {
		return "", errors.New("value is not valid JSON")
	}

	switch def.Kind {
	case KindBool:
		var value bool
		if err := json.Unmarshal([]byte(text), &value); err != nil {
			return "", errors.New("value must be a boolean")
		}
		return Encode(value)

	case KindInt:
		var value float64
		if err := json.Unmarshal([]byte(text), &value); err != nil || value != float64(int64(value)) {
			return "", errors.New("value must be an integer")
		}
		result := int64(value)
		if p := def.Int; p != nil {
			if p.Min != nil && result < *p.Min {
				return "", fmt.Errorf("value must be at least %d", *p.Min)
			}
			if p.Max != nil && result > *p.Max {
				return "", fmt.Errorf("value must be no more than %d", *p.Max)
			}
		}
		return Encode(result)

	case KindFloat:
		var value float64
		if err := json.Unmarshal([]byte(text), &value); err != nil {
			return "", errors.New("value must be a number")
		}
		if p := def.Float; p != nil {
			if p.Min != nil && value < *p.Min {
				return "", fmt.Errorf("value must be at least %g", *p.Min)
			}
			if p.Max != nil && value > *p.Max {
				return "", fmt.Errorf("value must be no more than %g", *p.Max)
			}
		}
		return Encode(value)

	case KindString:
		var value string
		if err := json.Unmarshal([]byte(text), &value); err != nil {
			return "", errors.New("value must be a string")
		}
		if p := def.String; p != nil && p.MaxLength != nil && len(value) > *p.MaxLength {
			return "", fmt.Errorf("value must be no more than %d characters", *p.MaxLength)
		}
		return Encode(value)

	case KindEnum:
		var value string
		if err := json.Unmarshal([]byte(text), &value); err != nil {
			return "", errors.New("value must be a string")
		}
		if def.Enum == nil || len(def.Enum.Choices) == 0 {
			return "", errors.New("definition has no choices")
		}
		if slices.Contains(choiceValues(def.Enum.Choices), value) {
			return Encode(value)
		}
		return "", errors.New("value is not a valid choice")

	case KindStringList:
		var value []string
		if err := json.Unmarshal([]byte(text), &value); err != nil {
			return "", errors.New("value must be an array of strings")
		}
		if value == nil {
			value = []string{}
		}
		if p := def.StringList; p != nil && p.MaxItems != nil && len(value) > *p.MaxItems {
			return "", fmt.Errorf("value must have no more than %d items", *p.MaxItems)
		}
		return Encode(value)
	}

	return "", fmt.Errorf("unknown setting kind: %s", def.Kind)
}
