package schema

import (
	"time"

	"entgo.io/ent"
	"entgo.io/ent/schema/edge"
	"entgo.io/ent/schema/field"
	"entgo.io/ent/schema/index"
)

// A named profile of client settings, synced across devices.
type SettingProfile struct {
	ent.Schema
}

func (SettingProfile) Fields() []ent.Field {
	return []ent.Field{
		field.String("name").
			NotEmpty().MaxLen(100).
			Comment("Name of this profile, unique per user."),
		field.Time("created_at").
			Default(time.Now).Immutable().
			Comment("Timestamp this profile was created at."),
	}
}

func (SettingProfile) Edges() []ent.Edge {
	return []ent.Edge{
		edge.To("values", SettingValue.Type).
			Comment("Setting overrides stored in this profile."),
		edge.From("user", User.Type).Ref("setting_profiles").
			Unique().Required().Immutable().
			Comment("The user this profile belongs to."),
	}
}

func (SettingProfile) Indexes() []ent.Index {
	return []ent.Index{
		index.Fields("name").Edges("user").Unique(),
	}
}

func (SettingProfile) Mixin() []ent.Mixin {
	return []ent.Mixin{
		ULIDMixin{},
	}
}
