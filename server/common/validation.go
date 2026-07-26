package common

import "regexp"

const (
	USERNAME_MAX_LENGTH = 64
	USERNAME_MIN_LENGTH = 2

	PASSWORD_MAX_LENGTH = 72 // has to be 72 for bcrypt
	PASSWORD_MIN_LENGTH = 12
)

// match all (printable) ASCII characters
var RegexASCII = regexp.MustCompile(`^[\x20-\x7E]+$`)

// Tests that a username is valid ASCII.
func IsValidUsername(username string) bool {
	return RegexASCII.MatchString(username)
}
