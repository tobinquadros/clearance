package main

import (
	"flag"
	"fmt"
	"log"
	"net/http"
	"os"
	"time"

	"github.com/kelseyhightower/envconfig"
)

var (
	// use `-ldflags` during build to embed values for these variables
	buildtime string
	commit    string
	goversion string

	// CLI flags
	versionFlag bool
)

func init() {
	flag.BoolVar(&versionFlag, "version", false, "Print version information")
	flag.BoolVar(&versionFlag, "v", false, "Print version information")
}

type Env struct {
	HTTPTimeout      int    `envconfig:"HTTP_TIMEOUT"`
	WebServerPort    string `envconfig:"WEB_SERVER_PORT"`
	PostgresDB       string `envconfig:"POSTGRES_DB"`
	PostgresHost     string `envconfig:"POSTGRES_HOST"`
	PostgresPassword string `envconfig:"POSTGRES_PASSWORD"`
	PostgresUser     string `envconfig:"POSTGRES_USER"`
}

func main() {
	// Handle flags passed in at process startup
	flag.Parse()
	if versionFlag == true {
		version()
		os.Exit(0)
	}

	// Ensure the environment meets the specification in Env
	var env Env
	err := envconfig.Process("", &env)
	if err != nil {
		log.Fatal(err.Error())
	}

	// Start HTTP server with custom attributes
	server := &http.Server{
		Addr:         fmt.Sprintf(":%s", env.WebServerPort),
		Handler:      createServeMux(),
		ReadTimeout:  time.Duration(env.HTTPTimeout) * time.Second,
		WriteTimeout: time.Duration(env.HTTPTimeout) * time.Second,
	}
	log.Fatal(server.ListenAndServe())
}

func createServeMux() http.Handler {
	mux := http.NewServeMux()
	mux.HandleFunc("/", indexHandler)
	return mux
}

func indexHandler(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintf(w, "ok")
}
