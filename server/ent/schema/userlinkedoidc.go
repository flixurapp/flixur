package schema

import "entgo.io/ent"

// UserLinkedOIDC holds the schema definition for the UserLinkedOIDC entity.
type UserLinkedOIDC struct {
	ent.Schema
}

// Fields of the UserLinkedOIDC.
func (UserLinkedOIDC) Fields() []ent.Field {
	return nil
}

// Edges of the UserLinkedOIDC.
func (UserLinkedOIDC) Edges() []ent.Edge {
	return nil
}
