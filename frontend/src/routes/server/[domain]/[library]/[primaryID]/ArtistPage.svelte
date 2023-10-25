<script lang="ts">
	import LibraryCardMusic from "$lib/LibraryCardMusic.svelte";
	import { getToastStore } from "@skeletonlabs/skeleton";

	const toasts = getToastStore();
</script>

<div class="flex gap-2">
	{#each [1, 2, 3, 4, 5] as _}
		<LibraryCardMusic
			name="MYCELiUM"
			href="/server/flixur.app/music/artistid/albumid"
			image="https://i.scdn.co/image/ab67616d0000b273791e5ad29bbd6253aa453293"
			on:play={() => toasts.trigger({ message: "play button clicked" })}
			on:edit={() => toasts.trigger({ message: "edit button clicked" })}
		/>
	{/each}
</div>
