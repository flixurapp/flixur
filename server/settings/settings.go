package settings

import (
	"fmt"
	"regexp"
	"slices"
	"strings"
)

//
/* ===== Settings Definitions ===== */
//

// Definition of a single setting.
// Defines base data and each [Kind] has its own prop for its requirements.
type SettingsDefinition struct {
	// Unique dotted ID for the setting.
	ID string `json:"id"`
	// Type of this setting.
	Kind Kind `json:"kind" enum:"bool,int,float,string,enum,stringlist"`

	// Sort order hint for the client.
	Order int `json:"order"`

	Bool       *BoolProps       `json:"bool,omitempty"`
	Int        *IntProps        `json:"int,omitempty"`
	Float      *FloatProps      `json:"float,omitempty"`
	String     *StringProps     `json:"string,omitempty"`
	Enum       *EnumProps       `json:"enum,omitempty"`
	StringList *StringListProps `json:"stringList,omitempty"`
}

// Validates this [SettingsDefinition]. May modify it.
func (def *SettingsDefinition) validate() {
	var kind Kind
	count := 0
	if def.Bool != nil {
		kind = KindBool
		count++
	}
	if def.Int != nil {
		kind = KindInt
		count++
	}
	if def.Float != nil {
		kind = KindFloat
		count++
	}
	if def.String != nil {
		kind = KindString
		count++
	}
	if def.Enum != nil {
		kind = KindEnum
		count++
	}
	if def.StringList != nil {
		kind = KindStringList
		count++
	}
	if count != 1 {
		panic(fmt.Sprintf("setting %s must have exactly one props struct, has %d", def.ID, count))
	}
	if def.Kind == "" {
		def.Kind = kind
	} else if def.Kind != kind {
		panic(fmt.Sprintf("setting %s kind %s does not match its props", def.ID, def.Kind))
	}

	switch {
	case def.Int != nil:
		validateNumberBounds(def.ID, def.Int.Min, def.Int.Max, def.Int.RecommendedMin, def.Int.RecommendedMax)
	case def.Float != nil:
		validateNumberBounds(def.ID, def.Float.Min, def.Float.Max, def.Float.RecommendedMin, def.Float.RecommendedMax)
	case def.Enum != nil:
		if len(def.Enum.Choices) == 0 {
			panic("enum setting has no choices: " + def.ID)
		}
		if def.Enum.Default != "" && !slices.Contains(choiceValues(def.Enum.Choices), def.Enum.Default) {
			panic("enum default is not one of its choices: " + def.ID)
		}
	case def.StringList != nil:
		if def.StringList.MaxItems != nil && len(def.StringList.Default) > *def.StringList.MaxItems {
			panic("stringlist default exceeds its max items: " + def.ID)
		}
	}
}

// Any SettingsDefinition builder.
type SettingBuilder interface {
	setting() SettingsDefinition
}

// Any [SettingsDefinition] can return itself from this method.
func (def SettingsDefinition) setting() SettingsDefinition { return def }

//
/* ===== Settings Registry ===== */
//

// Registry holding the definitions and groups of a single setting scope.
type Registry struct {
	definitions []*SettingsDefinition
	byID        map[string]*SettingsDefinition

	groups     []*SettingsGroup
	groupsByID map[string]*SettingsGroup
}

// Creates a registry for a scope of settings.
func NewRegistry() *Registry {
	return &Registry{
		byID:       map[string]*SettingsDefinition{},
		groupsByID: map[string]*SettingsGroup{},
	}
}

// Regex matching a setting ID.
var validIDRegex = regexp.MustCompile(`^[a-z][a-zA-Z0-9_]*(\.[a-z][a-zA-Z0-9_]*)*$`)

// Defines a new setting. Will panic on any errors.
// Groups must be registered BEFORE any settings inside of it are.
func (r *Registry) Register(builder SettingBuilder) *SettingsDefinition {
	def := builder.setting()
	if !validIDRegex.MatchString(def.ID) {
		panic("invalid setting ID: " + def.ID)
	}

	// last dot in the ID
	dot := strings.LastIndex(def.ID, ".")
	if dot <= 0 {
		panic("setting must be inside a group: " + def.ID)
	}
	// the group name is all but the last dot
	group := def.ID[:dot]
	if _, ok := r.groupsByID[group]; !ok {
		panic("missing group " + group + " for setting " + def.ID)
	}

	// deny duplicates and validate
	if _, ok := r.byID[def.ID]; ok {
		panic("duplicate setting ID: " + def.ID)
	}
	def.validate()

	// create a copy of the definition to store
	created := def
	r.byID[def.ID] = &created
	r.definitions = append(r.definitions, &created)
	return &created
}

// All definitions in the registry, ordered by registration.
func (r *Registry) All() []*SettingsDefinition {
	return r.definitions
}

// Find a definition by ID.
func (r *Registry) Find(id string) *SettingsDefinition {
	return r.byID[id]
}

// Registers a new settings group.
// The parent of a nested group ID must already be registered.
// (so "foo.bar" requires the "foo" group registered first)
func (r *Registry) RegisterGroup(builder GroupSetting) *SettingsGroup {
	group := builder.SettingsGroup
	if !validIDRegex.MatchString(group.ID) {
		panic("invalid group ID: " + group.ID)
	}

	// find and validate parent group ID
	if dot := strings.LastIndex(group.ID, "."); dot > 0 {
		parent := group.ID[:dot]
		if _, ok := r.groupsByID[parent]; !ok {
			panic("missing parent group " + parent + " for group " + group.ID)
		}
	}

	// deny duplicates
	if _, ok := r.groupsByID[group.ID]; ok {
		panic("duplicate group ID: " + group.ID)
	}

	// create and store a copy of the group
	created := group
	r.groupsByID[group.ID] = &created
	r.groups = append(r.groups, &created)
	return &created
}

// All groups in the registry, ordered by registration.
func (r *Registry) Groups() []*SettingsGroup {
	return r.groups
}

// Find a group by ID.
func (r *Registry) FindGroup(id string) *SettingsGroup {
	return r.groupsByID[id]
}
