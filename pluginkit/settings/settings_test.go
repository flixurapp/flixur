// tests for validating setting values against definitions
package settings

import (
	"strings"
	"testing"

	pb "forge.xela.codes/xela/flixur/pluginkit/proto"
)

func TestValidateValue(t *testing.T) {
	boolDef := Bool("test.bool", true)
	intDef := Int("test.int", 5).Min(1).Max(10)
	floatDef := Float("test.float", 1.0).Min(0.5).Max(1.5)
	stringDef := String("test.string", "").MaxLength(4)
	enumDef := Enum("test.enum", "a").AddChoice("a").AddChoice("b")
	listDef := StringList("test.list", nil).MaxItems(2)
	dupListDef := StringList("test.list.dup", nil).MaxItems(3).AllowDuplicates(true)

	cases := []struct {
		name    string
		def     *pb.SettingsDefinition
		input   string
		want    string // want "" to expect a validation error
		wantErr bool
	}{
		{"bool ok", boolDef.SettingsDefinition, "true", "true", false},
		{"bool ok 2", boolDef.SettingsDefinition, "false", "false", false},
		{"bool non-bool", boolDef.SettingsDefinition, `"yes"`, "", true},
		{"bool string", boolDef.SettingsDefinition, `"true"`, "", true},
		{"int ok", intDef.SettingsDefinition, "5", "5", false},
		{"int zero decimal", intDef.SettingsDefinition, "5.0", "5", false},
		{"int below min", intDef.SettingsDefinition, "0", "", true},
		{"int above max", intDef.SettingsDefinition, "11", "", true},
		{"int fractional", intDef.SettingsDefinition, "5.5", "", true},
		{"int string", intDef.SettingsDefinition, `"5"`, "", true},
		{"int min edge", intDef.SettingsDefinition, "1", "1", false},
		{"int max edge", intDef.SettingsDefinition, "10", "10", false},
		{"float ok", floatDef.SettingsDefinition, "0.75", "0.75", false},
		{"float non-float", floatDef.SettingsDefinition, `"1.0"`, "", true},
		{"float below min", floatDef.SettingsDefinition, "0.25", "", true},
		{"float above max", floatDef.SettingsDefinition, "2.5", "", true},
		{"float ok edge", floatDef.SettingsDefinition, "0.5", "0.5", false},
		{"string ok", stringDef.SettingsDefinition, `"hi"`, `"hi"`, false},
		{"string too long", stringDef.SettingsDefinition, `"hello"`, "", true},
		{"string number", stringDef.SettingsDefinition, "12", "", true},
		{"enum ok", enumDef.SettingsDefinition, `"a"`, `"a"`, false},
		{"enum invalid choice", enumDef.SettingsDefinition, `"c"`, "", true},
		{"enum non-string", enumDef.SettingsDefinition, "1", "", true},
		{"list ok", listDef.SettingsDefinition, `["a","b"]`, `["a","b"]`, false},
		{"list empty", listDef.SettingsDefinition, `[]`, `[]`, false},
		{"list null", listDef.SettingsDefinition, `null`, "[]", false},
		{"list too many", listDef.SettingsDefinition, `["a","b","c"]`, "", true},
		{"list non-strings", listDef.SettingsDefinition, `[1]`, "", true},
		{"list duplicate", listDef.SettingsDefinition, `["a","a"]`, "", true},
		{"list duplicate spread", listDef.SettingsDefinition, `["a","b","a"]`, "", true},
		{"list duplicates ok", dupListDef.SettingsDefinition, `["a","a"]`, `["a","a"]`, false},
		{"list duplicates ok spread", dupListDef.SettingsDefinition, `["a","b","a"]`, `["a","b","a"]`, false},
		{"list duplicates ok at max", dupListDef.SettingsDefinition, `["a","a","b"]`, `["a","a","b"]`, false},
		{"list duplicates still maxed", dupListDef.SettingsDefinition, `["a","a","b","c"]`, "", true},
		{"invalid json", boolDef.SettingsDefinition, `{`, "", true},
	}

	for _, tc := range cases {
		t.Run(tc.name, func(t *testing.T) {
			got, err := ValidateValue(tc.def, tc.input)
			if tc.wantErr {
				if err == nil {
					t.Fatalf("expected error, got %q", got)
				}
				return
			}
			if err != nil {
				t.Fatalf("unexpected error: %v", err)
			}
			if got != tc.want {
				t.Errorf("got %q, want %q", got, tc.want)
			}
		})
	}
}

func TestValidateValueUnknownKind(t *testing.T) {
	if _, err := ValidateValue(&pb.SettingsDefinition{Id: "test.x", Kind: 99}, "1"); err == nil {
		t.Fatal("expected error for unknown kind")
	}
}

func TestBuilders(t *testing.T) {
	// the kind constructors create the matching props struct
	if !Bool("test.a", true).Bool.DefaultValue {
		t.Error("Bool did not create its props")
	}
	if Int("test.a", 1).Int.DefaultValue != 1 {
		t.Error("Int did not create its props")
	}
	if Float("test.a", 1).Float.DefaultValue != 1 {
		t.Error("Float did not create its props")
	}
	if String("test.a", "").String_.DefaultValue != "" {
		t.Error("String did not create its props")
	}
	if Enum("test.a", "").Enum == nil {
		t.Error("Enum did not create its props")
	}
	if StringList("test.a", nil).StringList == nil {
		t.Error("StringList did not create its props")
	}
	if Group("test.a").SettingsGroup.Id != "test.a" {
		t.Error("Group did not create its props")
	}
}

func TestRegistryRegister(t *testing.T) {
	registry := NewRegistry()
	group := registry.RegisterGroup(Group("test"))
	created := registry.Register(Bool("test.a", false))
	if len(registry.All()) != 1 || registry.All()[0] != created {
		t.Fatal("definition not registered")
	}
	if registry.Find("test.a") != created {
		t.Fatal("Find did not return the definition")
	}
	if registry.Find("test.other") != nil {
		t.Fatal("Find should return nil for unknown IDs")
	}
	if registry.FindGroup("test.a") != nil {
		t.Fatal("FindGroup should return nil for a non-group ID")
	}
	if registry.FindGroup("test") != group {
		t.Fatal("FindGroup did not return the group")
	}

	cases := []struct {
		name string
		id   string
	}{
		{"uppercase start", "Test.a"},
		{"invalid chars", "test.a/b"},
		{"empty segment", "test..a"},
		{"numeric segment", "test.1a"},
		{"no owner group", "other.a"},
		{"no group at all", "bare"},
		{"too long", strings.Repeat("a.", 70) + "b"},
	}
	for _, tc := range cases {
		t.Run(tc.name, func(t *testing.T) {
			defer func() {
				if recover() == nil {
					t.Errorf("Register(%q) did not panic", tc.id)
				}
			}()
			registry.Register(Bool(tc.id, false))
		})
	}

	// duplicate ID
	defer func() {
		if recover() == nil {
			t.Error("duplicate registration did not panic")
		}
	}()
	registry.Register(Bool("test.a", true))
}

// Leading underscores are allowed so IDs with preceding numbers will work.
func TestRegistryUnderscoreIDs(t *testing.T) {
	registry := NewRegistry()
	registry.RegisterGroup(Group("_test"))
	created := registry.Register(Bool("_test._1setting", false))
	if registry.Find("_test._1setting") != created {
		t.Fatal("underscore-leading IDs were not registered")
	}
}

func TestValidateSegment(t *testing.T) {
	cases := []struct {
		id    string
		valid bool
	}{
		{"example", true},
		{"_1itemwithnumbers", true},
		{"_Spotify", true},
		{"a", true},
		{"Spotify", false},
		{"9lives", false},
		{"my-plugin", false},
		{"a.b", false},
		{"a b", false},
		{"", false},
	}
	for _, tc := range cases {
		t.Run(tc.id, func(t *testing.T) {
			err := ValidateSegment(tc.id)
			if tc.valid != (err == nil) {
				t.Errorf("ValidateSegment(%q) = %v, want valid=%v", tc.id, err, tc.valid)
			}
		})
	}
}

func TestRegistryGroups(t *testing.T) {
	registry := NewRegistry()

	cases := []struct {
		name string
		id   string
	}{
		{"uppercase start", "UI.test"},
		{"invalid chars", "ui.test/b"},
		{"empty segment", "ui..test"},
		{"numeric segment", "ui.1a"},
		{"missing parent", "ui.test"},
	}
	for _, tc := range cases {
		t.Run(tc.name, func(t *testing.T) {
			defer func() {
				if recover() == nil {
					t.Errorf("MountGroup(%q) did not panic", tc.id)
				}
			}()
			registry.RegisterGroup(Group(tc.id))
		})
	}

	root := registry.RegisterGroup(Group("ui").Icon("sliders-horizontal").Order(1))
	if len(registry.Groups()) != 1 || registry.Groups()[0] != root {
		t.Fatal("root group not registered")
	}
	if root.Icon == nil || *root.Icon != "sliders-horizontal" || root.Order != 1 {
		t.Fatal("group builder properties were not applied")
	}
	child := registry.RegisterGroup(Group("ui.nav").Order(2))
	if len(registry.Groups()) != 2 || registry.Groups()[1] != child {
		t.Fatal("child group not registered")
	}
	if registry.FindGroup("ui.nav") != child {
		t.Fatal("FindGroup did not return the child")
	}

	// duplicate group
	defer func() {
		if recover() == nil {
			t.Error("duplicate group registration did not panic")
		}
	}()
	registry.RegisterGroup(Group("ui"))
}

func TestRegistryNestedGroups(t *testing.T) {
	registry := NewRegistry()
	registry.RegisterGroup(Group("misc"))
	registry.RegisterGroup(Group("misc.deeper"))
	registry.RegisterGroup(Group("misc.deeper.deep"))
	created := registry.Register(Bool("misc.deeper.deep.setting", false))
	if len(registry.All()) != 1 || registry.All()[0] != created {
		t.Fatal("definition not registered under the nested group")
	}

	missing := NewRegistry()
	defer func() {
		if recover() == nil {
			t.Error("registering under an unregistered middle group did not panic")
		}
	}()
	missing.RegisterGroup(Group("misc"))
	missing.Register(Bool("misc.unregistered.setting", false))
}

func TestValidateChainBuilding(t *testing.T) {
	registry := NewRegistry()
	registry.RegisterGroup(Group("test"))
	def := registry.Register(Float("test.a", 1.0).Min(0.5).Max(1.5).Step(0.25).Order(2))
	if def.Float.Min == nil || *def.Float.Min != 0.5 ||
		def.Float.Max == nil || *def.Float.Max != 1.5 ||
		def.Float.Step == nil || *def.Float.Step != 0.25 ||
		def.Order != 2 {
		t.Fatal("float chain did not apply its properties")
	}

	intDef := registry.Register(Int("test.b", 5).Min(1).Max(9).Step(3).Order(1).Recommended(2, 8))
	if intDef.Int.Min == nil || *intDef.Int.Min != 1 ||
		intDef.Int.Max == nil || *intDef.Int.Max != 9 ||
		intDef.Int.Step == nil || *intDef.Int.Step != 3 ||
		intDef.Int.RecommendedMin == nil || *intDef.Int.RecommendedMin != 2 ||
		intDef.Int.RecommendedMax == nil || *intDef.Int.RecommendedMax != 8 {
		t.Fatal("int chain did not apply its properties")
	}

	listDef := registry.Register(StringList("test.c", []string{"x"}).
		MaxItems(4).
		AddChoice("x").
		AddChoice("y", "star").
		AllowDuplicates(true).
		Order(1))
	if listDef.StringList.MaxItems == nil || *listDef.StringList.MaxItems != 4 ||
		len(listDef.StringList.Choices) != 2 ||
		*listDef.StringList.Choices[1].Icon != "star" ||
		listDef.StringList.AllowDuplicates == nil || !*listDef.StringList.AllowDuplicates ||
		listDef.Order != 1 {
		t.Fatal("stringlist chain did not apply its properties")
	}

	enumDef := registry.Register(Enum("test.d", "x").AddChoice("x").AddChoice("y"))
	if len(enumDef.Enum.Choices) != 2 {
		t.Fatal("enum chain did not apply its choices")
	}
}

func TestEnumEmptyDefaultResolves(t *testing.T) {
	registry := NewRegistry()
	registry.RegisterGroup(Group("test"))

	// an empty default falls back to the first choice
	first := registry.Register(Enum("test.a", "").AddChoice("y").AddChoice("z"))
	if first.Enum.DefaultValue != "y" {
		t.Errorf("empty default did not fall back to the first choice, got %q", first.Enum.DefaultValue)
	}

	// an empty default is kept when "" is itself a choice
	empty := registry.Register(Enum("test.b", "").AddChoice("y").AddChoice(""))
	if empty.Enum.DefaultValue != "" {
		t.Errorf(`"" choice default was not kept, got %q`, empty.Enum.DefaultValue)
	}

	// a non-empty default is kept
	kept := registry.Register(Enum("test.c", "z").AddChoice("y").AddChoice("z"))
	if kept.Enum.DefaultValue != "z" {
		t.Errorf("non-empty default was changed, got %q", kept.Enum.DefaultValue)
	}
}

func TestValidateDefinitionConstraints(t *testing.T) {
	registry := NewRegistry()
	registry.RegisterGroup(Group("test"))
	for name, run := range map[string]func(){
		"no props": func() {
			registry.Register(Def{&pb.SettingsDefinition{Id: "test.a"}})
		},
		"double props": func() {
			def := Bool("test.a", false)
			def.Int = &pb.IntProps{}
			registry.Register(def)
		},
		"kind mismatch": func() {
			def := Bool("test.a", false)
			def.Kind = pb.Kind_INT
			registry.Register(def)
		},
		"max below min (int)": func() {
			registry.Register(Int("test.a", 5).Min(9).Max(1))
		},
		"max below min (float)": func() {
			registry.Register(Float("test.a", 5).Min(9).Max(1))
		},
		"recommended below min": func() {
			registry.Register(Int("test.a", 5).Min(2).Recommended(1, 8))
		},
		"recommended above max": func() {
			registry.Register(Int("test.a", 5).Max(8).Recommended(2, 9))
		},
		"enum without choices": func() {
			registry.Register(Enum("test.a", "x"))
		},
		"enum default not a choice": func() {
			registry.Register(Enum("test.a", "x").AddChoice("y"))
		},
		"list default exceeds max items": func() {
			registry.Register(StringList("test.a", []string{"x", "y"}).MaxItems(1))
		},
		"list default has duplicates": func() {
			registry.Register(StringList("test.a", []string{"x", "x"}))
		},
	} {
		t.Run(name, func(t *testing.T) {
			defer func() {
				if recover() == nil {
					t.Errorf("%s did not panic", name)
				}
			}()
			run()
		})
	}
}

func TestRegistryMerge(t *testing.T) {
	t.Run("prefixes and auto creates groups", func(t *testing.T) {
		registry := NewRegistry()
		registry.RegisterGroup(Group("server"))

		groups := []*pb.SettingsGroup{{Id: "cache", Order: 3}}
		defs := []*pb.SettingsDefinition{Int("cache.size", 10).SettingsDefinition}

		if err := registry.Merge("server.plugins.myplugin", Group("ignored").Icon("puzzle").Order(7), groups, defs); err != nil {
			t.Fatalf("unexpected error: %v", err)
		}

		// the prefixed group chain exists, the plugin group carries its builder props
		pluginGroup := registry.FindGroup("server.plugins.myplugin")
		if pluginGroup == nil || pluginGroup.Icon == nil || *pluginGroup.Icon != "puzzle" || pluginGroup.Order != 7 {
			t.Fatalf("plugin group = %+v", pluginGroup)
		}
		if registry.FindGroup("server.plugins") == nil {
			t.Error("auto-created parent group missing")
		}

		// definitions are namespaced
		def := registry.Find("server.plugins.myplugin.cache.size")
		if def == nil || def.Int == nil || def.Int.DefaultValue != 10 {
			t.Fatalf("merged definition = %+v", def)
		}

		// ...and nothing is registered at top level
		if registry.Find("cache.size") != nil {
			t.Error("definition leaked outside the namespace")
		}
	})

	t.Run("atomic on error", func(t *testing.T) {
		registry := NewRegistry()
		registry.RegisterGroup(Group("server"))

		groups := []*pb.SettingsGroup{{Id: "cache"}}
		// this definition belongs to a group that was never registered
		defs := []*pb.SettingsDefinition{
			Int("cache.size", 10).SettingsDefinition,
			Bool("other.orphan", true).SettingsDefinition,
		}

		if err := registry.Merge("server.plugins.bad", Group("x"), groups, defs); err == nil {
			t.Fatal("expected an error for the orphaned definition")
		}
		if registry.FindGroup("server.plugins.bad") != nil || registry.FindGroup("server.plugins") != nil {
			t.Error("groups leaked into the registry on failed merge")
		}
		if len(registry.All()) != 0 {
			t.Error("definitions leaked into the registry on failed merge")
		}
	})

	t.Run("rejects invalid prefixes", func(t *testing.T) {
		registry := NewRegistry()
		for _, prefix := range []string{"Server.x", "server..x", "1bad", ""} {
			if err := registry.Merge(prefix, Group(prefix), nil, nil); err == nil {
				t.Errorf("Merge(%q) accepted an invalid prefix", prefix)
			}
		}
	})

	t.Run("rejects duplicate IDs", func(t *testing.T) {
		registry := NewRegistry()
		registry.RegisterGroup(Group("server"))
		groups := []*pb.SettingsGroup{{Id: "a"}}
		defs := []*pb.SettingsDefinition{Bool("a.b", true).SettingsDefinition}
		if err := registry.Merge("server.plugins.dupe", Group("x"), groups, defs); err != nil {
			t.Fatalf("unexpected error: %v", err)
		}
		if err := registry.Merge("server.plugins.dupe", Group("x"), groups, defs); err == nil {
			t.Error("expected duplicate plugin group error")
		}
		// a different plugin may use the same relative IDs thanks to namespacing
		if err := registry.Merge("server.plugins.other", Group("x"), groups, defs); err != nil {
			t.Fatalf("namespaced merge should not collide: %v", err)
		}
	})
}

func TestSettingsTracker(t *testing.T) {
	tracker := NewSettingsTracker()
	if _, ok := tracker.Get("x"); ok {
		t.Error("empty tracker returned a value")
	}

	tracker.Update(map[string]string{"x": "true", "y": `"hi"`})
	if got, _ := tracker.Get("x"); got != "true" {
		t.Errorf("Get(x) = %q", got)
	}
	var out bool
	if err := tracker.Decode("x", &out); err != nil || !out {
		t.Errorf("Decode(x) = %v, %v", out, err)
	}
	if err := tracker.Decode("missing", &out); err == nil {
		t.Error("Decode of missing setting did not error")
	}
	if len(tracker.All()) != 2 {
		t.Errorf("All() = %v", tracker.All())
	}

	// update replaces the whole snapshot
	tracker.Update(nil)
	if len(tracker.All()) != 0 {
		t.Errorf("snapshot not replaced, All() = %v", tracker.All())
	}
}
