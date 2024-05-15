<script lang="ts">
	import LibraryCard from "$lib/LibraryCard.svelte";
	import LibraryScroller from "$lib/LibraryScroller.svelte";
	import type { ArtistJSON } from "$lib/TEST";
	import { getToastStore } from "@skeletonlabs/skeleton";

	const toasts = getToastStore();

	export let artist: ArtistJSON;
</script>

<LibraryScroller cardType="art" items={artist.albums} let:data>
	{#each data.cards as album (album.id)}
		<LibraryCard
			type="art"
			name={album.name}
			subtext={album.year}
			href="/server/flixur.app/music/{artist.id}/{album.id}"
			image={album.icon}
			on:play={() => toasts.trigger({ message: "play button clicked" })}
			on:context={() => toasts.trigger({ message: "context button clicked" })}
		/>
	{/each}
</LibraryScroller>
