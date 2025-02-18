<script lang="ts">
	import { RATING_SETTING, type AlbumJSON, type ArtistJSON } from "$lib/TEST";
	import { iconBackgroundAction } from "$lib/background/gradient";
	import Rating from "$lib/components/Rating.svelte";
	import { initials } from "$lib/utils";
	import { Avatar, type ToastContext } from "@skeletonlabs/skeleton-svelte";
	import { IconPencil, IconPlayerPlayFilled } from "@tabler/icons-svelte";
	import { getContext } from "svelte";

	interface Props {
		artist: ArtistJSON;
		album: AlbumJSON;
	}

	let { artist, album }: Props = $props();

	artist; //TODO:

	export const toasts: ToastContext = getContext("toast");
</script>

<div class="card p-4 mb-4 flex gap-4 variant-softer">
	<Avatar src={album.icon} name={album.name} rounded="rounded" classes="h-44 w-44">
		<img src={album.icon} crossorigin="anonymous" use:iconBackgroundAction alt={artist.name} />
	</Avatar>
	<div>
		<h1 class="text-3xl font-semibold flex items-center gap-2">
			{album.name}
			<span class="badge variant-soft-primary">{album.year}</span>
		</h1>
		<a class="flex gap-1 text-lg items-center w-fit" href="/server/flixur.app/music/{artist.id}">
			<Avatar src={artist.icon} name={artist.name} rounded="rounded-full" classes="h-5 w-5">
				{initials(artist.name)}
			</Avatar>
			<span class="opacity-80 font-medium">{artist.name}</span>
			<span class="badge badge-sm variant-soft-secondary uppercase">{album.type}</span>
		</a>
		<Rating class="mt-1" value={album.rating} type={RATING_SETTING} size={20} />
	</div>
</div>

<table class="table table-hover table-compact table-fixed w-1/2 mx-auto">
	<tbody>
		{#each [...album.tracks].sort((a, b) => a.index - b.index) as track (track.id)}
			<tr
				class="flex items-center [&>:first-child>span]:hover:hidden [&>td>button]:hover:inline-flex"
			>
				<td>
					<span class="badge btn-icon-sm rounded-full variant-soft-primary">{track.index}</span>
					<button
						class="btn-icon btn-icon-sm variant-filled-primary hidden"
						onclick={() => toasts.create({ description: "play button clicked" })}
					>
						<IconPlayerPlayFilled size={20} />
					</button>
				</td>
				<td class="flex-1 overflow-hidden overflow-ellipsis !whitespace-nowrap">{track.title}</td>
				<td align="right">
					<button
						class="btn-icon btn-icon-sm variant-filled-secondary hidden"
						onclick={() => toasts.create({ description: "edit button clicked" })}
					>
						<IconPencil size={20} />
					</button>
				</td>
			</tr>
		{/each}
	</tbody>
</table>
