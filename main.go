package main

import (
	"fmt"
	"log"
	"net/http"
)

func main() {
	log.Println("I'm running!")

	http.HandleFunc("/", handleRequest)
	http.ListenAndServe(":8080", nil)
}

func handleRequest(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintf(w, "Welcome to %s", r.URL.Path[1:])
}
