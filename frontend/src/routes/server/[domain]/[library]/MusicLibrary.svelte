<script lang="ts">
	import LibraryCard from "$lib/LibraryCard.svelte";
	import LibraryScroller from "$lib/LibraryScroller.svelte";
	import { TEST_DATA } from "$lib/api";
	import { type ToastContext } from "@skeletonlabs/skeleton-svelte";
	import { getContext } from "svelte";

	export const toasts: ToastContext = getContext("toast");
</script>

<LibraryScroller cardType="art" items={TEST_DATA}>
	{#snippet children({ data })}
		{#each data.cards as artist (artist.id)}
			<LibraryCard
				type="art"
				name={artist.name}
				href="/server/flixur.app/music/{artist.id}"
				image={artist.icon}
				onplay={() => toasts.create({ description: "play button clicked" })}
				oncontextmenu={() => toasts.create({ description: "context button clicked" })}
			/>
		{/each}
	{/snippet}
</LibraryScroller>
