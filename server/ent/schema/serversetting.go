package schema

import (
	"time"

	"entgo.io/ent"
	"entgo.io/ent/dialect"
	"entgo.io/ent/schema/field"
	"entgo.io/ent/schema/index"

	"forge.xela.codes/xela/flixur/settings"
)

// One server-scoped setting's stored value.
type ServerSetting struct {
	ent.Schema
}

func (ServerSetting) Fields() []ent.Field {
	return []ent.Field{
		field.String("setting_id").
			NotEmpty().
			Comment("Dotted ID of the server setting this stores."),
		field.Other("value", settings.SettingText{}).
			SchemaType(map[string]string{
				dialect.SQLite:   "text",
				dialect.Postgres: "text",
			}).
			Comment("JSON-encoded value, typed to the actual setting. Encrypted if the setting is secret."),
		field.Time("updated_at").
			Default(time.Now).UpdateDefault(time.Now).
			Comment("Timestamp this value was last written."),
	}
}

func (ServerSetting) Indexes() []ent.Index {
	return []ent.Index{
		// at most one stored value per setting
		index.Fields("setting_id").Unique(),
	}
}

func (ServerSetting) Mixin() []ent.Mixin {
	return []ent.Mixin{
		ULIDMixin{},
	}
}
