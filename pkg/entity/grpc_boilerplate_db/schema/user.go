package schema

import (
	"entgo.io/ent"
	"entgo.io/ent/schema/field"
)

type User struct {
	ent.Schema
}

// Fields of the User.
func (User) Fields() []ent.Field {
	return []ent.Field{
		field.String("name"),
		field.String("email"),
		field.String("password"),
		field.String("phone"),
		field.String("address"),
		field.String("role"),
		field.Bool("is_active"),
		field.Time("created_at"),
		field.Time("updated_at"),
	}
}

// Edges of the User.
func (User) Edges() []ent.Edge {
	return nil
}
