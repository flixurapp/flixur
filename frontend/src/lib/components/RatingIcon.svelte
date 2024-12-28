<script lang="ts">
	interface Props {
		/** Icon component to use. */
		icons: [ConstructorOfATypedSvelteComponent, ConstructorOfATypedSvelteComponent];
		/** Size of the icons. */
		size: number;
		/** The value to use for the icon. (should be 0-2) */
		value: number;
		/** Raw value for the icon. (used for toggle) */
		rawValue?: number;
		/** Color for the icon. (name-intensity) */
		color: string;
		/** Icon to use for half-selections. Also enables them. */
		halfIcon?: ConstructorOfATypedSvelteComponent | undefined;
		/** Index of this icon in the list. */
		index?: number;
		/** Allow this icon to toggle the rating. */
		toggle?: boolean;

		/** Run when the icon is hovered over. */
		onhover?(value: number | null): void;
		/** Run when the icon is clicked on. */
		onchange?(value: number): void;
	}

	let {
		icons,
		size,
		value,
		rawValue = 0,
		color,
		halfIcon = undefined,
		index = 0,
		toggle = false,
		onhover,
		onchange,
	}: Props = $props();

	let wrapper: HTMLSpanElement | null = $state(null);

	let hoverState = $state<
		// not being hovered over
		| "none"
		// hover over first half
		| "hover-half"
		// hover over entire thing
		| "hover-full"
		// hover over left padding
		| "hover-zero"
	>("none");

	function calcHover(event: MouseEvent) {
		if (!wrapper) return;
		const box = wrapper.getBoundingClientRect(),
			x = event.x - box.x,
			w = box.width;

		if (x > box.width || x < 0) hoverState = "none";
		else if (x < (w - size) / 2) hoverState = "hover-zero";
		else if (x < w / 2) hoverState = halfIcon ? "hover-half" : "hover-full";
		else if (x >= w / 2) hoverState = "hover-full";
		else hoverState = "none";

		if (toggle && rawValue > 0 && (hoverState == "hover-half" || hoverState == "hover-full"))
			hoverState = "hover-zero";
		else if (toggle && rawValue <= 0 && hoverState == "hover-zero") hoverState = "hover-full";

		onhover?.(hoverState == "none" ? null : index * 2 + getValue());
	}
	function getValue() {
		return hoverState == "hover-full" ? 2 : hoverState == "hover-half" ? 1 : 0;
	}
	function click() {
		onchange?.(getValue());
	}

	const Icon = $derived(
		hoverState == "hover-zero"
			? icons[0]
			: // rating is full
				hoverState == "hover-full" || value >= 2
				? icons[1]
				: // rating is half
					halfIcon && (hoverState == "hover-half" || value % 2 == 1)
					? halfIcon
					: // no rating
						icons[0],
	);
</script>

<span
	bind:this={wrapper}
	class="cursor-pointer"
	style:padding-left="{size * 0.1}px"
	style:padding-right="{size * 0.1}px"
	style:color={(() => {
		const full = `var(--color-${color})`;
		switch (hoverState) {
			case "none":
				return value > 0 ? full : "";
			case "hover-zero":
				return "inherit";
			case "hover-half":
			case "hover-full":
				return full;
		}
	})()}
	onmouseenter={calcHover}
	onmousemove={calcHover}
	onmouseleave={() => {
		hoverState = "none";
	}}
	onclick={(e) => {
		calcHover(e);
		click();
	}}
	onkeydown={(e) => {
		if (e.code == "Space") click();
	}}
	role="radio"
	aria-checked={value % 2 == 1 ? "mixed" : value == 0 ? "false" : "true"}
	tabindex="0"
>
	<Icon {size} />
</span>
