package main

import (
	"net/http"
	"net/http/httptest"
	"os"
	"testing"

	. "github.com/smartystreets/goconvey/convey"
)

var (
	mux    *http.ServeMux
	writer *httptest.ResponseRecorder
)

func TestMain(m *testing.M) {
	Setup()
	code := m.Run()
	os.Exit(code)
}

func Setup() {
	mux = http.NewServeMux()
	writer = httptest.NewRecorder()
}

func TestIndexHandler(t *testing.T) {
	SkipConvey("Setup", t, nil) // Required once for goconvey live-reload

	request, _ := http.NewRequest("GET", "/", nil)

	mux.HandleFunc("/", indexHandler)
	mux.ServeHTTP(writer, request)

	if writer.Code != 200 {
		t.Errorf("Response code is %v", writer.Code)
	}
	if writer.Body.String() != "ok" {
		t.Errorf("expected: ok, got: %v", writer.Body.String())
	}
}
