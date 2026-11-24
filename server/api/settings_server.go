package api

import (
	"context"

	"forge.xela.codes/xela/flixur/ent"
	"forge.xela.codes/xela/flixur/ent/serversetting"
	pb "forge.xela.codes/xela/flixur/pluginkit/proto"
	s "forge.xela.codes/xela/flixur/pluginkit/settings"
	"forge.xela.codes/xela/flixur/plugins"
	"forge.xela.codes/xela/flixur/settings"
	"github.com/cardinalby/hureg"
	"github.com/cardinalby/hureg/pkg/huma/op_handler"
	"github.com/rs/zerolog/log"
)

func RegisterServerSettingsRoutes(reg APIRegistry) {
	api := reg.API.AddOpHandler(op_handler.AddTags("Settings"))
	api = api.AddBasePath("/admin/settings")

	//
	// Settings Definitions
	//
	hureg.Get(WithOptions(api, reg, APIRoute{
		OperationID: "get_server_settings_definitions",
		Name:        "Get Server Settings Definitions",
		Description: "Gets all server setting definitions and groups.",
		Admin:       true,
	}), "/definitions", func(ctx context.Context, _ *struct{}) (*Output[SettingsDefinitionsBody], error) {
		return CreateOutput(SettingsDefinitionsBody{
			List:   settings.ServerRegistry.All(),
			Groups: settings.ServerRegistry.Groups(),
		}), nil
	})

	//
	// Setting Values
	//
	hureg.Get(WithOptions(api, reg, APIRoute{
		OperationID: "get_server_settings_values",
		Name:        "Get Server Settings Values",
		Description: "Gets all stored server setting overrides.",
		Errors: APIErrorCodes{
			CodeDatabaseError: "Failed to read from database.",
		},
		Admin: true,
	}), "/values", func(ctx context.Context, _ *struct{}) (*Output[SettingValuesBody], error) {
		values, err := dbSettingValues(ctx, reg.DB)
		if err != nil {
			return nil, CreateAPIError(CodeDatabaseError)
		}
		return CreateOutput(SettingValuesBody{Values: values}), nil
	})

	hureg.Put(WithOptions(api, reg, APIRoute{
		OperationID: "update_server_setting_value",
		Name:        "Update Server Setting Value",
		Description: "Sets a server setting value.",
		Errors: APIErrorCodes{
			CodeDatabaseError: "Failed to write to database.",
			CodeInvalidInput:  "Value does not match the setting definition.",
			CodeNotFound:      "Setting not found.",
		},
		Admin: true,
	}), "/values/{settingID}", func(ctx context.Context, input *struct {
		// Setting ID
		SettingID string `path:"settingID"`
		Body      struct {
			// JSON-encoded value text, typed to the setting definition.
			Value string `json:"value"`
		}
	}) (*Output[SettingValueEntry], error) {
		// get setting definition from the registry
		def := settings.ServerRegistry.Find(input.SettingID)
		if def == nil {
			return nil, CreateAPIErrorDetail(CodeNotFound, "setting")
		}
		// validate value text
		value, err := s.ValidateValue(def, input.Body.Value)
		if err != nil {
			log.Debug().Err(err).Str("key", def.Id).Str("value", input.Body.Value).Msg("Failed to validate server setting value.")
			return nil, CreateAPIErrorDetail(CodeInvalidInput, "value")
		}

		entry, err := setServerSettingValue(ctx, reg.DB, def, value)
		if err != nil {
			return nil, err
		}

		// notify plugins of changes
		plugins.NotifySettingChange(ctx, reg.DB, input.SettingID)

		return CreateOutput(*entry), nil
	})
}

// Queries all stored server setting overrides from the database.
func dbSettingValues(ctx context.Context, db *ent.Client) (map[string]*SettingValueEntry, error) {
	values, err := db.ServerSetting.Query().
		Order(ent.Asc(serversetting.FieldSettingID)).
		All(ctx)
	if err != nil {
		log.Err(err).Msg("Failed to read server setting values from database.")
		return nil, err
	}

	list := make(map[string]*SettingValueEntry, len(values))
	for _, item := range values {
		list[item.SettingID] = &SettingValueEntry{
			Value:     item.Value.Raw,
			UpdatedAt: item.UpdatedAt,
		}
	}
	return list, nil
}

// Stores a server setting override and returns its entry.
func setServerSettingValue(ctx context.Context, db *ent.Client, def *pb.SettingsDefinition, value string) (*SettingValueEntry, error) {
	text := settings.SettingText{Raw: value, Secret: def.IsSecret()}

	// grab an existing value
	existing, err := db.ServerSetting.Query().
		Where(serversetting.SettingIDEQ(def.Id)).
		First(ctx)

	if err != nil {
		if !ent.IsNotFound(err) {
			log.Err(err).Msg("Failed to read server setting from database.")
			return nil, CreateAPIError(CodeDatabaseError)
		}

		// create the value
		created, err := db.ServerSetting.Create().
			SetSettingID(def.Id).
			SetValue(text).
			Save(ctx)
		if err != nil {
			log.Err(err).Msg("Failed to create server setting value.")
			return nil, CreateAPIError(CodeDatabaseError)
		}

		return &SettingValueEntry{Value: created.Value.Raw, UpdatedAt: created.UpdatedAt}, nil
	}

	// otherwise update the existing value
	updated, err := existing.Update().
		SetValue(text).
		Save(ctx)
	if err != nil {
		log.Err(err).Msg("Failed to update server setting value.")
		return nil, CreateAPIError(CodeDatabaseError)
	}

	return &SettingValueEntry{Value: updated.Value.Raw, UpdatedAt: updated.UpdatedAt}, nil
}
