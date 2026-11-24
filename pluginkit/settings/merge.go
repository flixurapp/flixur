package settings

import (
	"fmt"
	"strings"

	"google.golang.org/protobuf/proto"

	pb "forge.xela.codes/xela/flixur/pluginkit/proto"
)

// Merges settings groups and definitions into the registry under [prefix].
// The prefix becomes a group and any missing parent groups of the prefix are created automatically.
// The prefix group is specified by [prefixGroup] with its ID set to [prefix].
// Groups and definitions are created as children of the prefix.
func (r *Registry) Merge(prefix string, prefixGroup GroupSetting, groups []*pb.SettingsGroup, defs []*pb.SettingsDefinition) error {
	r.mutex.Lock()
	defer r.mutex.Unlock()

	if !validIDRegex.MatchString(prefix) {
		return fmt.Errorf("invalid merge prefix: %s", prefix)
	}

	// group IDs that will be added, in order
	var newGroups []*pb.SettingsGroup

	// create the prefix group itself
	prefixGroup.SettingsGroup.Id = prefix
	if _, ok := r.groupsByID[prefix]; ok {
		return fmt.Errorf("duplicate group ID: %s", prefix)
	}
	newGroups = append(newGroups, prefixGroup.SettingsGroup)

	// create any missing parent groups of the prefix
	segments := strings.Split(prefix, ".")
	for i := 1; i < len(segments); i++ {
		parent := strings.Join(segments[:i], ".")
		if _, ok := r.groupsByID[parent]; ok {
			continue
		}
		if groupByID(newGroups, parent) != nil {
			continue
		}
		newGroups = append(newGroups, &pb.SettingsGroup{Id: parent})
	}

	// validate and add prefix to groups
	for _, group := range groups {
		id := prefix + "." + group.Id
		if !validIDRegex.MatchString(id) {
			return fmt.Errorf("invalid group ID: %s", id)
		}
		if _, ok := r.groupsByID[id]; ok || groupByID(newGroups, id) != nil {
			return fmt.Errorf("duplicate group ID: %s", id)
		}
		if dot := strings.LastIndex(id, "."); dot > 0 {
			parent := id[:dot]
			if _, ok := r.groupsByID[parent]; !ok && groupByID(newGroups, parent) == nil {
				return fmt.Errorf("missing parent group %s for group %s", parent, id)
			}
		}
		created := proto.CloneOf[*pb.SettingsGroup](group)
		created.Id = id
		newGroups = append(newGroups, created)
	}

	// validate and add prefix to definitions
	var newDefs []*pb.SettingsDefinition
	for _, def := range defs {
		id := prefix + "." + def.Id
		if !validIDRegex.MatchString(id) {
			return fmt.Errorf("invalid setting ID: %s", id)
		}
		if _, ok := r.byID[id]; ok {
			return fmt.Errorf("duplicate setting ID: %s", id)
		}
		created := proto.CloneOf[*pb.SettingsDefinition](def)
		created.Id = id
		if err := validateDef(created); err != nil {
			return err
		}
		// the group must exist now that all groups are queued
		group := id[:strings.LastIndex(id, ".")]
		if _, ok := r.groupsByID[group]; !ok && groupByID(newGroups, group) == nil {
			return fmt.Errorf("missing group %s for setting %s", group, id)
		}
		newDefs = append(newDefs, created)
	}

	// everything validated, apply
	for _, group := range newGroups {
		r.groupsByID[group.Id] = group
		r.groups = append(r.groups, group)
	}
	for _, def := range newDefs {
		r.byID[def.Id] = def
		r.definitions = append(r.definitions, def)
	}
	return nil
}

// Finds a group by ID among queued groups.
func groupByID(groups []*pb.SettingsGroup, id string) *pb.SettingsGroup {
	for _, group := range groups {
		if group.Id == id {
			return group
		}
	}
	return nil
}
