<!-- For Artists and Albums -->

<script lang="ts">
	import { Avatar } from "@skeletonlabs/skeleton-svelte";
	import { IconDots, IconPencil, IconPlayerPlayFilled } from "@tabler/icons-svelte";
	import { onMount } from "svelte";
	import type { LibraryCardType } from "./LibraryCard";
	import { Scrolling } from "./events/scroller";
	import EditModal from "./modals/edit/EditModal.svelte";

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

	let mounted = $state(false);

	onMount(async () => {
		// wait for scroll to be finished before mounting
		Scrolling.onScrollEnd(() => {
			mounted = true;
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
	{#if mounted}
		<a
			{href}
			class="block relative w-full {type == 'thumbnail'
				? 'aspect-video'
				: type == 'poster'
					? 'aspect-2/3'
					: 'aspect-square'} rounded cursor-pointer"
		>
			<Avatar {name} classes="absolute top-0 left-0 h-full w-full" rounded="rounded-[inherit]">
				<img src={image} crossorigin="anonymous" class="w-full h-full" alt={name} />
			</Avatar>
			<div
				class="cant-hover:hidden p-1 gap-2 opacity-0 transition-opacity relative w-full h-full flex items-end justify-center rounded-[inherit] bg-black bg-opacity-50"
			>
				<button
					class="btn-icon btn-icon-sm variant-filled-primary mr-auto"
					onclick={(e) => {
						e.currentTarget.blur();
						onplay?.();
						e.preventDefault();
					}}
				>
					<IconPlayerPlayFilled size={22} />
				</button>
				<EditModal>
					<button
						class="btn-icon btn-icon-xs variant-filled-secondary"
						onclick={(e) => {
							e.currentTarget.blur();
							e.preventDefault();
						}}
					>
						<IconPencil size={16} />
					</button>
				</EditModal>
				<button
					class="btn-icon btn-icon-xs variant-filled-secondary"
					onclick={(e) => {
						e.currentTarget.blur();
						oncontextmenu?.(e);
						e.preventDefault();
					}}
				>
					<IconDots size={16} />
				</button>
			</div>
		</a>
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
		<!-- attempting to make this as "light" as possible, so the browser can render it quickly -->
		<div
			class="w-full {type == 'thumbnail'
				? 'aspect-video'
				: type == 'poster'
					? 'aspect-2/3'
					: 'aspect-square'} rounded-token card"
		></div>
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
