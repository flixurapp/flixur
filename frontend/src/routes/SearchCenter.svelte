<script lang="ts">
	import DebouncedInput from "$lib/components/DebouncedInput.svelte";
	import { API } from "$lib/utils";
	import { createQuery } from "@tanstack/svelte-query";
	import { fly } from "svelte/transition";

	let searchValue = $state("");

	const query = createQuery(() => ({
		queryKey: ["search", searchValue],
		queryFn: () =>
			API.artists.artistSearch({
				query: searchValue,
				plugin: "musicbrainz",
			}),
		enabled: () => searchValue.length > 0,
		staleTime: 1000 * 60 * 1, // 1min
	}));
</script>

<aside
	class="absolute top-8 left-8 right-[calc(250px+--spacing(8))] bottom-8"
	in:fly={{ y: -100, duration: 100, delay: 100 }}
>
	<div
		class="input-group grid-cols-[auto_1fr] mt-1 h-16 backdrop-blur-md focus-within:outline focus-within:outline-primary-500"
	>
		<div class="ig-cell preset-tonal w-14">
			<iconify-icon icon="tabler:search" height={16} noobserver></iconify-icon>
		</div>
		<DebouncedInput
			delay={300}
			class="ig-input outline-none text-lg"
			type="search"
			placeholder="Search..."
			bind:value={searchValue}
		/>
	</div>
	<div>
		{#if query.isPending}
			waiting
		{:else if query.error}
			<p class="text-error-500">
				{query.error.message || "Error."}
			</p>
		{:else if query.isSuccess}
			done {query.data.list?.length}
		{/if}
	</div>
</aside>
