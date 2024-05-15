<script lang="ts">
	import { getModalStore } from "@skeletonlabs/skeleton";
	import type { SvelteComponent } from "svelte";

	export let parent: SvelteComponent;

	const modalStore = getModalStore();
</script>

{#if $modalStore[0]}
	<div class="card p-4 w-modal shadow-xl space-y-4">
		<p>edit modal</p>
		<button class="btn variant-filled-primary"> Submit </button>
		<button class="btn variant-ghost" on:click={parent.onClose}> Cancel </button>
	</div>
{/if}
