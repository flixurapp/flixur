package plugins

import "testing"

func resetPlugins(t *testing.T, initial map[string]*Plugin) {
	t.Helper()
	old := Plugins
	Plugins = initial
	t.Cleanup(func() { Plugins = old })
}
