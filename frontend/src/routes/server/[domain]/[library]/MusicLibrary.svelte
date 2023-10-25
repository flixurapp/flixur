<script lang="ts">
	import LibraryArtist from "$lib/LibraryArtist.svelte";
</script>

<div class="flex gap-2">
	{#each [1, 2, 3, 4, 5] as _}
		<LibraryArtist />
	{/each}
</div>
