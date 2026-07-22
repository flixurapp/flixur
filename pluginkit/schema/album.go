package schema

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
