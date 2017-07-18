package main

import (
	"net/http"
	"net/http/httptest"
	"os"
	"testing"
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
}

func TestIndexHandler(t *testing.T) {
	request, _ := http.NewRequest("GET", "/", nil)
	writer = httptest.NewRecorder()

	mux.HandleFunc("/", indexHandler)
	mux.ServeHTTP(writer, request)

	if writer.Code != 200 {
		t.Errorf("Response code is %v", writer.Code)
	}
	if writer.Body.String() != "ok\n" {
		t.Errorf("expected: ok, got: %v", writer.Body.String())
	}
}
