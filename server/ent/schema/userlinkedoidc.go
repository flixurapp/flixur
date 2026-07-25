package schema

import (
	"entgo.io/ent"
	"entgo.io/ent/schema/edge"
	"entgo.io/ent/schema/field"
	"entgo.io/ent/schema/index"
)

// UserLinkedOIDC holds the schema definition for the UserLinkedOIDC entity.
type UserLinkedOIDC struct {
	ent.Schema
}

// Fields of the UserLinkedOIDC.
func (UserLinkedOIDC) Fields() []ent.Field {
	return []ent.Field{
		field.String("issuer").NotEmpty(),
		field.String("subject").NotEmpty(),
	}
}

// Edges of the UserLinkedOIDC.
func (UserLinkedOIDC) Edges() []ent.Edge {
	return []ent.Edge{
		edge.From("user", User.Type).Ref("oidcLinks").Required().Unique(),
	}
}

// Indexes of the UserLinkedOIDC.
func (UserLinkedOIDC) Indexes() []ent.Index {
	return []ent.Index{
		// these are used to lookup a login
		index.Fields("issuer", "subject").Unique(),
	}
}
