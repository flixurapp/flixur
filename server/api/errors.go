package api

import (
	"fmt"
	"reflect"
	"slices"
	"strconv"
	"strings"

	"github.com/danielgtaylor/huma/v2"
)

type APIErrorCode string

type APIError struct {
	APIErrorCodesMixin
	// Details about what the error might be referring to.
	Detail *string `json:"detail,omitempty"`
}

// implements huma.StatusError
func (e *APIError) Error() string  { return string(e.Code) }
func (e *APIError) GetStatus() int { return APIErrorCodeStatusMap[e.Code] }

// Create a new APIError with error code.
func NewAPIError(code APIErrorCode) *APIError {
	return &APIError{
		APIErrorCodesMixin: APIErrorCodesMixin{Code: code},
	}
}

// Create a new APIError with error code and details.
func NewAPIErrorDetail(code APIErrorCode, detail string) *APIError {
	return &APIError{
		APIErrorCodesMixin: APIErrorCodesMixin{Code: code},
		Detail:             &detail,
	}
}

func APIErrorResponses(api huma.API, descriptions map[APIErrorCode]string) map[string]*huma.Response {
	schema := api.OpenAPI().Components.Schemas.Schema(reflect.TypeOf(APIError{}), true, "APIError")

	// collect api error codes by their HTTP status
	byStatus := map[int][]APIErrorCode{}
	for code := range descriptions {
		status := APIErrorCodeStatusMap[code]
		byStatus[status] = append(byStatus[status], code)
	}

	responses := map[string]*huma.Response{}
	for status, codes := range byStatus {
		// sort codes after collection
		slices.Sort(codes)

		// document the codes
		var sb strings.Builder
		sb.WriteString("Possible error codes:\n\n")
		for _, c := range codes {
			fmt.Fprintf(&sb, "- `%s`: %s\n", c, descriptions[c])
		}

		responses[strconv.Itoa(status)] = &huma.Response{
			Description: sb.String(),
			// pass along the schema
			Content: map[string]*huma.MediaType{
				"application/json": {Schema: schema},
			},
		}
	}
	return responses
}
