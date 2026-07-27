// ent/schema/session.go
package schema

import (
	"context"
	"time"

	"entgo.io/ent"
	"entgo.io/ent/schema/edge"
	"entgo.io/ent/schema/field"
	"forge.xela.codes/xela/flixur/common"
)

// A valid user session.
type UserSession struct {
	ent.Schema
}

func (UserSession) Fields() []ent.Field {
	return []ent.Field{
		field.String("token").
			NotEmpty().Unique().Immutable().Sensitive().
			Comment("The hashed session token string."),
		field.String("ip_address").
			NotEmpty().Immutable().
			Comment("IP address at the time of login."),
		field.String("platform").
			Immutable().
			Comment("The platform string the session was created on."),
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

func (UserSession) Hooks() []ent.Hook {
	return []ent.Hook{
		// hash tokens before write
		func(next ent.Mutator) ent.Mutator {
			return ent.MutateFunc(func(ctx context.Context, m ent.Mutation) (ent.Value, error) {
				if token, ok := m.Field("token"); ok {
					if plain, ok := token.(string); ok && plain != "" {
						if err := m.SetField("token", common.SHA256Hex(plain)); err != nil {
							return nil, err
						}
					}
				}
				return next.Mutate(ctx, m)
			})
		},
	}
}
