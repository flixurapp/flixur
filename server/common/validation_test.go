package common

import "testing"

func TestIsValidUsername(t *testing.T) {
	cases := []struct {
		name     string
		username string
		want     bool
	}{
		{"empty", "", false},
		{"ascii lowercase", "user", true},
		{"ascii mixed", "User_Name123", true},
		{"ascii with symbols", "user!@#", true},
		{"space", "user name", true},
		{"unicode", "usér", false},
		{"newline", "user\nname", false},
		{"tab", "user\tname", false},
		{"single ascii char", "a", true},
	}

	for _, tc := range cases {
		t.Run(tc.name, func(t *testing.T) {
			if got := IsValidUsername(tc.username); got != tc.want {
				t.Fatalf("IsValidUsername(%q) = %v, want %v", tc.username, got, tc.want)
			}
		})
	}
}
