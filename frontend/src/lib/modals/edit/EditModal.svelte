<script lang="ts">
	import { Modal } from "@skeletonlabs/skeleton-svelte";
	import type { Snippet } from "svelte";

	interface Props {
		children: Snippet;
	}

	let { children }: Props = $props(),
		open = $state(false);
</script>

<Modal
	bind:open
	triggerBase="btn preset-tonal"
	contentBase="bg-surface-100-900 p-4 space-y-4 shadow-xl w-[480px] h-screen"
	positionerJustify="justify-start"
	positionerAlign=""
	positionerPadding=""
	transitionsPositionerIn={{ x: -480, duration: 200 }}
	transitionsPositionerOut={{ x: -480, duration: 200 }}
>
	{#snippet trigger()}
		{@render children()}
	{/snippet}
	{#snippet content()}
		<div class="card p-4 w-modal shadow-xl space-y-4">
			<p>edit modal</p>
			<button class="btn variant-filled-primary"> Submit </button>
			<button class="btn variant-ghost" onclick={() => (open = false)}> Cancel </button>
		</div>
	{/snippet}
</Modal>
