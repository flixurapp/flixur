package common

import (
	"crypto/sha256"
	"encoding/hex"
)

// Current numerical protocol version of the server.
var Version int32 = 1

// Hash a string with SHA256 and output the hex value.
func SHA256Hex(value string) string {
	sum := sha256.Sum256([]byte(value))
	return hex.EncodeToString(sum[:])
}
