<script lang="ts">
	import { removePageGradient } from "$lib/background/gradient";
	import { onMount } from "svelte";

	onMount(removePageGradient);
</script>

<h1>Welcome to SvelteKit</h1>
<p>Visit <a href="https://kit.svelte.dev">kit.svelte.dev</a> to read the documentation</p>
