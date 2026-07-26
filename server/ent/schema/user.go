package schema

import (
	"context"

	"entgo.io/ent"
	"entgo.io/ent/schema/edge"
	"entgo.io/ent/schema/field"
	"forge.xela.codes/xela/flixur/common"
	"golang.org/x/crypto/bcrypt"
)

// User holds the schema definition for the User entity.
type User struct {
	ent.Schema
}

func (User) Fields() []ent.Field {
	return []ent.Field{
		field.String("username").
			Unique().
			MinLen(common.USERNAME_MIN_LENGTH).MaxLen(common.USERNAME_MAX_LENGTH).
			Comment("Username for this user."),
		field.String("password").
			NotEmpty().Sensitive().
			Comment("Password for this user."),
		field.Bool("is_admin").
			Default(false).
			Comment("If the user is an administrator, bypasses all permissions."),
		field.Strings("permissions").
			Default([]string{}).
			Comment("Assigned permissions for this user."),
	}
}

func (User) Edges() []ent.Edge {
	return []ent.Edge{
		edge.To("oidc_links", UserLinkedOIDC.Type).
			Comment("Linked OIDC providers for this account."),
		edge.To("sessions", UserSession.Type).
			Comment("Sessions for this user."),
	}
}

func (User) Mixin() []ent.Mixin {
	return []ent.Mixin{
		ULIDMixin{},
	}
}

func (User) Hooks() []ent.Hook {
	return []ent.Hook{
		// encrypt passwords before write
		func(next ent.Mutator) ent.Mutator {
			return ent.MutateFunc(func(ctx context.Context, m ent.Mutation) (ent.Value, error) {
				if pw, ok := m.Field("password"); ok {
					if plain, ok := pw.(string); ok && plain != "" {
						hash, err := bcrypt.GenerateFromPassword([]byte(plain), bcrypt.DefaultCost)
						if err != nil {
							return nil, err
						}
						if err := m.SetField("password", string(hash)); err != nil {
							return nil, err
						}
					}
				}
				return next.Mutate(ctx, m)
			})
		},
	}
}
