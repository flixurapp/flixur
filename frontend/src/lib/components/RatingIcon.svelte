<script lang="ts">
	import { createEventDispatcher } from "svelte";

	/** Icon component to use. */
	export let icons: [ConstructorOfATypedSvelteComponent, ConstructorOfATypedSvelteComponent];
	/** Size of the icons. */
	export let size: number;
	/** The value to use for the icon. (should be 0-2) */
	export let value: number;
	/** Raw value for the icon. (used for toggle) */
	export let rawValue = 0;
	/** Color for the icon. (name-intensity) */
	export let color: string;
	/** Icon to use for half-selections. Also enables them. */
	export let halfIcon: ConstructorOfATypedSvelteComponent | undefined = undefined;
	/** Index of this icon in the list. */
	export let index = 0;
	/** Allow this icon to toggle the rating. */
	export let toggle = false;

	const dispatch = createEventDispatcher();
	let wrapper: HTMLSpanElement;

	let state: // not being hovered over
	| "none"
		// hover over first half
		| "hover-half"
		// hover over entire thing
		| "hover-full"
		// hover over left padding
		| "hover-zero" = "none";

	function calcHover(event: MouseEvent) {
		const box = wrapper.getBoundingClientRect(),
			x = event.x - box.x,
			w = box.width;

		if (x > box.width || x < 0) state = "none";
		else if (x < (w - size) / 2) state = "hover-zero";
		else if (x < w / 2) state = halfIcon ? "hover-half" : "hover-full";
		else if (x >= w / 2) state = "hover-full";
		else state = "none";

		if (toggle && rawValue > 0 && (state == "hover-half" || state == "hover-full"))
			state = "hover-zero";
		else if (toggle && rawValue <= 0 && state == "hover-zero") state = "hover-full";

		dispatch("hover", state == "none" ? null : index * 2 + getValue());
	}
	function getValue() {
		return state == "hover-full" ? 2 : state == "hover-half" ? 1 : 0;
	}
	function click() {
		dispatch("change", getValue());
	}
</script>

<span
	bind:this={wrapper}
	class="cursor-pointer px-1.5"
	style:color={(() => {
		const full = `var(--color-${color})`;
		switch (state) {
			case "none":
				return value > 0 ? full : "";
			case "hover-zero":
				return "inherit";
			case "hover-half":
			case "hover-full":
				return full;
		}
	})()}
	on:mouseenter={calcHover}
	on:mousemove={calcHover}
	on:mouseleave={() => {
		state = "none";
	}}
	on:click={(e) => {
		calcHover(e);
		click();
	}}
	on:keydown={(e) => {
		if (e.code == "Space") click();
	}}
	role="radio"
	aria-checked={value % 2 == 1 ? "mixed" : value == 0 ? "false" : "true"}
	tabindex="0"
>
	<svelte:component
		this={// to remove the rating
		state == "hover-zero"
			? icons[0]
			: // rating is full
			state == "hover-full" || value >= 2
			? icons[1]
			: // rating is half
			halfIcon && (state == "hover-half" || value % 2 == 1)
			? halfIcon
			: // no rating
			  icons[0]}
		{size}
	/>
</span>
