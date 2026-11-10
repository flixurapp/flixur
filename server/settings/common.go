package settings

import "fmt"

//
/* ===== Kind ===== */
//

// Kind of a setting value.
type Kind string

const (
	KindBool       Kind = "bool"
	KindInt        Kind = "int"
	KindFloat      Kind = "float"
	KindString     Kind = "string"
	KindEnum       Kind = "enum"
	KindStringList Kind = "stringlist"
)

//
/* ===== Groups ===== */
//

// A group of settings.
type SettingsGroup struct {
	// Dotted prefix that child settings will fall under.
	ID string `json:"id"`

	// Sort order among sibling groups.
	Order int `json:"order"`

	// Optional iconify icon name shown next to the group name on clients.
	Icon string `json:"icon,omitempty"`
}

// Creates a settings group for registration.
func Group(id string) GroupSetting {
	return GroupSetting{SettingsGroup: SettingsGroup{ID: id}}
}

type GroupSetting struct{ SettingsGroup }

// See [SettingsGroup.Order]
func (g GroupSetting) Order(v int) GroupSetting { g.SettingsGroup.Order = v; return g }

// See [SettingsGroup.Icon]
func (g GroupSetting) Icon(name string) GroupSetting { g.SettingsGroup.Icon = name; return g }

//
/* ===== Choices ===== */
//

// A single choice of a setting.
type ChoiceSpec struct {
	// Choice value.
	Value string `json:"value"`
	// Optional iconify icon name shown next to the choice on clients.
	Icon string `json:"icon,omitempty"`
}

// Creates a choice spec with an optional iconify icon name.
func newChoice(value string, icon ...string) ChoiceSpec {
	if len(icon) > 1 {
		panic("at most one icon per choice")
	}
	iconName := ""
	if len(icon) == 1 {
		iconName = icon[0]
	}
	return ChoiceSpec{Value: value, Icon: iconName}
}

// Returns values of a choice spec list.
func choiceValues(specs []ChoiceSpec) []string {
	values := make([]string, len(specs))
	for i, spec := range specs {
		values[i] = spec.Value
	}
	return values
}

//
/* ===== Validators ===== */
//

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
