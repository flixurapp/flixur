package schema

// Usually an artist returned from a provider.
type Artist struct {
	// ID of the artist from the provider.
	ID string `json:"id"`
	// ID of the plugin that provided this artist.
	Provider string `json:"provider"`

	// Name of the artist.
	Name string `json:"name"`
	// Icon URL for the artist. Should be accessible via HTTP with CORS.
	Icon *string `json:"icon,omitempty"`

	// Description of the artist.
	Description *string `json:"description,omitempty"`
	// Geographical location of the artist.
	Location *string `json:"location,omitempty"`
	// Follower count for the artist. (using the platform of choice)
	Followers *int64 `json:"followers,omitempty"`
}

// An artist stored locally.
type LocalArtist struct {
	// Unique ID for the artist. (unique across providers)
	ID string `json:"id"`
	// Base metadata for the artist.
	Metadata Artist `json:"metadata"`

	// Rating for the artist.
	Rating *int32 `json:"rating,omitempty"`
}
