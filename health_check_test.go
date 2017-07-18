package main

import (
	"net/http"
	"net/http/httptest"
	"testing"
)

func TestHealthCheckHandler(t *testing.T) {
	request, _ := http.NewRequest("GET", "/health-check", nil)
	writer = httptest.NewRecorder()

	mux.HandleFunc("/health-check", healthCheckHandler)
	mux.ServeHTTP(writer, request)

	if writer.Code != 200 {
		t.Errorf("Response code is %v", writer.Code)
	}
	if writer.Result().Header.Get("Content-Type") != "application/json" {
		t.Errorf("expected: application/json, got: %v", writer.Body.String())
	}
}
