<script lang="ts" generics="T extends any">
	import chunk from "lodash/chunk";
	import type { Snippet } from "svelte";
	import { VList } from "virtua/svelte";
	import type { LibraryCardType } from "./LibraryCard";

	interface Props<T> {
		/** Type of cards in the scroller. Required for size calculations. */
		cardType: LibraryCardType;
		items: T[];
		header?: Snippet;
		children?: Snippet<[T[]]>;
	}

	let { cardType, items, header, children }: Props<T> = $props();

	let innerWidth = $state(0),
		offsetWidth = $state(0),
		offsetHeight = $state(0);

	const header_render = $derived(header);
	const children_render = $derived(children);

	const chunkedData = $derived(
		chunk(
			items,
			innerWidth > 640
				? // divide out the card width (256/128px) and padding (16px)
					Math.floor(offsetWidth / ((cardType == "thumbnail" ? 256 : 128) + 16))
				: 3,
		),
	);
</script>

<svelte:window bind:innerWidth />

<div class="h-full flex-1" bind:offsetHeight>
	<!-- TODO: scroll snap setting -->
	<div
		class="{true ? '' : 'not-pointer-coarse:[&>:first-child]:snap-y'} [&>:first-child]:px-2.5"
		style:height="{offsetHeight}px"
		bind:offsetWidth
	>
		{#if header_render}
			{@render header_render()}
		{/if}
		<VList data={chunkedData} overscan={25} shift={true}>
			{#snippet children(item)}
				<div class="flex sm:gap-4 sm:py-1 gap-2 py-0.5 items-center justify-center snap-start">
					{@render children_render?.(item)}
				</div>
			{/snippet}
		</VList>
	</div>
</div>
