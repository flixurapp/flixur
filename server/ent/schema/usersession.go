// ent/schema/session.go
package schema

import (
	"time"

	"entgo.io/ent"
	"entgo.io/ent/schema/edge"
	"entgo.io/ent/schema/field"
)

// A valid user session.
type UserSession struct {
	ent.Schema
}

func (UserSession) Fields() []ent.Field {
	return []ent.Field{
		field.String("ip_address").
			NotEmpty().Immutable().
			Comment("IP address at the time of login."),
		field.String("platform").
			Immutable().
			Comment("The platform the session was created on. Usually name + version."),
		field.Time("created_at").
			Default(time.Now).Immutable().
			Comment("Timestamp this session was created at."),
		field.Time("last_seen_at").
			Default(time.Now).UpdateDefault(time.Now).
			Comment("Last time this session was used — update on each authenticated request, or throttle to e.g. once per hour"),
	}
}

func (UserSession) Edges() []ent.Edge {
	return []ent.Edge{
		edge.From("user", User.Type).Ref("sessions").
			Unique().Required().Immutable().
			Comment("The user this session belongs to."),
	}
}

func (UserSession) Mixin() []ent.Mixin {
	return []ent.Mixin{
		ULIDMixin{},
	}
}
