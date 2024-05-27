<script lang="ts">
	import { beforeNavigate } from "$app/navigation";
	import { removePageGradient } from "$lib/background/gradient";
	import { onMount } from "svelte";

	beforeNavigate(removePageGradient);
	onMount(removePageGradient);
</script>

<slot />
