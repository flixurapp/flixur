package schema

// GetRequest fetches a single item by ID. Shared by all Get* requests below.
type GetRequest struct {
	ID string `json:"id"`
}

// SearchRequest searches for items matching a query. Shared by all Search* requests below.
type SearchRequest struct {
	Query string `json:"query"`
	// Limit of items to fetch. Will be clamped to max request size limit if applicable.
	Limit int32 `json:"limit"`
}

/* GetArtist */

type ArtistGetRequest = GetRequest

type ArtistGetResponse struct {
	Artist Artist `json:"artist"`
}

/* SearchArtists */

type ArtistSearchRequest = SearchRequest

type ArtistSearchResponse struct {
	Results []Artist `json:"results"`
}

/* GetAlbum */

type AlbumGetRequest = GetRequest

type AlbumGetResponse struct {
	Album Album `json:"album"`
}

/* SearchAlbums */

type AlbumSearchRequest = SearchRequest

type AlbumSearchResponse struct {
	Results []Album `json:"results"`
}

/* GetTrack */

type TrackGetRequest = GetRequest

type TrackGetResponse struct {
	Track Track `json:"track"`
}

/* SearchTracks */

type TrackSearchRequest = SearchRequest

type TrackSearchResponse struct {
	Results []Track `json:"results"`
}
