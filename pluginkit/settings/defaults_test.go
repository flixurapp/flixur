// tests for default value handling of setting definitions
package settings

import (
	"testing"

	pb "forge.xela.codes/xela/flixur/pluginkit/proto"
)

func TestDefaultText(t *testing.T) {
	cases := []struct {
		name string
		def  *pb.SettingsDefinition
		want string
	}{
		{"bool true", Bool("test.a", true).SettingsDefinition, "true"},
		{"bool false", Bool("test.a", false).SettingsDefinition, "false"},
		{"int", Int("test.a", 5).SettingsDefinition, "5"},
		{"float", Float("test.a", 0.5).SettingsDefinition, "0.5"},
		{"string", String("test.a", "hi").SettingsDefinition, `"hi"`},
		{"enum", Enum("test.a", "b").AddChoice("a").AddChoice("b").SettingsDefinition, `"b"`},
		{"list", StringList("test.a", []string{"x"}).SettingsDefinition, `["x"]`},
		{"list nil", StringList("test.a", nil).SettingsDefinition, `[]`},
		{"missing props", &pb.SettingsDefinition{Id: "test.a", Kind: pb.Kind_BOOL}, "false"},
	}

	for _, tc := range cases {
		t.Run(tc.name, func(t *testing.T) {
			got, err := DefaultText(tc.def)
			if err != nil {
				t.Fatalf("unexpected error: %v", err)
			}
			if got != tc.want {
				t.Errorf("got %q, want %q", got, tc.want)
			}
		})
	}
}

func TestDefaultTextUnknownKind(t *testing.T) {
	if _, err := DefaultText(&pb.SettingsDefinition{Id: "test.x", Kind: 99}); err == nil {
		t.Fatal("expected error for unknown kind")
	}
}

func TestIsDefaultValue(t *testing.T) {
	boolDef := Bool("test.bool", true).SettingsDefinition
	intDef := Int("test.int", 5).SettingsDefinition
	enumDef := Enum("test.enum", "a").AddChoice("a").AddChoice("b").SettingsDefinition
	listDef := StringList("test.list", nil).SettingsDefinition

	cases := []struct {
		name string
		def  *pb.SettingsDefinition
		text string
		want bool
	}{
		{"bool default", boolDef, "true", true},
		{"bool non-default", boolDef, "false", false},
		{"int default", intDef, "5", true},
		{"int non-default", intDef, "6", false},
		{"enum default", enumDef, `"a"`, true},
		{"enum non-default", enumDef, `"b"`, false},
		{"list empty default", listDef, "[]", true},
		{"list non-default", listDef, `["a"]`, false},
	}

	for _, tc := range cases {
		t.Run(tc.name, func(t *testing.T) {
			if got := IsDefaultValue(tc.def, tc.text); got != tc.want {
				t.Errorf("got %v, want %v", got, tc.want)
			}
		})
	}
}

// validated values must be recognized as their definition's default
func TestIsDefaultValueValidated(t *testing.T) {
	defs := []*pb.SettingsDefinition{
		Bool("test.bool", true).SettingsDefinition,
		Int("test.int", 5).SettingsDefinition,
		Float("test.float", 0.5).SettingsDefinition,
		String("test.string", "hi").SettingsDefinition,
		Enum("test.enum", "a").AddChoice("a").AddChoice("b").SettingsDefinition,
		StringList("test.list", []string{"x"}).SettingsDefinition,
	}

	for _, def := range defs {
		t.Run(def.Id, func(t *testing.T) {
			defText, err := DefaultText(def)
			if err != nil {
				t.Fatalf("unexpected error: %v", err)
			}
			text, err := ValidateValue(def, defText)
			if err != nil {
				t.Fatalf("default text failed validation: %v", err)
			}
			if !IsDefaultValue(def, text) {
				t.Errorf("validated default %q was not detected as default", text)
			}
		})
	}
}
