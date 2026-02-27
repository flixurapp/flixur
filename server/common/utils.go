package common

import (
	"os"
)

var Dev = os.Getenv("MODE") == "dev"

// Current numerical version of the server.
var Version int32 = 1
