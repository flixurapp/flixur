package settings

import (
	"fmt"
	"regexp"
	"strings"
	"sync"

	pb "forge.xela.codes/xela/flixur/pluginkit/proto"
)

// Any SettingsDefinition builder.
type SettingBuilder interface {
	setting() *pb.SettingsDefinition
}

// A small wrapper so raw definitions satisfy [SettingBuilder].
type Def struct{ *pb.SettingsDefinition }

func (d Def) setting() *pb.SettingsDefinition { return d.SettingsDefinition }

// Registry holding the definitions and groups of a single setting scope.
type Registry struct {
	mutex sync.RWMutex

	definitions []*pb.SettingsDefinition
	byID        map[string]*pb.SettingsDefinition

	groups     []*pb.SettingsGroup
	groupsByID map[string]*pb.SettingsGroup
}

// Creates a registry for a scope of settings.
func NewRegistry() *Registry {
	return &Registry{
		byID:       map[string]*pb.SettingsDefinition{},
		groupsByID: map[string]*pb.SettingsGroup{},
	}
}

// A single valid ID segment.
const idSegment = `[_a-z][a-zA-Z0-9_]*`

// Pattern matching a single segment only.
const SegmentPattern = "^" + idSegment + "$"

// Regex matching a setting ID.
var validIDRegex = regexp.MustCompile(`^` + idSegment + `(\.` + idSegment + `)*$`)

// Regex matching a single ID segment.
var segmentRegex = regexp.MustCompile(SegmentPattern)

// Validates that id is a single valid ID segment only.
func ValidateSegment(id string) error {
	if strings.Contains(id, ".") {
		return fmt.Errorf("must be a single segment (no dots)")
	}
	if !segmentRegex.MatchString(id) {
		return fmt.Errorf("must start with a letter or underscore and contain only letters, digits or underscores")
	}
	return nil
}

// Maximum length of a setting ID.
const maxIDLength = 128

// Defines a new setting. Will panic on any errors.
// Groups must be registered BEFORE any settings inside of it are.
func (r *Registry) Register(builder SettingBuilder) *pb.SettingsDefinition {
	def, err := r.Add(builder)
	if err != nil {
		panic(err)
	}
	return def
}

// Defines a new setting, returning any errors instead of panicking.
// Groups must be registered BEFORE any settings inside of it are.
func (r *Registry) Add(builder SettingBuilder) (*pb.SettingsDefinition, error) {
	r.mutex.Lock()
	defer r.mutex.Unlock()
	return r.addDef(builder.setting())
}

func (r *Registry) addDef(def *pb.SettingsDefinition) (*pb.SettingsDefinition, error) {
	if !validIDRegex.MatchString(def.Id) {
		return nil, fmt.Errorf("invalid setting ID: %s", def.Id)
	}
	// IDs greater than 128 characters will cause issues on clients
	// for example hive_ce can only have keys up to 255 characters
	// 128 is a safe default as I can't imagine a settings key needing to be longer
	if len(def.Id) > maxIDLength {
		return nil, fmt.Errorf("setting ID must not be >%d characters: %s", maxIDLength, def.Id)
	}

	// last dot in the ID
	dot := strings.LastIndex(def.Id, ".")
	if dot <= 0 {
		return nil, fmt.Errorf("setting must be inside a group: %s", def.Id)
	}
	// the group name is all but the last dot
	group := def.Id[:dot]
	if _, ok := r.groupsByID[group]; !ok {
		return nil, fmt.Errorf("missing group %s for setting %s", group, def.Id)
	}

	// deny duplicates and validate
	if _, ok := r.byID[def.Id]; ok {
		return nil, fmt.Errorf("duplicate setting ID: %s", def.Id)
	}
	if err := validateDef(def); err != nil {
		return nil, err
	}

	r.byID[def.Id] = def
	r.definitions = append(r.definitions, def)
	return def, nil
}

// All definitions in the registry, ordered by registration.
func (r *Registry) All() []*pb.SettingsDefinition {
	r.mutex.RLock()
	defer r.mutex.RUnlock()
	return r.definitions
}

// Find a definition by ID.
func (r *Registry) Find(id string) *pb.SettingsDefinition {
	r.mutex.RLock()
	defer r.mutex.RUnlock()
	return r.byID[id]
}

// Registers a new settings group. Will panic on any errors.
// The parent of a nested group ID must already be registered.
// (so "foo.bar" requires the "foo" group registered first)
func (r *Registry) RegisterGroup(builder GroupSetting) *pb.SettingsGroup {
	group, err := r.AddGroup(builder)
	if err != nil {
		panic(err)
	}
	return group
}

// Registers a new settings group, returning any errors instead of panicking.
// The parent of a nested group ID must already be registered.
func (r *Registry) AddGroup(builder GroupSetting) (*pb.SettingsGroup, error) {
	r.mutex.Lock()
	defer r.mutex.Unlock()
	return r.addGroup(builder.SettingsGroup)
}

func (r *Registry) addGroup(group *pb.SettingsGroup) (*pb.SettingsGroup, error) {
	if !validIDRegex.MatchString(group.Id) {
		return nil, fmt.Errorf("invalid group ID: %s", group.Id)
	}

	// find and validate parent group ID
	if dot := strings.LastIndex(group.Id, "."); dot > 0 {
		parent := group.Id[:dot]
		if _, ok := r.groupsByID[parent]; !ok {
			return nil, fmt.Errorf("missing parent group %s for group %s", parent, group.Id)
		}
	}

	// deny duplicates
	if _, ok := r.groupsByID[group.Id]; ok {
		return nil, fmt.Errorf("duplicate group ID: %s", group.Id)
	}

	r.groupsByID[group.Id] = group
	r.groups = append(r.groups, group)
	return group, nil
}

// All groups in the registry, ordered by registration.
func (r *Registry) Groups() []*pb.SettingsGroup {
	r.mutex.RLock()
	defer r.mutex.RUnlock()
	return r.groups
}

// Find a group by ID.
func (r *Registry) FindGroup(id string) *pb.SettingsGroup {
	r.mutex.RLock()
	defer r.mutex.RUnlock()
	return r.groupsByID[id]
}
