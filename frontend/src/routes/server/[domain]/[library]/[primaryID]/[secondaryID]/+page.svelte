<script lang="ts">
	import { page } from "$app/state";
	import { TEST_DATA, type AlbumJSON, type ArtistJSON } from "$lib/TEST";
	import AlbumPage from "./AlbumPage.svelte";

	let artist: ArtistJSON | null = $state(null);
	//TODO: temp
	$effect(() => {
		artist = TEST_DATA.find((a) => a.id == page.params.primaryID) ?? null;
	});
	let album: AlbumJSON | null = $state(null);
	//TODO: temp
	$effect(() => {
		album = artist?.albums.find((a) => a.id == page.params.secondaryID) ?? null;
	});
</script>

<div class="flex flex-col h-full px-2.5">
	{#if artist && album}
		<AlbumPage {artist} {album} />
	{:else}
		album not found
	{/if}
</div>
