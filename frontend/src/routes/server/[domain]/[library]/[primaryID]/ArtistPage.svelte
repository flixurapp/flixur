<script lang="ts">
	import LibraryCard from "$lib/LibraryCard.svelte";
	import LibraryScroller from "$lib/LibraryScroller.svelte";
	import { RATING_SETTING, type ArtistJSON } from "$lib/TEST";
	import Rating from "$lib/components/Rating.svelte";
	import { initials } from "$lib/utils";
	import { Avatar, getToastStore } from "@skeletonlabs/skeleton";

	const toasts = getToastStore();

	export let artist: ArtistJSON;
</script>

<!--TODO: temporary testing-->
<LibraryScroller
	cardType="art"
	items={JSON.parse(
		"[" + new Array(500).fill(JSON.stringify(artist.albums).slice(1, -1)).join(",") + "]"
	)}
	let:data
>
	<div slot="header" class="card p-4 mb-4 flex gap-4">
		<Avatar
			src={artist.icon}
			initials={initials(artist.name)}
			rounded="rounded"
			height="h-44"
			width="w-44"
		/>
		<div>
			<h1 class="text-4xl font-semibold">{artist.name}</h1>
			{#if artist.location}
				<p class="opacity-60 text-sm">{artist.location}</p>
			{/if}
			<Rating class="mt-1" value={artist.rating} type={RATING_SETTING} size={20} />
		</div>
	</div>
	{#each data.cards as album}
		<LibraryCard
			type="art"
			name={album.name}
			subtext={album.year}
			href="/server/flixur.app/music/{artist.id}/{album.id}"
			image={album.icon}
			on:play={() => toasts.trigger({ message: "play button clicked" })}
			on:context={() => toasts.trigger({ message: "context button clicked" })}
		/>
	{/each}
</LibraryScroller>
