<script lang="ts">
	import { Dialog, Portal } from "@skeletonlabs/skeleton-svelte";
	import type { Snippet } from "svelte";

	interface Props {
		children: Snippet;
		baseClasses?: string;
		class: string;
		label: string;
	}

	let { children, baseClasses, class: triggerClasses, label: triggerAriaLabel }: Props = $props(),
		open = $state(false);
</script>

<svelte:window onkeyup={(event) => open && event.key == "Escape" && (open = false)} />

<Dialog {open}>
	<Dialog.Trigger
		class={triggerClasses}
		aria-label={triggerAriaLabel}
		onclick={(e) => {
			e.currentTarget.blur();
			e.preventDefault();
			open = true;
		}}
	>
		{@render children()}
	</Dialog.Trigger>
	<Portal>
		<Dialog.Backdrop class="backdrop-blur-xs" />
		<!-- in:fade={{ x: 480, duration: 200 }} -->
		<Dialog.Positioner class="justify-end">
			<Dialog.Content class="bg-surface-100-900 p-4 space-y-4 shadow-xl w-[480px] h-screen">
				<div class="card p-4 shadow-xl space-y-4 preset-filled-surface-200-800">
					<i>other stuff to edit will be up here</i>
				</div>
				<div class="card p-4 shadow-xl space-y-4 preset-filled-surface-200-800">
					<h3>Confirm changes?</h3>
					<button class="btn preset-filled-primary-500">Submit</button>
					<button class="btn preset-outlined-error-500" onclick={() => (open = false)}
						>Cancel</button
					>
				</div>
			</Dialog.Content>
		</Dialog.Positioner>
	</Portal>
</Dialog>
