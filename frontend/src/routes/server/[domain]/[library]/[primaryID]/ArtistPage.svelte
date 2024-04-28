<script lang="ts">
	import LibraryCard from "$lib/LibraryCard.svelte";
	import LibraryScroller from "$lib/LibraryScroller.svelte";
	import { getToastStore } from "@skeletonlabs/skeleton";

	const toasts = getToastStore();
</script>

<LibraryScroller cardType={"art"} items={new Array(1500).fill(null)} let:data>
	{#each data.card as album (album.id)}
		<LibraryCard
			type="art"
			name="MYCELiUM"
			subtext="2023"
			href="/server/flixur.app/music/artistid/albumid"
			image="https://i.scdn.co/image/ab67616d0000b273791e5ad29bbd6253aa453293"
			on:play={() => toasts.trigger({ message: "play button clicked" })}
			on:edit={() => toasts.trigger({ message: "edit button clicked" })}
		/>
	{/each}
</LibraryScroller>
