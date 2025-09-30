<script lang="ts">
	import { goto } from "$app/navigation";
	import { page } from "$app/state";
	import { removePageGradient } from "$lib/background/gradient";
	import { Tabs } from "@skeletonlabs/skeleton-svelte";
	import { onMount } from "svelte";
	import { Views } from ".";
	import MusicLibrary from "./MusicLibrary.svelte";

	let view = $state(page.url.searchParams.get("view") || Views.Library);

	$effect(() => {
		if (page.url.searchParams.get("view") !== view) {
			page.url.searchParams.set("view", view);
			goto(page.url);
		}
	});

	onMount(removePageGradient);
</script>

<div class="flex flex-col h-full -mb-24 md:mb-0 md:-mx-2">
	<Tabs
		value={view}
		onValueChange={(e) => (view = e.value)}
		base="h-full grid grid-rows-[auto_1fr]"
		contentBase="flex flex-1"
		listBase="px-2"
	>
		{#snippet list()}
			<Tabs.Control value={Views.Library}>Library</Tabs.Control>
			<Tabs.Control value={Views.Discover}>Discover</Tabs.Control>
			<Tabs.Control value={Views.Playlists}>Playlists</Tabs.Control>
		{/snippet}
		{#snippet content()}
			<Tabs.Panel value={Views.Library} classes="flex flex-1">
				<MusicLibrary />
			</Tabs.Panel>
			<Tabs.Panel value={Views.Discover}>
				Discovery goes here... library page for {page.params.domain} + {page.params.library}
			</Tabs.Panel>
			<Tabs.Panel value={Views.Playlists}>list of playlists</Tabs.Panel>
		{/snippet}
	</Tabs>
</div>
