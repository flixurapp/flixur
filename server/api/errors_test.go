package api

import (
	"net/http"
	"testing"

	"github.com/cardinalby/hureg"
	"github.com/danielgtaylor/huma/v2"
	"github.com/danielgtaylor/huma/v2/humatest"
)

func TestNewErrorWithContextHook(t *testing.T) {
	// messages carrying an error code becomes an APIError
	se := huma.NewErrorWithContext(nil, http.StatusUnauthorized, string(CodeInvalidToken))
	apiErr, ok := se.(*APIError)
	if !ok {
		t.Fatalf("NewErrorWithContext = %T, want *APIError", se)
	}
	if apiErr.Code != CodeInvalidToken {
		t.Errorf("code = %q, want %q", apiErr.Code, CodeInvalidToken)
	}
	if apiErr.GetStatus() != http.StatusUnauthorized {
		t.Errorf("status = %d, want %d", apiErr.GetStatus(), http.StatusUnauthorized)
	}

	// errors already typed as APIErrors pass through unchanged
	passed := CreateAPIErrorDetail(CodeConflict, "name")
	se = huma.NewErrorWithContext(nil, http.StatusInternalServerError, "failed", passed)
	apiErr, ok = se.(*APIError)
	if !ok {
		t.Fatalf("NewErrorWithContext = %T, want *APIError", se)
	}
	if apiErr.Code != CodeConflict || apiErr.Detail == nil || *apiErr.Detail != "name" {
		t.Errorf("pass-through APIError = %+v", apiErr)
	}

	// built-in schema validation errors map to their codes
	se = huma.NewErrorWithContext(nil, http.StatusUnprocessableEntity, "validation failed",
		&huma.ErrorDetail{Location: "body.name", Message: "expected length <= 100"})
	apiErr, ok = se.(*APIError)
	if !ok {
		t.Fatalf("NewErrorWithContext = %T, want *APIError", se)
	}
	if apiErr.Code != CodeTooLong {
		t.Errorf("code = %q, want %q", apiErr.Code, CodeTooLong)
	}
	if apiErr.Detail == nil || *apiErr.Detail != "name" {
		t.Errorf("detail = %v, want name", apiErr.Detail)
	}

	se = huma.NewErrorWithContext(nil, http.StatusUnprocessableEntity, "validation failed",
		&huma.ErrorDetail{Location: "body.name", Message: "expected length >= 3"})
	apiErr, ok = se.(*APIError)
	if !ok {
		t.Fatalf("NewErrorWithContext = %T, want *APIError", se)
	}
	if apiErr.Code != CodeTooShort {
		t.Errorf("code = %q, want %q", apiErr.Code, CodeTooShort)
	}

	// unmapped validation errors become generic invalid input
	se = huma.NewErrorWithContext(nil, http.StatusUnprocessableEntity, "validation failed",
		&huma.ErrorDetail{Location: "body.limit", Message: "expected number >= 1"})
	apiErr, ok = se.(*APIError)
	if !ok {
		t.Fatalf("NewErrorWithContext = %T, want *APIError", se)
	}
	if apiErr.Code != CodeInvalidInput {
		t.Errorf("code = %q, want %q", apiErr.Code, CodeInvalidInput)
	}

	// server-side failures map to the unknown code
	se = huma.NewErrorWithContext(nil, http.StatusInternalServerError, "panic!")
	apiErr, ok = se.(*APIError)
	if !ok {
		t.Fatalf("NewErrorWithContext = %T, want *APIError", se)
	}
	if apiErr.Code != CodeUnknown || apiErr.GetStatus() != http.StatusInternalServerError {
		t.Errorf("unknown error = %+v", apiErr)
	}
}

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

	descriptions := APIErrorCodes{
		CodeDatabaseError:     "db",
		CodeIncorrectPassword: "bad password",
		CodeInvalidInput:      "bad input",
		CodeTooLong:           "too long",
		CodeTooShort:          "too short",
	}

	responses := APIErrorResponses(hureg.NewAPIGen(hapi), descriptions)

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
