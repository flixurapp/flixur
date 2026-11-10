// generates the JSON schema for the plugin manifest.
// Run via go:generate with the pluginkit directory as working directory.
package main

import (
	"encoding/json"
	"fmt"
	"os"
	"sort"
	"strings"

	pluginkit "forge.xela.codes/xela/flixur/pluginkit"
	pb "forge.xela.codes/xela/flixur/pluginkit/proto"
	"github.com/invopop/jsonschema"
)

const (
	// where the schema is online (used for $id/$schema).
	schemaURL = "https://forge.xela.codes/xela/flixur/raw/branch/master/pluginkit/manifest.schema.json"
	// output path, relative to the pluginkit directory.
	outputPath = "manifest.schema.json"
)

func main() {
	if err := run(); err != nil {
		fmt.Fprintln(os.Stderr, "schema generation error:", err)
		os.Exit(1)
	}
}

func run() error {
	// Comments from the pluginkit source become schema descriptions,
	// parsed relative to ./, which go generate sets to the pluginkit directory.
	r := new(jsonschema.Reflector)
	r.ExpandedStruct = true
	r.RequiredFromJSONSchemaTags = true // required fields are set below
	if err := r.AddGoComments("forge.xela.codes/xela/flixur/pluginkit", "./"); err != nil {
		return fmt.Errorf("parsing pluginkit comments: %w", err)
	}

	schema := r.Reflect(&pluginkit.PluginManifest{})
	schema.ID = jsonschema.ID(schemaURL)
	schema.Title = "Flixur Plugin Manifest"

	schema.Required = []string{
		"id", "name", "version", "features", "icon", "description", "author", "url",
	} // dependencies & bin are optional (bin is only added server-side)

	props := schema.Properties
	if props == nil {
		return fmt.Errorf("no properties reflected for PluginManifest")
	}

	// features are declared as strings and decoded back through pb.Feature_value,
	// so the schema tells editors the list of valid IDs instead of the numeric enum.
	features, ok := props.Get("features")
	if !ok {
		return fmt.Errorf("features property not found in reflected schema")
	}
	features.Type = "array"
	features.Items = &jsonschema.Schema{
		Type:        "string",
		Description: "Feature IDs this plugin implements, from the Feature enum.",
		Enum:        featureEnum(),
	}
	features.MinItems = u64(1)

	if version, ok := props.Get("version"); ok {
		version.Pattern = `^\d{4}\.(0[1-9]|1[0-2])\.(0[1-9]|[12]\d|3[01])$`
	}
	if icon, ok := props.Get("icon"); ok {
		// full Iconify icon identifier: prefix:name
		icon.Pattern = "^[a-z0-9-]+:[a-z0-9-]+$"
	}
	if id, ok := props.Get("id"); ok {
		id.MinLength = u64(1)
	}
	if name, ok := props.Get("name"); ok {
		name.MinLength = u64(1)
	}
	if deps, ok := props.Get("dependencies"); ok {
		deps.UniqueItems = true
	}

	// order the $schema prop at the top of the file
	ordered := jsonschema.NewProperties()
	ordered.Set("$schema", &jsonschema.Schema{
		Type:        "string",
		Description: "JSON schema this manifest is validated against, for editor support.",
		Default:     schemaURL,
	})
	for k, v := range props.FromOldest() {
		ordered.Set(k, v)
	}
	schema.Properties = ordered

	if len(schema.Definitions) == 0 {
		schema.Definitions = nil
	}

	b, err := json.MarshalIndent(schema, "", "  ")
	if err != nil {
		return fmt.Errorf("marshalling schema: %w", err)
	}
	b = append(b, '\n')
	return os.WriteFile(outputPath, b, 0o644)
}

// u64 returns a pointer to the given value for schema fields like MinLength.
func u64(v uint64) *uint64 { return new(v) }

// returns the manifest feature IDs in enum order.
func featureEnum() []any {
	type feature struct {
		num  int32
		name string
	}
	features := make([]feature, 0, len(pb.Feature_value))
	for name, num := range pb.Feature_value {
		short := strings.TrimPrefix(name, "FEATURE_")
		if short == "UNSPECIFIED" {
			continue
		}
		features = append(features, feature{num: num, name: short})
	}
	sort.Slice(features, func(i, j int) bool { return features[i].num < features[j].num })
	enum := make([]any, len(features))
	for i, f := range features {
		enum[i] = f.name
	}
	return enum
}
