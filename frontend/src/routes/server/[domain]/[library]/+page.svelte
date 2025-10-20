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
	<Tabs value={view} onValueChange={(e) => (view = e.value)} class="h-full grid grid-rows-[1fr]">
		<Tabs.List
			class="px-2 pt-1 absolute top-0 z-[1] h-12 bg-surface-950/70 backdrop-blur-xl w-full"
		>
			{@const labelBase = "btn hover:preset-glass-primary-500"}
			<Tabs.Trigger value={Views.Library} class={labelBase}>Library</Tabs.Trigger>
			<Tabs.Trigger value={Views.Discover} class={labelBase}>Discover</Tabs.Trigger>
			<Tabs.Trigger value={Views.Playlists} class={labelBase}>Playlists</Tabs.Trigger>
			<Tabs.Indicator />
		</Tabs.List>
		<Tabs.Content value={Views.Library} class="flex flex-1">
			<MusicLibrary />
		</Tabs.Content>
		<Tabs.Content value={Views.Discover}>
			Discovery goes here... library page for {page.params.domain} + {page.params.library}
		</Tabs.Content>
		<Tabs.Content value={Views.Playlists}>list of playlists</Tabs.Content>
	</Tabs>
</div>
