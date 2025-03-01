<script lang="ts">
	import { page } from "$app/state";
	import { SCHEME, type ArtistJSON } from "$lib/api";
	import ArtistPage from "./ArtistPage.svelte";

	let fetchArtist: () => Promise<ArtistJSON | null> = async () => {
		let response: Response | null = null;

		try {
			// artist = TEST_DATA.find((a) => a.id == page.params.primaryID) ?? null;
			response = await fetch(
				`${SCHEME}://${page.params.domain}/${page.params.library}/${page.params.primaryID}`,
			);
			return await response.json();
		} catch (error) {
			console.error(error);

			if (response && response.status === 404) {
				return null;
			} else {
				throw error;
			}
		}
	};
</script>

<div class="flex flex-col h-full">
	{#await fetchArtist() then artist}
		{#if artist}
			<ArtistPage {artist} />
		{:else}
			<p>Artist not found</p>
		{/if}
	{:catch error}
		{error.message}
	{/await}
</div>
