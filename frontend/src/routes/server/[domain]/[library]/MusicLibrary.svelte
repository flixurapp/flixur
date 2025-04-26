<script lang="ts">
	import { toaster } from "$lib";
	import LibraryCard from "$lib/LibraryCard.svelte";
	import LibraryScroller from "$lib/LibraryScroller.svelte";
	import { TEST_DATA } from "$lib/TEST";
</script>

<LibraryScroller cardType="art" items={TEST_DATA}>
	{#snippet children({ data })}
		{#each data.cards as artist (artist.id)}
			<LibraryCard
				type="art"
				name={artist.name}
				href="/server/flixur.app/music/{artist.id}"
				image={artist.icon}
				onplay={() => toaster.create({ description: "play button clicked" })}
				oncontextmenu={() => toaster.create({ description: "context button clicked" })}
			/>
		{/each}
	{/snippet}
</LibraryScroller>
