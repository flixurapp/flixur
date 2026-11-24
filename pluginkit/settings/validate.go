// Validation of setting definitions and values against their properties.
package settings

import (
	"fmt"
	"slices"
	"strings"

	pb "forge.xela.codes/xela/flixur/pluginkit/proto"
)

// Validates the definition, fixing up the kind when omitted.
// Returns an error when the definition is malformed.
func validateDef(def *pb.SettingsDefinition) error {
	var kind pb.Kind
	count := 0
	if def.Bool != nil {
		kind = pb.Kind_BOOL
		count++
	}
	if def.Int != nil {
		kind = pb.Kind_INT
		count++
	}
	if def.Float != nil {
		kind = pb.Kind_FLOAT
		count++
	}
	if def.String_ != nil {
		kind = pb.Kind_STRING
		count++
	}
	if def.Enum != nil {
		kind = pb.Kind_ENUM
		count++
	}
	if def.StringList != nil {
		kind = pb.Kind_STRINGLIST
		count++
	}
	if count != 1 {
		return fmt.Errorf("setting %s must have exactly one props struct, has %d", def.Id, count)
	}
	if def.Kind == pb.Kind_UNSPECIFIED {
		def.Kind = kind
	} else if def.Kind != kind {
		return fmt.Errorf("setting %s kind %s does not match its props", def.Id, kindName(def.Kind))
	}

	switch {
	case def.Int != nil:
		validateNumberBounds(def.Id, def.Int.Min, def.Int.Max, def.Int.RecommendedMin, def.Int.RecommendedMax)
	case def.Float != nil:
		validateNumberBounds(def.Id, def.Float.Min, def.Float.Max, def.Float.RecommendedMin, def.Float.RecommendedMax)
	case def.Enum != nil:
		if len(def.Enum.Choices) == 0 {
			return fmt.Errorf("enum setting has no choices: %s", def.Id)
		}
		// empty default uses first choice as fallback
		if def.Enum.DefaultValue == "" && !slices.Contains(choiceValues(def.Enum.Choices), "") {
			def.Enum.DefaultValue = def.Enum.Choices[0].Value
		}
		if !slices.Contains(choiceValues(def.Enum.Choices), def.Enum.DefaultValue) {
			return fmt.Errorf("enum default is not one of its choices: %s", def.Id)
		}
	case def.StringList != nil:
		if def.StringList.MaxItems != nil && len(def.StringList.DefaultValue) > int(*def.StringList.MaxItems) {
			return fmt.Errorf("stringlist default exceeds its max items: %s", def.Id)
		}
		if def.StringList.AllowDuplicates == nil || !*def.StringList.AllowDuplicates {
			if hasDuplicates(def.StringList.DefaultValue) {
				return fmt.Errorf("stringlist default has duplicate items but duplicates are not allowed: %s", def.Id)
			}
		}
	}
	return nil
}

// JSON name of a kind ("bool", "int", "float", "string", "enum", "stringlist").
func kindName(kind pb.Kind) string {
	if kind == pb.Kind_UNSPECIFIED {
		return ""
	}
	name, ok := pb.Kind_name[int32(kind)]
	if !ok {
		return fmt.Sprintf("Kind(%d)", int32(kind))
	}
	return strings.ToLower(strings.TrimPrefix(name, "KIND_"))
}

// Validate number-related bounds for settings.
func validateNumberBounds[T int64 | float64](
	id string,
	min, max, recommendedMin, recommendedMax *T,
) {
	if min != nil && max != nil && *max < *min {
		panic("max is below min: " + id)
	}
	check := func(recommended *T, label string) {
		if min != nil && recommended != nil && *recommended < *min {
			panic(fmt.Sprintf("%s is below min: %s", label, id))
		}
		if max != nil && recommended != nil && *recommended > *max {
			panic(fmt.Sprintf("%s is above max: %s", label, id))
		}
	}
	check(recommendedMin, "recommendedMin")
	check(recommendedMax, "recommendedMax")
}

// Whether the list contains duplicate values.
func hasDuplicates(values []string) bool {
	sorted := slices.Clone(values)
	slices.Sort(sorted)
	return len(slices.Compact(sorted)) != len(values)
}
