<script lang="ts">
	import { RATING_SETTING, type AlbumJSON, type ArtistJSON } from "$lib/TEST";
	import { PageGradient } from "$lib/background/PageGradient";
	import { calculateBackgroundGradient } from "$lib/background/gradient";
	import type { RGB } from "$lib/background/types";
	import Rating from "$lib/components/Rating.svelte";
	import { initials } from "$lib/utils";
	import { Avatar, getToastStore } from "@skeletonlabs/skeleton";
	import { IconPencil, IconPlayerPlayFilled } from "@tabler/icons-svelte";

	export let artist: ArtistJSON;
	export let album: AlbumJSON;

	artist; //TODO:

	const toasts = getToastStore();

	function iconLoaded(img: HTMLElement) {
		const colors = calculateBackgroundGradient(<HTMLImageElement>img),
			commons = colors.slice(0, 4).map((c) => <RGB>c.slice(0, 3));
		// ensure there's at least 4 colors in the list
		//TODO: maybe do something with % to make it look better?
		while (commons.length < 4) {
			commons.push(commons[commons.length - 1]);
		}
		PageGradient.set(<[RGB, RGB, RGB, RGB]>commons);
	}
</script>

<div class="card p-4 mb-4 flex gap-4">
	<Avatar
		src={album.icon}
		initials={initials(album.name)}
		rounded="rounded"
		height="h-44"
		width="w-44"
		crossorigin="anonymous"
		action={iconLoaded}
	/>
	<div>
		<h1 class="text-3xl font-semibold flex items-center gap-2">
			{album.name}
			<span class="badge variant-soft-primary">{album.year}</span>
		</h1>
		<a class="flex gap-1 text-lg items-center w-fit" href="/server/flixur.app/music/{artist.id}">
			<Avatar
				src={artist.icon}
				initials={initials(artist.name)}
				rounded="rounded-full"
				height="h-5"
				width="w-5"
			/>
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
						on:click={() => toasts.trigger({ message: "play button clicked" })}
					>
						<IconPlayerPlayFilled size={20} />
					</button>
				</td>
				<td class="flex-1 overflow-hidden overflow-ellipsis !whitespace-nowrap">{track.title}</td>
				<td align="right">
					<button
						class="btn-icon btn-icon-sm variant-filled-secondary hidden"
						on:click={() => toasts.trigger({ message: "edit button clicked" })}
					>
						<IconPencil size={20} />
					</button>
				</td>
			</tr>
		{/each}
	</tbody>
</table>
