<script lang="ts">
	import { toaster } from "$lib";
	import { RATING_SETTING, type AlbumJSON, type ArtistJSON } from "$lib/TEST";
	import { iconBackgroundAction } from "$lib/background/gradient";
	import Rating from "$lib/components/Rating.svelte";
	import { initials } from "$lib/utils";
	import { Avatar } from "@skeletonlabs/skeleton-svelte";
	import { fromAction } from "svelte/attachments";

	interface Props {
		artist: ArtistJSON;
		album: AlbumJSON;
	}

	let { artist, album }: Props = $props();

	artist; //TODO:
</script>

<div class="card p-4 mb-4 flex gap-4 preset-filled-surface-300-700 bg-surface-300/15">
	<Avatar class="h-44 w-44 rounded">
		<Avatar.Image
			src={album.icon}
			crossorigin="anonymous"
			alt={artist.name}
			{@attach fromAction(iconBackgroundAction)}
		/>
		<Avatar.Fallback>
			{initials(album.name)}
		</Avatar.Fallback>
	</Avatar>
	<div>
		<h1 class="text-3xl font-semibold flex items-center gap-2">
			{album.name}
			<span class="badge badge-sm preset-glass-primary-500">{album.year}</span>
		</h1>
		<a class="flex gap-1 text-lg items-center w-fit" href="/server/flixur.app/music/{artist.id}">
			<Avatar class="h-5 w-5 rounded-full">
				<Avatar.Image src={artist.icon} crossorigin="anonymous" alt={artist.name} />
				<Avatar.Fallback>
					{initials(artist.name)}
				</Avatar.Fallback>
			</Avatar>
			<span class="opacity-80 font-medium">{artist.name}</span>
			<span class="badge badge-sm preset-glass-secondary-500 uppercase">{album.type}</span>
		</a>
		<Rating class="mt-1" value={album.rating} type={RATING_SETTING} size={20} />
	</div>
</div>

<table class="table table-hover table-compact table-fixed w-1/2 mx-auto">
	<tbody>
		{#each [...album.tracks].sort((a, b) => a.index - b.index) as track (track.id)}
			<tr
				class="flex items-center hover:[&>:first-child>span]:hidden hover:[&>td>button]:inline-flex"
			>
				<td>
					<span class="btn-icon rounded-full preset-glass-primary-600">{track.index}</span>
					<button
						class="btn-icon rounded-full preset-glass-primary-500 hidden"
						onclick={() => toaster.create({ description: "play button clicked" })}
						aria-label="Play"
					>
						<iconify-icon icon="tabler:player-play-filled" height={20}></iconify-icon>
					</button>
				</td>
				<td class="flex-1 overflow-hidden text-ellipsis whitespace-nowrap!">{track.title}</td>
				<td align="right">
					<button
						class="btn-icon rounded-full preset-glass-secondary-500 hidden"
						onclick={() => toaster.create({ description: "edit button clicked" })}
						aria-label="Edit"
					>
						<iconify-icon icon="tabler:pencil" height={20}></iconify-icon>
					</button>
				</td>
			</tr>
		{/each}
	</tbody>
</table>
