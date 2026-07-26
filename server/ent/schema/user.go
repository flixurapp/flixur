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
		field.String("username").Unique().MinLen(common.USERNAME_MIN_LENGTH).MaxLen(common.USERNAME_MAX_LENGTH),
		field.String("password").NotEmpty().Sensitive(),
		// If the user is an administrator, bypasses all permissions.
		field.Bool("isAdmin").Default(false),
		// Assigned permissions for this user.
		field.Strings("permissions").Default([]string{}),
	}
}

func (User) Edges() []ent.Edge {
	return []ent.Edge{
		edge.To("oidcLinks", UserLinkedOIDC.Type),
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
