<script lang="ts">
	import chunk from "lodash/chunk";
	import VirtualScroll from "svelte-virtual-scroll-list";
	import type { LibraryCardType } from "./LibraryCard";

	/** Type of cards in the scroller. Required for size calculations. */
	export let cardType: LibraryCardType;
	//TODO: add typings
	export let items: any[];

	let innerWidth = 0,
		offsetWidth = 0,
		offsetHeight = 0;
</script>

<svelte:window bind:innerWidth />

<div class="h-full flex-1" bind:offsetHeight>
	<!-- TODO: scroll snap setting -->
	<div
		class="{true ? '' : 'has-pointer:[&>:first-child]:snap-y'} [&>:first-child]:px-2.5"
		style:height="{offsetHeight}px"
		bind:offsetWidth
	>
		<VirtualScroll
			data={chunk(
				items,
				innerWidth > 640
					? // divide out the card width (256/128px) and padding (16px)
					  Math.floor(offsetWidth / ((cardType == "thumbnail" ? 256 : 128) + 16))
					: 3
			).map((i, id) => ({
				id,
				cards: i,
			}))}
			keeps={15}
			let:data
		>
			<svelte:fragment slot="header">
				<slot name="header" />
			</svelte:fragment>
			<div class="flex sm:gap-4 sm:py-1 gap-2 py-0.5 items-center justify-center snap-start">
				<slot {data} />
			</div>
		</VirtualScroll>
	</div>
</div>
