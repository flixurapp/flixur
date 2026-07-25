package schema

import (
	"entgo.io/ent"
	"entgo.io/ent/schema/field"
	"entgo.io/ent/schema/mixin"
	"github.com/oklog/ulid/v2"
)

// Uses ULIDs for the `id` field of this schema.
type ULIDMixin struct {
	mixin.Schema
}

// Fields of the Mixin.
func (ULIDMixin) Fields() []ent.Field {
	return []ent.Field{
		field.String("id").DefaultFunc(func() string {
			return ulid.Make().String()
		}).Immutable().Unique(),
	}
}
