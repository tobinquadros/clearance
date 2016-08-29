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
	// We want to run goconvey's server for test watching only while using the
	// stdlib "testing" package for actual tests. The goconvey package has to be
	// dot imported, so that means we are required to use the package at least
	// one time otherwise the go compiler complains. This functions does nothing
	// but enable us to have the awesome goconvey server to watch our tests.
	SkipConvey("Setup", t, nil)

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
