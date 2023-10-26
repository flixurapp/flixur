<script lang="ts">
	import LibraryCard from "$lib/LibraryCard.svelte";
	import LibraryScroller from "$lib/LibraryScroller.svelte";
	import { getToastStore } from "@skeletonlabs/skeleton";

	const toasts = getToastStore();
</script>

<LibraryScroller items={new Array(1500).fill(null)} let:data>
	{#each data.card as album (album.id)}
		<LibraryCard
			type="art"
			name="Aluna"
			href="/server/flixur.app/music/artistid"
			image="https://i.scdn.co/image/ab6761610000e5ebfd31c630c1a72de7e89a2be7"
			on:play={() => toasts.trigger({ message: "play button clicked" })}
			on:edit={() => toasts.trigger({ message: "edit button clicked" })}
		/>
	{/each}
</LibraryScroller>
