<script lang="ts">
	import LibraryCard from "$lib/LibraryCard.svelte";
	import { getToastStore } from "@skeletonlabs/skeleton";

	const toasts = getToastStore();
</script>

<div class="flex gap-2">
	{#each [1, 2, 3, 4, 5] as _}
		<LibraryCard
			type="art"
			name="Aluna"
			href="/server/flixur.app/music/artistid"
			image="https://i.scdn.co/image/ab6761610000e5ebfd31c630c1a72de7e89a2be7"
			on:play={() => toasts.trigger({ message: "play button clicked" })}
			on:edit={() => toasts.trigger({ message: "edit button clicked" })}
		/>
	{/each}
</div>
