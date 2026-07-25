package schema

import (
	"entgo.io/ent"
	"entgo.io/ent/schema/edge"
	"entgo.io/ent/schema/field"
	"forge.xela.codes/xela/flixur/common"
)

// User holds the schema definition for the User entity.
type User struct {
	ent.Schema
}

// Fields of the User.
func (User) Fields() []ent.Field {
	return []ent.Field{
		field.String("username").Unique().MinLen(common.USERNAME_MIN_LENGTH).MaxLen(common.USERNAME_MAX_LENGTH),
		field.String("password").NotEmpty(),
		// If the user is an administrator, bypasses all permissions.
		field.Bool("isAdmin").Default(false),
		// Assigned permissions for this user.
		field.Strings("permissions").Default([]string{}),
	}
}

// Edges of the User.
func (User) Edges() []ent.Edge {
	return []ent.Edge{
		edge.To("oidcLinks", UserLinkedOIDC.Type),
	}
}

// Mixin of the User.
func (User) Mixin() []ent.Mixin {
	return []ent.Mixin{
		ULIDMixin{},
	}
}
