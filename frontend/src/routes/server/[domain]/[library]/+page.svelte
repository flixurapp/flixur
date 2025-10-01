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

<div class="flex flex-col h-full relative">
	<Tabs
		value={view}
		onValueChange={(e) => (view = e.value)}
		base="h-full grid grid-rows-[1fr]"
		contentBase="flex flex-1"
		listClasses="px-2 pt-1 absolute top-0 z-[1] h-12 bg-surface-950/70 backdrop-blur-xl w-full"
	>
		{#snippet list()}
			{@const labelBase = "btn hover:preset-glass-primary-500"}
			<Tabs.Control value={Views.Library} {labelBase}>Library</Tabs.Control>
			<Tabs.Control value={Views.Discover} {labelBase}>Discover</Tabs.Control>
			<Tabs.Control value={Views.Playlists} {labelBase}>Playlists</Tabs.Control>
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
