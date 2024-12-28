<script lang="ts">
	import { beforeNavigate } from "$app/navigation";
	import { removePageGradient } from "$lib/background/gradient";
	import { onMount } from "svelte";
	interface Props {
		children?: import('svelte').Snippet;
	}

	let { children }: Props = $props();

	beforeNavigate(removePageGradient);
	onMount(removePageGradient);
</script>

{@render children?.()}
