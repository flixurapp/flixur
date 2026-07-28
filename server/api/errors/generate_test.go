package main

import (
	"os"
	"path/filepath"
	"strings"
	"testing"
)

func TestToPascalCase(t *testing.T) {
	cases := []struct {
		input    string
		expected string
	}{
		{"DATABASE_ERROR", "DatabaseError"},
		{"INVALID_INPUT", "InvalidInput"},
		{"TOO_LONG", "TooLong"},
		{"SINGLE", "Single"},
		{"", ""},
		{"_LEADING", "Leading"},
		{"TRAILING_", "Trailing"},
		{"DOUBLE__UNDERSCORE", "DoubleUnderscore"},
	}

	for _, tc := range cases {
		t.Run(tc.input, func(t *testing.T) {
			if got := toPascalCase(tc.input); got != tc.expected {
				t.Errorf("toPascalCase(%q) = %q, want %q", tc.input, got, tc.expected)
			}
		})
	}
}

func TestGeneratorProducesExpectedOutput(t *testing.T) {
	dir := t.TempDir()
	sub := filepath.Join(dir, "errors")
	if err := os.Mkdir(sub, 0755); err != nil {
		t.Fatal(err)
	}

	oldWd, err := os.Getwd()
	if err != nil {
		t.Fatal(err)
	}
	if err := os.Chdir(sub); err != nil {
		t.Fatal(err)
	}
	defer os.Chdir(oldWd)

	main()

	generated, err := os.ReadFile(filepath.Join(dir, "errors_gen.go"))
	if err != nil {
		t.Fatal(err)
	}

	content := string(generated)
	if !strings.Contains(content, "DO NOT EDIT.") {
		t.Error("missing generated header")
	}
	if !strings.Contains(content, "CodeDatabaseError") {
		t.Error("missing CodeDatabaseError constant")
	}
	if !strings.Contains(content, "APIErrorCodeStatusMap") {
		t.Error("missing APIErrorCodeStatusMap")
	}
	if !strings.Contains(content, "type APIErrorCodesMixin struct") {
		t.Error("missing APIErrorCodesMixin type")
	}
}
