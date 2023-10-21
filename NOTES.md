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

The server creates a config directory. It creates a default config.yaml file.

The server creates an empty `plugins` directory. The server does not load directories, plugin binaries are placed in the plugins folder. Plugins are `Load()`ed in alphabetical order. The server then determines which plugins are enabled and `Start()`s them in the same order taking into account any dependencies. If a plugin has a dependency and it's not loaded yet, load it first (and if that dep has another dep, load it first, etc). If a plugin has a recursive dependency (ex. A depends on B and B depends on A) then error and don't load either plugin. If a plugin's dependency doesn't load or is disabled/missing then log an error and don't load the plugin. Plugins should only emit errors and not crash the server.

## Plugins

There is a plugin manager on the client that lets you add plugin "sources" via git url, it'll clone the repo to a sources directory and allow you to install the plugins inside it.

A source repo must have a `flixur_plugins.yaml` file at the root describing its contents:
```yaml
# Name of the repo.
name: "Official Flixur Plugins"
# Maintainer of the repo.
author: "Flixur"
# Icon URL or local path to a file.
icon: "./icon.png"
```

When loading a repo, if the icon is a local path, the server should change the icon to the path it's being served from when sending the information to the client.

Sources can be "refreshed" which just runs git reset (to avoid any conflicts) and git pull in the directory.

Each plugin directory should have a `plugin.yaml` inside:
```yaml
# A name for the plugin.
name: "My Plugin"
# A unique ID for the plugin. For non-official plugins it's best to use a prefix to avoid conflict.
id: "flixurUser101/my-plugin"
# A short description of what the plugin does.
description: "Does cool things."
# The name of the plugin author.
author: "Flixur User"
# A version string preferably in semver format.
version: "0.0.1"
# Type of plugin, can be one of provider-sound/provider-video/downloader/server
type: "server"
# List of plugin dependencies.
dependencies: []
```

Dependencies are other plugin IDs (usually server plugins) that will be loaded before this plugin. If a dependency does not load properly or is disabled, the plugin won't load.

Dependencies can be the ID ("yt-dlp") or include a "safe" version ("yt-dlp@1.0.0"). The safe version will log a warning if the dependency version is newer, as a newer dep version could cause issues.

Plugins cannot be unloaded without restarting the server. 

Starting the plugin is done with the `Start()` function. This function is called when the plugin is enabled and the server is ready to initialize it.

*Regarding Providers: 
Data from the Search functions may be incomplete. Data from the Get functions should be full.*

### Sound Providers

`SearchArtists(query: string): Artist[]` Search the provider for the artist by name.

`SearchAlbums(query: string, artist?: string): Album[]` Search the provider for the album name. Optionally search albums from a specific artist ID.

`SearchTracks(query: string, artist?: string, album?: string): Track[]` Search the provider for the track name. Optionally search tracks from a specific artist ID. Optionally search tracks from a specific album ID from the artist. If album is provided but artist is invalid, throw an error.

`GetArtist(id: string): Artist` Gets an artist from the provider by ID.
`GetAlbum(artistID: string, id: string): Album` Gets an album from the artist by ID.
`GetTrack(artistID: string, albumID: string, id: string): Track` Gets a track from the artist/album by ID.

#### Ideas

Spotify, SoundCloud, KONAMI (remywiki), BandLab, MusicBrainz

### Video Providers

`SearchShows(query: string): Show[]` Search the provider for a tv show by name.
`SearchEpisodes(query: string, showID: string, seasonID?: string): Episode[]` Search for episodes from a specified tv show and optionally season.

`SearchMovies(query: string): Movie[]` Search the provider for a movie by name.

`GetShow(id: string): Show` Gets a show from the provider by ID.
`GetSeason(showID: string, seasonID: string): Season` Gets a season from a show by ID.
`GetEpisode(showID: string, seasonID: string, id: string): Episode` Gets an episode from a show/season by ID.

`GetMovie(id: string): Movie` Gets a movie from the provider by ID.

#### Ideas

IMDb, TheTVDB

### Downloaders

`Search(query: string): Downloadable[]` Searches the provider for media by name.

`Get(id: string): Downloadable` Gets media from the provider by ID.

`Download(id: string): string` Downloads the media ID from the provider. Returns the path to the media file.

#### Ideas

YouTube, SoundCloud, Torrent Indexer/Downloader, NZB Indexer/Downloader

### Server Plugins

Also TBD, general idea is they run when the server runs and maybe get access (somehow) to some server functions like manipulating data.

The plugin can make a call to the server to register js to be injected into the client when it's served.

These also function as libraries that other plugins can require as a dependency. An example of this is a server plugin registering a yt-dlp binary for use in a sound provider. This makes it so that the binary is only downloaded once (on starting the server plugin) and can be used by other plugins.

#### ffmpeg

ID: ffmpeg
Name: ffmpeg
Description: Allows for media conversion using ffmpeg.

#### yt-dlp

ID: yt-dlp
Name: yt-dlp
Description: Allows for media downloading via yt-dlp.

This plugin downloads the (hardcoded) version of yt-dlp to the build directory and compiles it to a binary for the host arch. It then embeds the binary in the plugin for use. When the plugin is ran, it executes the binary "in-memory".

#### Media Importer

ID: media-importer
Name: Media Importer
Description: Allows importing of external media via a new tab on the client.

The plugin will let a user upload a media file for a specific track/episode/etc and will convert/tag/move it to match the target.
