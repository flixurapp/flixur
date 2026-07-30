package api

import (
	"net/http"
	"testing"

	"github.com/danielgtaylor/huma/v2/humatest"
)

func TestAPIError(t *testing.T) {
	err := CreateAPIError(CodeInvalidInput)
	if err.Error() != string(CodeInvalidInput) {
		t.Errorf("Error() = %q, want %q", err.Error(), CodeInvalidInput)
	}
	if err.GetStatus() != http.StatusBadRequest {
		t.Errorf("GetStatus() = %d, want %d", err.GetStatus(), http.StatusBadRequest)
	}
	if err.Detail != nil {
		t.Errorf("Detail = %v, want nil", err.Detail)
	}
}

func TestAPIErrorDetail(t *testing.T) {
	err := CreateAPIErrorDetail(CodeTooShort, "username")
	if err.Error() != string(CodeTooShort) {
		t.Errorf("Error() = %q", err.Error())
	}
	if err.GetStatus() != http.StatusBadRequest {
		t.Errorf("GetStatus() = %d", err.GetStatus())
	}
	if err.Detail == nil || *err.Detail != "username" {
		t.Fatalf("Detail = %v, want username", err.Detail)
	}
}

func TestAPIErrorResponses(t *testing.T) {
	_, hapi := humatest.New(t)

	descriptions := map[APIErrorCode]string{
		CodeDatabaseError:     "db",
		CodeIncorrectPassword: "bad password",
		CodeInvalidInput:      "bad input",
		CodeTooLong:           "too long",
		CodeTooShort:          "too short",
	}

	responses := APIErrorResponses(hapi, descriptions)

	if responses["500"] == nil {
		t.Fatal("expected 500 response")
	}
	if responses["400"] == nil {
		t.Fatal("expected 400 response")
	}
	if responses["401"] == nil {
		t.Fatal("expected 401 response")
	}

	if responses["400"].Content["application/json"].Schema == nil {
		t.Error("expected 400 schema")
	}
}
