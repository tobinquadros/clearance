package main

import (
	"fmt"
	"log"
	"net/http"
	"time"

	"github.com/kelseyhightower/envconfig"
)

var (
	// use `-ldflags` during build to embed values for these variables
	buildtime string
	commit    string
	goversion string
)

type Env struct {
	Timeout          int    `envconfig:"TIMEOUT"`
	WebServerPort    string `envconfig:"WEB_SERVER_PORT"`
	PostgresDB       string
	PostgresHost     string
	PostgresPassword string
	PostgresUser     string
}

func main() {
	var env Env
	err := envconfig.Process("", &env)
	if err != nil {
		log.Fatal(err.Error())
	}
	log.Println(env.Timeout)
	log.Println(env.WebServerPort)

	server := &http.Server{
		Addr:         fmt.Sprintf(":%s", env.WebServerPort),
		Handler:      createServeMux(),
		ReadTimeout:  time.Duration(env.Timeout) * time.Second,
		WriteTimeout: time.Duration(env.Timeout) * time.Second,
	}
	log.Fatal(server.ListenAndServe())
}

// TODO: create flag to call this
func version() {
	fmt.Println("BuildTime:", buildtime)
	fmt.Println("Commit:", commit)
	fmt.Println("GoVersion:", goversion)
}

func createServeMux() http.Handler {
	mux := http.NewServeMux()
	mux.HandleFunc("/", indexHandler)
	return mux
}

func indexHandler(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintf(w, "ok")
}
