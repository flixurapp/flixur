# Ideas

## Overall

Name: Flixur

Theme Color: #3366DE

## Frontend

Tools: esbuild, svelte, typescript, flowbite

## Backend

Tools: go, ffmpeg, yt-dlp

Metadata and sound plugins are called “providers”.

The server compiles into a single binary, all other tools should be either downloaded or extracted from the binary.

The binary creates a config directory. It downloads the latest (but specific, not just “any” to prevent compatibility issues) versions of yt-dlp and ffmpeg for the platform and stores it in the config directory maybe in a `bin` folder.

## Provider Plugins

### Metadata

Examples: spotify, soundcloud, musicbrainz

`SearchArtists(query: string)` Search the provider for the artist by name.

`SearchAlbums(query: string, artist?: string)` Search the provider for the album name. Optionally search albums from a specific artist ID.

`SearchTracks(query: string, artist?: string, album?: string)` Search the provider for the track name. Optionally search tracks from a specific artist ID. Optionally search tracks from a specific album ID from the artist. If album is provided but artist is invalid, throw an error.

`Get(artistID: string, albumID?: string, trackID?: string)` Gets the artist, album, or track from the provider by ID.

### Sound

`Search(query: string)` Searches the provider for media by name.

`Get(id: string): Downloadable`Gets media from the provider by ID.

`Download(id: string): string` Downloads the media ID from the provider. Returns the path to the FLAC file.