<!-- For Artists and Albums -->

<script lang="ts">
	import { Avatar } from "@skeletonlabs/skeleton";
	import { IconPencil, IconPlayerPlayFilled } from "@tabler/icons-svelte";
	import { createEventDispatcher, onMount } from "svelte";
	import type { LibraryCardType } from "./LibraryCard";
	import { Scrolling } from "./events/scroller";
	import { initials } from "./utils";

	/** Type of media in the card. `art` for artist/album. `poster` for tv/movies. `thumbnail` for episodes. */
	export let type: LibraryCardType;
	/** Name of the media. */
	export let name: string;
	/** Optional text to display below the name. */
	export let subtext: string | undefined = undefined;
	/** Link to the media. */
	export let href: string;
	/** Optional image URL for the media. If not specified, will use initials generated from `name`. */
	export let image: string | undefined = undefined;

	let mounted = false;

	const dispatch = createEventDispatcher();

	onMount(async () => {
		// wait for scroll to be finished before mounting
		Scrolling.onScrollEnd(() => {
			mounted = true;
		});
	});
</script>

<div
	class="flex flex-col [&>:first-child>div]:hover:opacity-100 sm:text-base text-sm shrink-0 {type ==
	'thumbnail'
		? 'sm:w-64 w-1/2'
		: 'sm:w-32 w-1/3'}"
>
	{#if mounted}
		<a
			{href}
			class="block relative w-full {type == 'thumbnail'
				? 'aspect-video'
				: type == 'poster'
				? 'aspect-[2/3]'
				: 'aspect-square'} rounded-token cursor-pointer"
		>
			<Avatar
				src={image}
				initials={initials(name)}
				class="absolute top-0 left-0 h-full"
				rounded="rounded-[inherit]"
				width="w-full"
				height="h-full"
			/>
			<div
				class="cant-hover:hidden p-2 gap-2 opacity-0 transition-opacity relative w-full h-full flex items-end justify-center rounded-[inherit] bg-black bg-opacity-50"
			>
				<button
					class="btn-icon btn-icon-sm variant-filled-primary mr-auto"
					on:click|preventDefault={() => dispatch("play")}
				>
					<IconPlayerPlayFilled />
				</button>
				<button
					class="btn-icon btn-icon-sm variant-filled-secondary"
					on:click|preventDefault={() => dispatch("edit")}
				>
					<IconPencil />
				</button>
			</div>
		</a>
		<a
			class="overflow-hidden [&>p]:whitespace-nowrap [&>p]:overflow-hidden [&>p]:overflow-ellipsis hover:underline"
			{href}
		>
			<p>{name}</p>
			{#if subtext}
				<p class="opacity-50">
					{subtext}
				</p>
			{/if}
		</a>
	{:else}
		<!-- attempting to make this as "light" as possible, so the browser can render it quickly -->
		<div
			class="w-full {type == 'thumbnail'
				? 'aspect-video'
				: type == 'poster'
				? 'aspect-[2/3]'
				: 'aspect-square'} rounded-token card"
		/>
		<p>{"\u200b"}</p>
		{#if subtext}
			<p>{"\u200b"}</p>
		{/if}
	{/if}
</div>
