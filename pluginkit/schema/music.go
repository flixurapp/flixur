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

type AlbumType int32

const (
	AlbumTypeSingle AlbumType = 0
	AlbumTypeAlbum  AlbumType = 1
)

type Album struct {
	// Unique ID for the album.
	ID string `json:"id"`
	// IDs of artists on this album.
	Artists []string `json:"artists"`

	// Name of the album.
	Name string `json:"name"`
	// Cover URL for album art. Should be accessible via HTTP with CORS.
	Icon *string `json:"icon,omitempty"`
	// Unix timestamp the album was released. (in seconds)
	Date int64 `json:"date"`
	// Type of the album.
	Type AlbumType `json:"type"`
	// Rating for the track.
	Rating *int32 `json:"rating,omitempty"`

	// Description of the album.
	Description *string `json:"description,omitempty"`
	// List of genres for the album.
	Genres []string `json:"genres"`
}

type TrackExplicitness int32

const (
	// Normal
	TrackExplicitnessClean TrackExplicitness = 0
	// Explicit
	TrackExplicitnessExplicit TrackExplicitness = 1
	// Rated X
	TrackExplicitnessRestricted TrackExplicitness = 2
)

type Track struct {
	// Unique ID for the track.
	ID string `json:"id"`
	// Unique ISRC of the track. May be unofficial.
	ISRC string `json:"isrc"`
	// IDs of artists on this track.
	Artists []string `json:"artists"`

	// Title of the track.
	Title string `json:"title"`
	// Track number in the album.
	Index int32 `json:"index"`
	// Duration in ms of the track.
	Duration int64 `json:"duration"`
	// Rating for the track.
	Rating *int32 `json:"rating,omitempty"`
	// The explicitness of the track.
	Explicitness TrackExplicitness `json:"explicitness"`
}
