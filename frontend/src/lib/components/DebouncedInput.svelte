<script lang="ts">
	import type { HTMLInputAttributes } from "svelte/elements";

	let {
		value = $bindable(),
		delay,
		...rest
	}: HTMLInputAttributes & {
		/** Delay in milliseconds to debounce value changes for. */
		delay: number;
	} = $props();

	let localValue = $state("");

	let timeout: ReturnType<typeof setTimeout>;
	$effect(() => {
		if (localValue == value) return;
		timeout = setTimeout(() => {
			value = localValue;
		}, delay);
		return () => clearTimeout(timeout);
	});
</script>

<input bind:value={localValue} {...rest} />
