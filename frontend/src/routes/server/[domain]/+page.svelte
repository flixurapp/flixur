<script lang="ts">
	import { page } from "$app/state";
	import { removePageGradient } from "$lib/background/gradient";
	import { onMount } from "svelte";

	onMount(removePageGradient);
</script>

server page for {page.params.domain}
