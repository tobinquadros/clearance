package main

import (
	"fmt"
)

// Print out the version info acquired from ldflags at build time
func version() {
	fmt.Println("BuildTime:", buildtime)
	fmt.Println("Commit:", commit)
	fmt.Println("GoVersion:", goversion)
}
