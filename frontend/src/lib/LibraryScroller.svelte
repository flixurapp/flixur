<script lang="ts">
	import chunk from "lodash/chunk";
	import VirtualScroll from "svelte-virtual-scroll-list";

	export let items: any[];

	let innerWidth = 0,
		offsetWidth = 0,
		offsetHeight = 0;
</script>

<svelte:window bind:innerWidth />

<div class="h-full" bind:offsetHeight>
	<div
		class="has-pointer:[&>:first-child]:snap-y has-pointer:[&>:first-child]:snap-mandatory"
		style:height="{offsetHeight}px"
		bind:offsetWidth
	>
		<VirtualScroll
			data={chunk(items, innerWidth > 640 ? Math.floor(offsetWidth / 128) : 3).map((i, id) => ({
				id,
				card: new Array(i.length).fill(null).map((_, id) => ({ id })),
			}))}
			keeps={6}
			let:data
		>
			<div class="flex sm:gap-4 sm:py-1 gap-2 py-0.5 items-center justify-center snap-start">
				<slot {data} />
			</div>
		</VirtualScroll>
	</div>
</div>
