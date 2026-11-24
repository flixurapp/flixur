package settings

import (
	"encoding/json"
	"fmt"
	"maps"
	"sync"
)

// Local store of settings values received from the server.
type SettingsTracker struct {
	mutex  sync.RWMutex
	values map[string]string
}

// Creates a new settings tracker.
func NewSettingsTracker() *SettingsTracker {
	return &SettingsTracker{values: map[string]string{}}
}

// Replaces the tracked values with a full snapshot from the server.
func (t *SettingsTracker) Update(values map[string]string) {
	t.mutex.Lock()
	defer t.mutex.Unlock()
	t.values = make(map[string]string, len(values))
	maps.Copy(t.values, values)
}

// Returns the current JSON-encoded value for a setting ID and whether an
// override exists. Settings without an override return their default.
func (t *SettingsTracker) Get(id string) (string, bool) {
	t.mutex.RLock()
	defer t.mutex.RUnlock()
	value, ok := t.values[id]
	return value, ok
}

// JSON-decodes the current value for a setting ID into out.
func (t *SettingsTracker) Decode(id string, out any) error {
	value, ok := t.Get(id)
	if !ok {
		return fmt.Errorf("no value for setting %q", id)
	}
	return json.Unmarshal([]byte(value), out)
}

// Returns a copy of all current values.
func (t *SettingsTracker) All() map[string]string {
	t.mutex.RLock()
	defer t.mutex.RUnlock()
	values := make(map[string]string, len(t.values))
	for id, value := range t.values {
		values[id] = value
	}
	return values
}
