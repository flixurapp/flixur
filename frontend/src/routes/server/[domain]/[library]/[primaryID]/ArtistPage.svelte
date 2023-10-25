<script lang="ts">
	import LibraryCardMusic from "$lib/LibraryCardMusic.svelte";
	import { getToastStore } from "@skeletonlabs/skeleton";
	import { VirtualScroll } from "svelte-virtual-scroll-list";

	let innerWidth = 0,
		offsetWidth = 0;

	const toasts = getToastStore();
</script>

<svelte:window bind:innerWidth />

<div bind:offsetWidth>
	<VirtualScroll
		data={new Array(1500).fill(null).map(() => ({
			id: Math.random(),
			card: new Array(innerWidth > 640 ? Math.floor(offsetWidth / 128) : 3)
				.fill(null)
				.map(() => ({ id: Math.random() })),
		}))}
		key="id"
		let:data
		let:index
	>
		<div class="flex sm:gap-4 sm:mb-2 gap-2 mb-1 items-center justify-center">
			{#each data.card as album (album.id)}
				<LibraryCardMusic
					name="MYCELiUM {index}"
					href="/server/flixur.app/music/artistid/albumid"
					image="https://i.scdn.co/image/ab67616d0000b273791e5ad29bbd6253aa453293"
					on:play={() => toasts.trigger({ message: "play button clicked" })}
					on:edit={() => toasts.trigger({ message: "edit button clicked" })}
				/>
			{/each}
		</div>
	</VirtualScroll>
</div>
