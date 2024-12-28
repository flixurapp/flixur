<script lang="ts">
	import chunk from "lodash/chunk";
	import VirtualScroll from "svelte-virtual-scroll-list";
	import type { LibraryCardType } from "./LibraryCard";

	interface Props {
		/** Type of cards in the scroller. Required for size calculations. */
		cardType: LibraryCardType;
		//TODO: add typings
		items: any[];
		header?: import("svelte").Snippet;
		children?: import("svelte").Snippet<[any]>;
	}

	let { cardType, items, header, children }: Props = $props();

	let innerWidth = $state(0),
		offsetWidth = $state(0),
		offsetHeight = $state(0);

	const header_render = $derived(header);
	const children_render = $derived(children);
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
					: 3,
			).map((i, id) => ({
				id,
				cards: i,
			}))}
			keeps={15}
		>
			{#snippet header()}
				{@render header_render?.()}
			{/snippet}
			{#snippet children({ data })}
				<div class="flex sm:gap-4 sm:py-1 gap-2 py-0.5 items-center justify-center snap-start">
					{@render children_render?.({ data })}
				</div>
			{/snippet}
		</VirtualScroll>
	</div>
</div>
