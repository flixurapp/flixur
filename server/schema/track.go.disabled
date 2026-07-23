package schema

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
