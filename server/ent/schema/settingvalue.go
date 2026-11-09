package schema

import (
	"time"

	"entgo.io/ent"
	"entgo.io/ent/schema/edge"
	"entgo.io/ent/schema/field"
	"entgo.io/ent/schema/index"
)

// One setting's value override inside a SettingProfile.
type SettingValue struct {
	ent.Schema
}

func (SettingValue) Fields() []ent.Field {
	return []ent.Field{
		field.String("setting_id").
			NotEmpty().
			Comment("Dotted ID of the setting this overrides."),
		field.String("value").
			NotEmpty().
			Comment("JSON-encoded override value, typed to the actual setting."),
		field.Time("updated_at").
			Default(time.Now).UpdateDefault(time.Now).
			Comment("Timestamp this override was last written, used for cross-device sync."),
	}
}

func (SettingValue) Edges() []ent.Edge {
	return []ent.Edge{
		edge.From("profile", SettingProfile.Type).Ref("values").
			Unique().Required().Immutable().
			Comment("The profile this override belongs to."),
	}
}

func (SettingValue) Indexes() []ent.Index {
	return []ent.Index{
		// at most one override per setting per profile
		index.Fields("setting_id").Edges("profile").Unique(),
	}
}

func (SettingValue) Mixin() []ent.Mixin {
	return []ent.Mixin{
		ULIDMixin{},
	}
}
