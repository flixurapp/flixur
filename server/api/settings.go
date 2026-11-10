// routes for serving setting definitions and synced setting profiles
package api

import (
	"context"
	"time"

	"forge.xela.codes/xela/flixur/ent"
	"forge.xela.codes/xela/flixur/ent/settingprofile"
	"forge.xela.codes/xela/flixur/ent/settingvalue"
	"forge.xela.codes/xela/flixur/ent/user"
	"forge.xela.codes/xela/flixur/settings"
	"github.com/cardinalby/hureg"
	"github.com/cardinalby/hureg/pkg/huma/op_handler"
	"github.com/rs/zerolog/log"
)

type SettingsDefinitionsBody struct {
	List   []*settings.SettingsDefinition `json:"list" nullable:"false"`
	Groups []*settings.SettingsGroup      `json:"groups" nullable:"false"`
}

type SettingProfileBody struct {
	// ID of this profile.
	ID string `json:"id"`
	// Name of this profile.
	Name string `json:"name"`
	// Timestamp this profile was created at.
	CreatedAt time.Time `json:"createdAt"`
}

// Converts a [ent.SettingsProfile] to its [SettingProfileBody].
func profileBody(profile *ent.SettingProfile) *SettingProfileBody {
	return &SettingProfileBody{
		ID:        profile.ID,
		Name:      profile.Name,
		CreatedAt: profile.CreatedAt,
	}
}

type SettingsProfilesBody struct {
	List []*SettingProfileBody `json:"list" nullable:"false"`
}

// One setting's override in a profile.
type SettingValueEntry struct {
	// JSON-encoded value text, decode according to the setting's kind.
	Value string `json:"value"`
	// Server timestamp of the last write, used for cross-device sync.
	UpdatedAt time.Time `json:"updatedAt"`
}

type SettingValuesBody struct {
	// Overrides keyed by setting ID.
	Values map[string]*SettingValueEntry `json:"values"`
}

// Fetches a profile owned by the given user.
func getOwnedProfile(ctx context.Context, db *ent.Client, userID string, profileID string) (*ent.SettingProfile, error) {
	profile, err := db.SettingProfile.Query().
		Where(
			settingprofile.ID(profileID),
			settingprofile.HasUserWith(user.ID(userID)),
		).
		Only(ctx)
	if err != nil {
		if ent.IsNotFound(err) {
			return nil, CreateAPIErrorDetail(CodeNotFound, "profile")
		}
		log.Err(err).Str("userID", userID).Str("profileID", profileID).Msg("Failed to get settings profile.")
		return nil, CreateAPIError(CodeDatabaseError)
	}
	return profile, nil
}

func RegisterSettingsRoutes(reg APIRegistry) {
	api := reg.API.AddOpHandler(op_handler.AddTags("Settings"))
	api = api.AddBasePath("/settings")

	//
	// Settings Definitions
	//
	hureg.Get(WithOptions(api, reg, APIRoute{
		OperationID: "get_client_settings_definitions",
		Name:        "Get Client Settings Definitions",
		Description: "Gets all client setting definitions and groups.",
	}), "/definitions", func(ctx context.Context, _ *struct{}) (*Output[SettingsDefinitionsBody], error) {
		return CreateOutput(SettingsDefinitionsBody{
			List:   settings.ClientRegistry.All(),
			Groups: settings.ClientRegistry.Groups(),
		}), nil
	})

	//
	// Setting Profile Management
	//
	hureg.Get(WithOptions(api, reg, APIRoute{
		OperationID: "get_settings_profiles",
		Name:        "Get Settings Profiles",
		Description: "Lists the setting profiles of the current user.",
		Errors: APIErrorCodes{
			CodeDatabaseError: "Failed to read from database.",
		}}), "/profiles", func(ctx context.Context, _ *struct{}) (*Output[SettingsProfilesBody], error) {
		currentUser := GetAuthorizedUser(ctx)

		// count of existing profiles
		hasExistingProfiles, err := reg.DB.SettingProfile.Query().
			Where(settingprofile.HasUserWith(user.ID(currentUser.ID))).
			Exist(ctx)
		if err != nil {
			log.Err(err).Str("userID", currentUser.ID).Msg("Failed to list settings profile count.")
			return nil, CreateAPIError(CodeDatabaseError)
		}

		// create default profile if no profiles exist yet
		if !hasExistingProfiles {
			_, err = reg.DB.SettingProfile.Create().
				SetName("Default").
				SetUserID(currentUser.ID).
				Save(ctx)
			if err != nil {
				// concurrent request might have created profile already
				// ignore it
				if !ent.IsConstraintError(err) {
					log.Err(err).Str("userID", currentUser.ID).Msg("Failed to create default settings profile.")
					return nil, CreateAPIError(CodeDatabaseError)
				}
			}
		}

		// get the profiles for the user
		profiles, err := reg.DB.SettingProfile.Query().
			Where(settingprofile.HasUserWith(user.ID(currentUser.ID))).
			Order(ent.Asc(settingprofile.FieldCreatedAt)).
			All(ctx)
		if err != nil {
			return nil, CreateAPIError(CodeDatabaseError)
		}

		list := make([]*SettingProfileBody, len(profiles))
		for index, item := range profiles {
			list[index] = profileBody(item)
		}
		return CreateOutput(SettingsProfilesBody{List: list}), nil
	})

	hureg.Post(WithOptions(api, reg, APIRoute{
		OperationID: "create_settings_profile",
		Name:        "Create Settings Profile",
		Description: "Creates a new settings profile.",
		Errors: APIErrorCodes{
			CodeConflict:      "Name is already taken.",
			CodeDatabaseError: "Failed to write to database.",
			CodeTooLong:       "Name is too long.",
			CodeTooShort:      "Name is too short.",
		}}), "/profiles", func(ctx context.Context, input *struct {
		Body struct {
			// Name for the new profile.
			Name string `json:"name" maxLength:"100" minLength:"1"`
		}
	}) (*Output[SettingProfileBody], error) {
		currentUser := GetAuthorizedUser(ctx)

		// find existing profile matching the name
		existingProfile, err := reg.DB.SettingProfile.Query().
			Where(
				settingprofile.NameEqualFold(input.Body.Name),
				settingprofile.HasUserWith(user.ID(currentUser.ID)),
			).
			Exist(ctx)
		if err != nil {
			return nil, CreateAPIError(CodeDatabaseError)
		}
		if existingProfile {
			return nil, CreateAPIError(CodeConflict)
		}

		// create the new profile
		profile, err := reg.DB.SettingProfile.Create().
			SetName(input.Body.Name).
			SetUserID(currentUser.ID).
			Save(ctx)
		if err != nil {
			log.Err(err).Msg("Failed to create setting profile.")
			return nil, CreateAPIError(CodeDatabaseError)
		}

		return CreateOutput(*profileBody(profile)), nil
	})

	hureg.Put(WithOptions(api, reg, APIRoute{
		OperationID: "rename_settings_profile",
		Name:        "Rename Settings Profile",
		Description: "Renames a settings profile.",
		Errors: APIErrorCodes{
			CodeDatabaseError: "Failed to write to database.",
			CodeInvalidInput:  "Name is empty or already taken.",
		}}), "/profiles/{profile}", func(ctx context.Context, input *struct {
		// Profile ID
		Profile string `path:"profile"`
		Body    struct {
			// New name for the profile.
			Name string `json:"name" maxLength:"100" minLength:"1"`
		}
	}) (*Output[OutputSuccessBody], error) {
		currentUser := GetAuthorizedUser(ctx)

		// get the referenced profile
		profile, err := getOwnedProfile(ctx, reg.DB, currentUser.ID, input.Profile)
		if err != nil {
			return nil, err
		}

		// name matches already, noop
		if profile.Name == input.Body.Name {
			return CreateOutput(OutputSuccessBody{Success: true}), nil
		}

		// check for an existing profile with the new name
		existingProfile, err := reg.DB.SettingProfile.Query().
			Where(
				settingprofile.NameEqualFold(input.Body.Name),
				settingprofile.HasUserWith(user.ID(currentUser.ID)),
			).
			Exist(ctx)
		if err != nil {
			return nil, CreateAPIError(CodeDatabaseError)
		}
		if existingProfile {
			return nil, CreateAPIError(CodeInvalidInput)
		}

		// rename the profile
		if _, err = profile.Update().SetName(input.Body.Name).Save(ctx); err != nil {
			log.Err(err).Msg("Failed to rename setting profile.")
			return nil, CreateAPIError(CodeDatabaseError)
		}

		log.Debug().Str("profileID", input.Profile).Msg("Renamed setting profile.")
		return CreateOutput(OutputSuccessBody{Success: true}), nil
	})

	hureg.Delete(WithOptions(api, reg, APIRoute{
		OperationID: "delete_settings_profile",
		Name:        "Delete Settings Profile",
		Description: "Deletes a setting profile and all of its overrides.",
		Errors: APIErrorCodes{
			CodeConflict:      "Cannot delete the last remaining profile.",
			CodeDatabaseError: "Failed to write to database.",
			CodeNotFound:      "Profile not found.",
		}}), "/profiles/{profile}", func(ctx context.Context, input *struct {
		// Profile ID
		Profile string `path:"profile"`
	}) (*Output[OutputSuccessBody], error) {
		currentUser := GetAuthorizedUser(ctx)

		// get the referenced profile to delete
		toDelete, err := getOwnedProfile(ctx, reg.DB, currentUser.ID, input.Profile)
		if err != nil {
			return nil, err
		}

		// make sure we arent deleting the only remaining profile
		count, err := reg.DB.SettingProfile.Query().
			Where(settingprofile.HasUserWith(user.ID(currentUser.ID))).
			Count(ctx)
		if err != nil {
			return nil, CreateAPIError(CodeDatabaseError)
		}
		if count <= 1 {
			return nil, CreateAPIErrorDetail(CodeConflict, "profile")
		}

		// actually delete
		if err = reg.DB.SettingProfile.DeleteOne(toDelete).Exec(ctx); err != nil {
			log.Err(err).Msg("Failed to delete settings profile.")
			return nil, CreateAPIError(CodeDatabaseError)
		}

		return CreateOutput(OutputSuccessBody{Success: true}), nil
	})

	//
	// Setting Profile Value Changes
	//
	hureg.Get(WithOptions(api, reg, APIRoute{
		OperationID: "get_settings_profile_values",
		Name:        "Get Settings Profile Values",
		Description: "Gets all setting overrides in a profile.",
		Errors: APIErrorCodes{
			CodeDatabaseError: "Failed to read from database.",
			CodeNotFound:      "Profile not found.",
		}}), "/profiles/{profile}/values", func(ctx context.Context, input *struct {
		// Profile ID
		Profile string `path:"profile"`
	}) (*Output[SettingValuesBody], error) {
		currentUser := GetAuthorizedUser(ctx)

		// get referenced profile
		profile, err := getOwnedProfile(ctx, reg.DB, currentUser.ID, input.Profile)
		if err != nil {
			return nil, err
		}

		// query all the values from the profile
		values, err := profile.QueryValues().
			Order(ent.Asc(settingvalue.FieldSettingID)).
			All(ctx)
		if err != nil {
			return nil, CreateAPIError(CodeDatabaseError)
		}

		// construct a map of entries
		list := make(map[string]*SettingValueEntry, len(values))
		for _, item := range values {
			list[item.SettingID] = &SettingValueEntry{
				Value:     item.Value,
				UpdatedAt: item.UpdatedAt,
			}
		}
		return CreateOutput(SettingValuesBody{Values: list}), nil
	})

	hureg.Put(WithOptions(api, reg, APIRoute{
		OperationID: "update_settings_profile_value",
		Name:        "Update Settings Profile Value",
		Description: "Sets a setting override in a profile.",
		Errors: APIErrorCodes{
			CodeDatabaseError: "Failed to write to database.",
			CodeInvalidInput:  "Value does not match the setting definition.",
			CodeNotFound:      "Setting or profile not found.",
		}}), "/profiles/{profile}/values/{settingID}", func(ctx context.Context, input *struct {
		// Profile ID
		Profile   string `path:"profile"`
		SettingID string `path:"settingID"`
		Body      struct {
			// JSON-encoded value text, typed to the setting definition.
			Value string `json:"value"`
		}
	}) (*Output[SettingValueEntry], error) {
		currentUser := GetAuthorizedUser(ctx)

		// get referenced profile
		profile, err := getOwnedProfile(ctx, reg.DB, currentUser.ID, input.Profile)
		if err != nil {
			return nil, err
		}

		// get setting key from the registry
		def := settings.ClientRegistry.Find(input.SettingID)
		if def == nil {
			return nil, CreateAPIErrorDetail(CodeNotFound, "setting")
		}
		// validate value text
		value, err := settings.ValidateValue(def, input.Body.Value)
		if err != nil {
			log.Debug().Err(err).Str("key", def.ID).Str("value", input.Body.Value).Msg("Failed to validate setting override value.")
			return nil, CreateAPIErrorDetail(CodeInvalidInput, "value")
		}

		var entry *SettingValueEntry

		// grab an existing override
		existing, err := profile.QueryValues().
			Where(settingvalue.SettingIDEQ(input.SettingID)).
			First(ctx)

		// failed to fetch existing, so create one
		if err != nil {
			// error other than not-found
			if !ent.IsNotFound(err) {
				log.Err(err).Msg("Failed to read settings override from database.")
				return nil, CreateAPIError(CodeDatabaseError)
			}

			// create the override
			created, err := reg.DB.SettingValue.Create().
				SetSettingID(input.SettingID).
				SetValue(value).
				SetProfile(profile).
				Save(ctx)
			if err != nil {
				log.Err(err).Msg("Failed to create setting override.")
				return nil, CreateAPIError(CodeDatabaseError)
			}

			entry = &SettingValueEntry{Value: created.Value, UpdatedAt: created.UpdatedAt}
		} else {
			// otherwise update the existing override
			updated, err := existing.Update().
				SetValue(value).
				Save(ctx)
			if err != nil {
				log.Err(err).Msg("Failed to update setting override.")
				return nil, CreateAPIError(CodeDatabaseError)
			}

			entry = &SettingValueEntry{Value: updated.Value, UpdatedAt: updated.UpdatedAt}
		}

		return CreateOutput(*entry), nil
	})
}
