<script lang="ts">
	import { Modal } from "@skeletonlabs/skeleton-svelte";
	import type { Snippet } from "svelte";

	interface Props {
		children: Snippet;
		baseClasses?: string;
		class: string;
		label: string;
	}

	let { children, baseClasses, class: triggerBase, label: triggerAriaLabel }: Props = $props(),
		open = $state(false);
</script>

<svelte:window
	onkeyup={(event) => {
		if (open && event.key == "Escape") open = false;
	}}
/>

<Modal
	{open}
	base={baseClasses}
	contentBase="bg-surface-100-900 p-4 space-y-4 shadow-xl w-[480px] h-screen"
	backdropClasses="backdrop-blur-xs"
	positionerJustify="justify-end"
	positionerAlign=""
	positionerPadding=""
	transitionsPositionerIn={{ x: 480, duration: 200 }}
	trigger={children}
	{triggerBase}
	{triggerAriaLabel}
	onclick={(e) => {
		e.currentTarget.blur();
		e.preventDefault();
		open = true;
	}}
>
	{#snippet content()}
		<div class="card p-4 shadow-xl space-y-4 preset-filled-surface-200-800">
			<i>other stuff to edit will be up here</i>
		</div>
		<div class="card p-4 shadow-xl space-y-4 preset-filled-surface-200-800">
			<h3>Confirm changes?</h3>
			<button class="btn preset-filled-primary-500">Submit</button>
			<button class="btn preset-outlined-error-500" onclick={() => (open = false)}>Cancel</button>
		</div>
	{/snippet}
</Modal>
