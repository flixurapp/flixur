<script lang="ts">
	import { toaster } from "$lib";
	import LibraryCard from "$lib/LibraryCard.svelte";
	import LibraryScroller from "$lib/LibraryScroller.svelte";
	import { RATING_SETTING, type ArtistJSON } from "$lib/TEST";
	import { iconBackgroundAction } from "$lib/background/gradient";
	import Rating from "$lib/components/Rating.svelte";
	import { Avatar } from "@skeletonlabs/skeleton-svelte";

	interface Props {
		artist: ArtistJSON;
	}

	let { artist }: Props = $props();
</script>

<LibraryScroller cardType="art" items={artist.albums}>
	{#snippet header()}
		<div class="card p-4 mb-4 flex gap-4 variant-softer">
			<Avatar name={artist.name} rounded="rounded" classes="h-44 w-44">
				<img src={artist.icon} crossorigin="anonymous" use:iconBackgroundAction alt={artist.name} />
			</Avatar>
			<div>
				<h1 class="text-4xl font-semibold">{artist.name}</h1>
				{#if artist.location}
					<p class="opacity-60 text-sm">{artist.location}</p>
				{/if}
				<Rating class="mt-1" value={artist.rating} type={RATING_SETTING} size={20} />
			</div>
		</div>
	{/snippet}
	{#snippet children({ data })}
		{#each data.cards as album}
			<LibraryCard
				type="art"
				name={album.name}
				subtext={album.year}
				href="/server/flixur.app/music/{artist.id}/{album.id}"
				image={album.icon}
				onplay={() => toaster.create({ description: "play button clicked" })}
				oncontextmenu={() => toaster.create({ description: "context button clicked" })}
			/>
		{/each}
	{/snippet}
</LibraryScroller>
