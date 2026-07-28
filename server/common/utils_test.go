package common

import "testing"

func TestSHA256Hex(t *testing.T) {
	cases := []struct {
		input    string
		expected string
	}{
		{"", "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855"},
		{"hello", "2cf24dba5fb0a30e26e83b2ac5b9e29e1b161e5c1fa7425e73043362938b9824"},
		{"a longer string with symbols!@#", "c6a19930fef3f70a760044d16f60f71f668482297546bb5c16e7e58facae3bbf"},
	}

	for _, tc := range cases {
		t.Run(tc.input, func(t *testing.T) {
			got := SHA256Hex(tc.input)
			if got != tc.expected {
				t.Fatalf("SHA256Hex(%q) = %q, want %q", tc.input, got, tc.expected)
			}
		})
	}
}
