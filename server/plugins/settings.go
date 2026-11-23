// Plugin settings handling: the Init handshake, registration of plugin
// settings into the server registry, and pushing value snapshots to plugins.
package plugins

import (
	"context"
	"fmt"
	"strings"
	"time"

	"forge.xela.codes/xela/flixur/ent"
	"forge.xela.codes/xela/flixur/ent/serversetting"
	pb "forge.xela.codes/xela/flixur/pluginkit/proto"
	"forge.xela.codes/xela/flixur/settings"
	"github.com/rs/zerolog/log"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
)

// Timeout for pushing setting values to a plugin.
const settingsPushTimeout = 10 * time.Second

// Runs the init handshake for a connected plugin.
func initPluginSettings(p *Plugin, db *ent.Client) error {
	resp, err := p.RPC.Init(context.Background(), &pb.InitRequest{})
	if err != nil {
		// plugins are not required to implement the handshake if no settings are needed
		if status.Code(err) == codes.Unimplemented {
			log.Debug().Str("id", p.Manifest.Id).Msg("Plugin does not implement the init handshake, skipping settings.")
			return nil
		}
		return fmt.Errorf("init handshake: %w", err)
	}

	if err := settings.MergePluginSettings(p.Manifest, resp.GetGroups(), resp.GetDefinitions()); err != nil {
		return fmt.Errorf("registering settings: %w", err)
	}

	// tests dont pass a db
	if db == nil {
		return nil
	}
	// push the current setting values to the plugin
	if err := pushPluginSettings(context.Background(), p, db); err != nil {
		if status.Code(err) == codes.Unimplemented {
			log.Debug().Str("id", p.Manifest.Id).Msg("Plugin does not implement settings updates, skipping init push.")
		} else {
			log.Err(err).Str("id", p.Manifest.Id).Msg("Failed to push settings to plugin.")
		}
	}
	return nil
}

// Pushes a full snapshot of the plugin's current setting values to it.
func pushPluginSettings(ctx context.Context, p *Plugin, db *ent.Client) error {
	values, err := pluginSettingValues(ctx, p, db)
	if err != nil {
		return err
	}
	ctx, cancel := context.WithTimeout(ctx, settingsPushTimeout)
	defer cancel()
	if _, err := p.RPC.SettingsUpdate(ctx, &pb.SettingsUpdateRequest{Values: values}); err != nil {
		return fmt.Errorf("pushing settings update: %w", err)
	}
	log.Trace().Str("id", p.Manifest.Id).Int("values", len(values)).Msg("Pushed settings to plugin.")
	return nil
}

// Collects the current stored overrides for a plugin's registered settings.
func pluginSettingValues(ctx context.Context, p *Plugin, db *ent.Client) (map[string]string, error) {
	prefix := settings.PluginNamespacePrefix + "." + p.Manifest.Id
	rows, err := db.ServerSetting.Query().
		Where(serversetting.SettingIDHasPrefix(prefix + ".")).
		All(ctx)
	if err != nil {
		return nil, fmt.Errorf("reading plugin settings: %w", err)
	}

	values := make(map[string]string, len(rows))
	for _, row := range rows {
		// skip values whose setting is no longer registered
		if settings.ServerRegistry.Find(row.SettingID) == nil {
			continue
		}
		values[row.SettingID] = row.Value.Raw
	}
	return values, nil
}

// Notifies any plugins that depend on it that a server setting value changed.
func NotifySettingChange(ctx context.Context, db *ent.Client, settingID string) {
	pluginID, ok := strings.CutPrefix(settingID, settings.PluginNamespacePrefix+".")
	if !ok {
		return
	}
	pluginID, _, _ = strings.Cut(pluginID, ".")
	p := FindPluginByID(pluginID)
	if p == nil {
		return
	}
	if err := pushPluginSettings(ctx, p, db); err != nil {
		if status.Code(err) == codes.Unimplemented {
			log.Debug().Str("id", p.Manifest.Id).Msg("Plugin does not implement settings updates, skipping push.")
		} else {
			log.Err(err).Str("id", p.Manifest.Id).Msg("Failed to notify plugin of setting change.")
		}
	}
}
