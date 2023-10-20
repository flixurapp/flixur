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

All plugins have a `Load(): PluginMetadata` function that gets called whenever the plugin is loaded. Plugins cannot be unloaded without restarting the server. The load function returns the plugin name, type, and other info. Load should not be used for anything besides metadata as this is called even if the plugin is disabled.

This data should include plugin name, description, author, version, type, dependencies, and unique ID.

Dependencies are other plugin IDs (usually server plugins) that will be loaded before this plugin. If a dependency does not load properly or is disabled, the plugin won't load.

Actually initializing the plugin is done with the `Start()` function. Z This function is called when the plugin is enabled and the server is ready to initialize it.

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

These also function as libraries that other plugins can require as a dependency. An example of this is a server plugin registering a yt-dlp binary for use in a sound provider. This makes it so that the binary is only downloaded once (on starting the server plugin) and can be used by other plugins.
