<script lang="ts">
	import LibraryCardMusic from "$lib/LibraryCardMusic.svelte";
	import { getToastStore } from "@skeletonlabs/skeleton";
	import { VirtualScroll } from "svelte-virtual-scroll-list";

	let innerWidth = 0,
		offsetWidth = 0,
		offsetHeight = 0;

	const toasts = getToastStore();
</script>

<svelte:window bind:innerWidth />

<div class="h-full" bind:offsetHeight>
	<div class="vs" style:height="{offsetHeight}px" bind:offsetWidth>
		<VirtualScroll
			data={new Array(1500).fill(null).map(() => ({
				id: Math.random(),
				card: new Array(innerWidth > 640 ? Math.floor(offsetWidth / 128) : 3)
					.fill(null)
					.map(() => ({ id: Math.random() })),
			}))}
			let:data
		>
			<div class="flex sm:gap-4 sm:py-1 gap-2 py-0.5 items-center justify-center snap-start">
				{#each data.card as album (album.id)}
					<LibraryCardMusic
						name="MYCELiUM"
						href="/server/flixur.app/music/artistid/albumid"
						image="https://i.scdn.co/image/ab67616d0000b273791e5ad29bbd6253aa453293"
						on:play={() => toasts.trigger({ message: "play button clicked" })}
						on:edit={() => toasts.trigger({ message: "edit button clicked" })}
					/>
				{/each}
			</div>
		</VirtualScroll>
	</div>
</div>

<style>
	.vs :global(.virtual-scroll-root) {
		@apply has-pointer:snap-y has-pointer:snap-mandatory;
	}
</style>
