// common test utils for other api-related tests
package api

import (
	"testing"

	"forge.xela.codes/xela/flixur/common"
	"forge.xela.codes/xela/flixur/ent"
	"forge.xela.codes/xela/flixur/ent/enttest"
	"github.com/danielgtaylor/huma/v2/humatest"
	"github.com/go-chi/chi/v5"

	_ "github.com/mattn/go-sqlite3"
)

func resetConfig(t *testing.T) {
	t.Helper()
	old := common.Config
	t.Cleanup(func() { common.Config = old })
}

func newTestClient(t *testing.T) *ent.Client {
	t.Helper()
	return enttest.Open(t, "sqlite3", common.TestDSN(t))
}

func newTestAPI(t *testing.T) (*ent.Client, APIRegistry, humatest.TestAPI) {
	t.Helper()
	client := newTestClient(t)
	router := chi.NewMux()
	reg := RegisterAPI(router, client)
	return client, reg, humatest.Wrap(t, reg.API.GetHumaAPI())
}
