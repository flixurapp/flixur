<!-- For Artists and Albums -->

<script lang="ts">
	import { Avatar } from "@skeletonlabs/skeleton-svelte";
	import { onMount } from "svelte";
	import type { LibraryCardType } from "./LibraryCard";
	import EditModal from "./modals/edit/EditModal.svelte";
	import { initials, requestIdleWork } from "./utils";

	interface Props {
		/** Type of media in the card. `art` for artist/album. `poster` for tv/movies. `thumbnail` for episodes. */
		type: LibraryCardType;
		/** Name of the media. */
		name: string;
		/** Optional text to display below the name. */
		subtext?: string | undefined;
		/** Link to the media. */
		href: string;
		/** Optional image URL for the media. If not specified, will use initials generated from `name`. */
		image?: string | undefined;

		/** Play button clicked. */
		onplay?(): void;
		/** When the context menu is opened. */
		oncontextmenu?(event: MouseEvent): void;
	}
	let {
		type,
		name,
		subtext = undefined,
		href,
		image = undefined,
		onplay,
		oncontextmenu,
	}: Props = $props();

	let contentReady = $state(false);

	onMount(() => {
		requestIdleWork(() => {
			contentReady = true;
		});
	});
</script>

<div
	class="library-card flex flex-col hover:[&>:first-child>div]:opacity-100 sm:text-base text-sm shrink-0 {type ==
	'thumbnail'
		? 'sm:w-64 w-1/2'
		: 'sm:w-32 w-1/3'}"
	oncontextmenu={(e) => {
		oncontextmenu?.(e);
		e.preventDefault();
	}}
	role="button"
	tabindex="-1"
>
	<a
		{href}
		class="block relative w-full {type == 'thumbnail'
			? 'aspect-video'
			: type == 'poster'
				? 'aspect-2/3'
				: 'aspect-square'} rounded cursor-pointer"
	>
		{#if contentReady}
			<Avatar class="absolute top-0 left-0 h-full w-full rounded-[inherit]">
				<Avatar.Image src={image} crossorigin="anonymous" class="w-full h-full" alt={name} />
				<Avatar.Fallback>
					{initials(name)}
				</Avatar.Fallback>
			</Avatar>
			<div
				class="cant-hover:hidden p-1 gap-2 opacity-0 transition-opacity relative w-full h-full flex items-end justify-center rounded-[inherit] bg-black/50"
			>
				<button
					class="btn-icon preset-filled-primary-500 rounded-full mr-auto"
					onclick={(e) => {
						e.currentTarget.blur();
						onplay?.();
						e.preventDefault();
					}}
					aria-label="Play"
				>
					<iconify-icon icon="tabler:player-play-filled" height={20}></iconify-icon>
				</button>
				<EditModal
					baseClasses="btn-icon btn-icon-sm preset-glass-secondary-500"
					class="inline-flex items-center justify-center"
					label="Edit"
				>
					<iconify-icon icon="tabler:pencil" height={16}></iconify-icon>
				</EditModal>
				<button
					class="btn-icon btn-icon-sm preset-glass-secondary-500"
					onclick={(e) => {
						e.currentTarget.blur();
						oncontextmenu?.(e);
						e.preventDefault();
					}}
					aria-label="More"
				>
					<iconify-icon icon="tabler:dots" height={16}></iconify-icon>
				</button>
			</div>
		{:else}
			<div
				class="w-full {type == 'thumbnail'
					? 'aspect-video'
					: type == 'poster'
						? 'aspect-2/3'
						: 'aspect-square'} rounded card preset-glass-neutral"
			></div>
		{/if}
	</a>

	{#if contentReady}
		<a
			class="overflow-hidden [&>p]:whitespace-nowrap [&>p]:overflow-hidden [&>p]:text-ellipsis hover:underline"
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
		<p>{"\u200b"}</p>
		{#if subtext}
			<p>{"\u200b"}</p>
		{/if}
	{/if}
</div>

<style>
	/* Show buttons if library card is focused. */
	.library-card:focus-within .opacity-0 {
		opacity: 1;
	}
</style>
