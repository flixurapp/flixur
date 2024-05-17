package main

import (
	"os"
)

var Dev = os.Getenv("MODE") == "dev"
