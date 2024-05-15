<script lang="ts">
	import { page } from "$app/stores";
	import { TEST_DATA, type AlbumJSON, type ArtistJSON } from "$lib/TEST";
	import AlbumPage from "./AlbumPage.svelte";

	let artist: ArtistJSON | null = null;
	$: artist = TEST_DATA.find((a) => a.id == $page.params.primaryID) ?? null;
	let album: AlbumJSON | null = null;
	$: album = artist?.albums.find((a) => a.id == $page.params.secondaryID) ?? null;
</script>

page for secondary (album, season) {$page.params.secondaryID}

{#if artist && album}
	<AlbumPage {artist} {album} />
{:else}
	album not found
{/if}
