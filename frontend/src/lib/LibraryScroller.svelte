<script lang="ts" generics="T extends { id: string }">
	import chunk from "lodash/chunk";
	import { useOverlayScrollbars } from "overlayscrollbars-svelte";
	import "overlayscrollbars/overlayscrollbars.css";
	import { onMount, type Snippet } from "svelte";
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
		offsetHeight = $state(0),
		container: HTMLDivElement;

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

	const [initBodyOverlayScrollbars, getBodyOverlayScrollbarsInstance] = useOverlayScrollbars({
		defer: true,
		events: {
			initialized(osInstance) {
				const elements = osInstance.elements();
				elements.scrollbarVertical.scrollbar.classList.add("!top-13", "not-md:!bottom-20");
			},
		},
		options: {
			scrollbars: {
				theme: "os-theme-light",
				clickScroll: true,
			},
			overflow: {
				x: "hidden",
				y: "scroll",
			},
		},
	});

	onMount(() => {
		initBodyOverlayScrollbars({
			target: container,
			elements: {
				viewport: <HTMLDivElement>container.firstElementChild,
			},
		});

		setTimeout(() => {
			getBodyOverlayScrollbarsInstance()?.update(true);
		}, 1000);
	});
</script>

<svelte:window bind:innerWidth />

<div class="h-full flex-1" bind:offsetHeight>
	<!-- TODO: scroll snap setting -->
	<div
		class={[
			false && "not-pointer-coarse:[&>:first-child]:snap-y",
			"[&>:first-child]:!px-2.5", // left/right padding
			"[&>:first-child]:!pt-13", // padding for top menu bar
			"not-md:[&>:first-child]:!pb-20", // mobile padding for bottom menu bar
		]}
		style:height="{offsetHeight}px"
		bind:offsetWidth
		bind:this={container}
	>
		{#if header_render}
			{@render header_render()}
		{/if}
		<VList data={chunkedData} overscan={15}>
			{#snippet children(item)}
				<div class="flex sm:gap-4 sm:py-1 gap-2 py-0.5 items-center justify-center">
					{@render children_render?.(item)}
				</div>
			{/snippet}
		</VList>
	</div>
</div>
