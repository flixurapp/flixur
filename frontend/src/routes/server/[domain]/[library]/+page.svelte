<script lang="ts">
	import { page } from "$app/stores";
	import { removePageGradient } from "$lib/background/gradient";
	import { onMount } from "svelte";
	import MusicLibrary from "./MusicLibrary.svelte";

	onMount(removePageGradient);
</script>

<div class="flex flex-col h-full">
	library page for {$page.params.domain} + {$page.params.library}

	<MusicLibrary />
</div>
