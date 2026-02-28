<script lang="ts">
	import { beforeNavigate } from "$app/navigation";
	import { removePageGradient } from "$lib/background/gradient";
	import { onMount, type Snippet } from "svelte";

	let { children }: { children?: Snippet } = $props();

	beforeNavigate(removePageGradient);
	onMount(removePageGradient);
</script>

{@render children?.()}
