package main

import (
	"encoding/json"
	"fmt"
	"log"
	"net/http"
)

func healthCheckHandler(w http.ResponseWriter, r *http.Request) {
	healthCheckInfo := &map[string]string{
		"BuildTime": buildTime,
		"GitCommit": gitCommit,
		"GoVersion": goVersion,
	}
	healthCheckInfoJSON, err := json.Marshal(healthCheckInfo)
	if err != nil {
		log.Fatal(err.Error())
	}
	w.Header().Set("Content-Type", "application/json")
	fmt.Fprintf(w, fmt.Sprintf(string(healthCheckInfoJSON)))
}
