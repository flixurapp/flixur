# Ideas

## Overall

Name: Flixur

Theme Color: #3366DE

![](https://img.shields.io/badge/PREVIEW-3366DE)

## Frontend

Tools: esbuild, svelte, typescript, flowbite

## Backend

Tools: go, ffmpeg, yt-dlp

Metadata and sound plugins are called “providers”.

The server compiles into a single binary, all other tools should be either downloaded or extracted from the binary.

The binary creates a config directory. It downloads the latest (but specific, not just “any” to prevent compatibility issues) versions of yt-dlp and ffmpeg for the platform and stores it in the config directory maybe in a `bin` folder.

## Plugins

*Regarding Providers: 
Data from the Search functions may be incomplete. Data from the Get functions should be full.*

All plugins have a `Start()` function that gets run whenever the plugin is loaded. Plugins cannot be unloaded without restarting the server.

### Metadata Providers

Examples: spotify, soundcloud, musicbrainz

`SearchArtists(query: string): Artist[]` Search the provider for the artist by name.

`SearchAlbums(query: string, artist?: string): Album[]` Search the provider for the album name. Optionally search albums from a specific artist ID.

`SearchTracks(query: string, artist?: string, album?: string): Track[]` Search the provider for the track name. Optionally search tracks from a specific artist ID. Optionally search tracks from a specific album ID from the artist. If album is provided but artist is invalid, throw an error.

`GetArtist(id: string): Artist` Gets an artist from the provider by ID.
`GetAlbum(artistID: string, id: string): Album` Gets an album from the artist by ID.
`GetTrack(artistID: string, albumID: string, id: string): Track` Gets a track from the artist/album by ID.

### Sound Providers

`Search(query: string): Downloadable[]` Searches the provider for media by name.

`Get(id: string): Downloadable` Gets media from the provider by ID.

`Download(id: string): string` Downloads the media ID from the provider. Returns the path to the FLAC file.

### Client Plugins

These are mostly TBD but the general idea is the plugin registers some javascript or css that gets injected into the client.

### Server Plugins

Also TBD, general idea is they run when the server runs and maybe get access (somehow) to some server functions like manipulating data.
