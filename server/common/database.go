package common

import (
	"fmt"
	"strings"
	"testing"
)

// Returns an in-memory sqlite test address.
func TestDSN(t *testing.T) string {
	return fmt.Sprintf("file:%s?mode=memory&cache=shared&_fk=1", strings.ReplaceAll(t.Name(), "/", "_"))
}
