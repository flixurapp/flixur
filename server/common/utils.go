package common

import (
	"os"
)

var Dev = os.Getenv("MODE") == "dev"
