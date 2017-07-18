package main

import (
	"fmt"
	"log"
	"net/http"
	"time"

	"github.com/kelseyhightower/envconfig"
)

var (
	// The Dockerfile uses `-ldflags` during image build to embed these variables
	// as version metadata for the /health-check endpoint.
	buildTime string
	gitCommit string
	goVersion string
)

func init() {
}

type Env struct {
	HTTPTimeout      int    `envconfig:"HTTP_TIMEOUT"`
	HTTPPort         string `envconfig:"HTTP_PORT"`
	PostgresDB       string `envconfig:"POSTGRES_DB"`
	PostgresHost     string `envconfig:"POSTGRES_HOST"`
	PostgresPassword string `envconfig:"POSTGRES_PASSWORD"`
	PostgresUser     string `envconfig:"POSTGRES_USER"`
}

func main() {
	// Ensure the environment meets the specification in Env
	var env Env
	err := envconfig.Process("", &env)
	if err != nil {
		log.Fatal(err.Error())
	}

	// Start HTTP server with custom attributes
	server := &http.Server{
		Addr:         fmt.Sprintf(":%s", env.HTTPPort),
		Handler:      createServeMux(),
		ReadTimeout:  time.Duration(env.HTTPTimeout) * time.Second,
		WriteTimeout: time.Duration(env.HTTPTimeout) * time.Second,
	}
	log.Fatal(server.ListenAndServe())
}

func createServeMux() http.Handler {
	mux := http.NewServeMux()
	mux.HandleFunc("/", indexHandler)
	mux.HandleFunc("/health-check", healthCheckHandler)
	return mux
}

func indexHandler(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintf(w, "ok\n")
}
