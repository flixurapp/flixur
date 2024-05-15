<script lang="ts">
	import LibraryCard from "$lib/LibraryCard.svelte";
	import LibraryScroller from "$lib/LibraryScroller.svelte";
	import { TEST_DATA } from "$lib/TEST";
	import { getToastStore } from "@skeletonlabs/skeleton";

	const toasts = getToastStore();
</script>

<LibraryScroller cardType="art" items={TEST_DATA} let:data>
	{#each data.cards as artist (artist.id)}
		<LibraryCard
			type="art"
			name={artist.name}
			href="/server/flixur.app/music/{artist.id}"
			image={artist.icon}
			on:play={() => toasts.trigger({ message: "play button clicked" })}
			on:context={() => toasts.trigger({ message: "context button clicked" })}
		/>
	{/each}
</LibraryScroller>
