package schema

// Used to test if a plugin supports certain features.
type Feature int32

const (
	// Implements `Artist*`, `Album*`, `Track*` RPC calls
	FeatureMusicMetadata Feature = 0
)

// PluginInfo is plugin metadata returned by GetPluginInfo.
type PluginInfo struct {
	// Unique Plugin ID.
	ID string `json:"id"`
	// Name of the plugin.
	Name string `json:"name"`
	// Numerical version of the plugin.
	Version int32 `json:"version"`
	// List of plugin IDs that should be loaded before this plugin.
	Dependencies []string `json:"dependencies"`
	// List of feature names this plugin implements.
	Features []Feature `json:"features"`
	// Should be the full identifier of an Iconify icon for this plugin. (https://icon-sets.iconify.design)
	Icon string `json:"icon"`
	// Short description of the plugin.
	Description string `json:"description"`
	// Name of the plugin author.
	Author string `json:"author"`
	// Direct link to the source code of the plugin.
	URL string `json:"url"`
}
