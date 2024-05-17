// Code generated by tygo. DO NOT EDIT.

//////////
// source: music.pb.go

export type AlbumType = number /* int32 */;
export const AlbumType_SINGLE: AlbumType = 0;
export const AlbumType_ALBUM: AlbumType = 1;
export interface Artist {
  /**
   * Unique ID of the artist. (should be unique across providers)
   */
  id: string;
  /**
   * Name of the artist.
   */
  name: string;
  /**
   * Icon URL for the artist. Should be accessible via HTTP with CORS.
   */
  icon?: string;
  /**
   * Rating for the artist.
   */
  rating?: number /* int64 */;
  /**
   * Description of the artist.
   */
  description?: string;
  /**
   * Geographical location of the artist.
   */
  location?: string;
  /**
   * Follower count for the artist. (using the platform of choice)
   */
  followers?: number /* int64 */;
}
export interface Album {
  /**
   * Unique ID for the album.
   */
  id: string;
  /**
   * IDs of artists on this album.
   */
  artists: string[];
  /**
   * Name of the album.
   */
  name: string;
  /**
   * Cover URL for album art. Should be accessible via HTTP with CORS.
   */
  icon?: string;
  /**
   * Unix timestamp the album was released. (in seconds)
   */
  date: number /* int64 */;
  /**
   * Type of the album.
   */
  type: AlbumType;
  /**
   * Rating for the track.
   */
  rating?: number /* int64 */;
  /**
   * Description of the album.
   */
  description?: string;
  /**
   * List of genres for the album.
   */
  genres: string[];
}
export interface Track {
  /**
   * Unique ID for the track.
   */
  id: string;
  /**
   * IDs of artists on this track.
   */
  artists: string[];
  /**
   * Title of the track.
   */
  title: string;
  /**
   * Track number in the album.
   */
  index: number /* int64 */;
  /**
   * Duration in ms of the track.
   */
  duration: number /* int64 */;
  /**
   * Rating for the track.
   */
  rating?: number /* int64 */;
  /**
   * If this track is explicit.
   */
  explicit: boolean;
}

//////////
// source: plugins.pb.go

export type PacketType = number /* int32 */;
export const PacketType_INIT: PacketType = 0; // PacketInit
export const PacketType_ARTIST_SEARCH: PacketType = 1; // PacketArtistSearch
export type PluginType = number /* int32 */;
export const PluginType_SERVER: PluginType = 0; // Provides additional functions to server.
export const PluginType_PROVIDER_AUDIO: PluginType = 1; // Provides audio metadata. (artist/album/track)
export const PluginType_PROVIDER_VIDEO: PluginType = 2; // Provides video metadata. (unused)
export const PluginType_DOWNLOADER: PluginType = 3; // Downloads requested content.
/**
 * Packets sent to the server from a plugin.
 */
export interface IncomingPluginPacket {
  /**
   * Type of the packet.
   */
  type: PacketType;
  /**
   * Identifier for the packet. (used to respond to certain requests)
   */
  id: string;
  /**
   * The actual packet data. (a protobuf)
   */
  data: string;
}
/**
 * Packets sent to a plugin from the server.
 */
export interface OutgoingPluginPacket {
  /**
   * Type of the packet.
   */
  type: PacketType;
  /**
   * Identifier for the packet. (echoed back in the response)
   */
  id: string;
  /**
   * The actual packet data. (a protobuf)
   */
  data: string;
}
/**
 * Sent by a plugin to identify itself when registered.
 */
export interface PacketInit {
  /**
   * Unique Plugin ID.
   */
  id: string;
  /**
   * Version string.
   */
  version: string;
  /**
   * Type of the plugin.
   */
  type: PluginType;
  /**
   * Name of the plugin.
   */
  name: string;
  /**
   * Short description of the plugin.
   */
  description: string;
  /**
   * Name of the plugin author.
   */
  author: string;
}
/**
 * Search for an artist using this plugin.
 * (supports: )
 */
export interface PacketArtistSearch {
  query: string;
}
