<script lang="ts">
	import type { AlbumJSON, ArtistJSON } from "$lib/TEST";
	import { getToastStore } from "@skeletonlabs/skeleton";
	import { IconPencil, IconPlayerPlayFilled } from "@tabler/icons-svelte";

	export let artist: ArtistJSON;
	export let album: AlbumJSON;

	artist; //todo:

	const toasts = getToastStore();
</script>

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
