<script lang="ts">
	import { page } from "$app/state";
	import { TEST_DATA, type ArtistJSON } from "$lib/TEST";
	import ArtistPage from "./ArtistPage.svelte";

	let artist: ArtistJSON | null = $state(null);

	//TODO: temp
	$effect(() => {
		artist = TEST_DATA.find((a) => a.id == page.params.primaryID) ?? null;
	});
</script>

<div class="flex flex-col h-full">
	{#if artist}
		<ArtistPage {artist} />
	{:else}
		no artist found
	{/if}
</div>
