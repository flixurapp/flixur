<script lang="ts">
	import { run } from "svelte/legacy";

	import { afterNavigate } from "$app/navigation";
	import {
		PageGradient,
		PageGradientDefault,
		type PageGradientType,
	} from "$lib/background/PageGradient";
	import type { RGBA } from "$lib/background/types";
	import { Navigation, ToastProvider } from "@skeletonlabs/skeleton-svelte";
	import { IconHome, IconMenu2, IconMusic, IconSearch, IconSettings } from "@tabler/icons-svelte";
	import { interpolateLab } from "d3-interpolate";
	import type { Snippet } from "svelte";
	import { sineOut } from "svelte/easing";
	import { tweened } from "svelte/motion";
	import "../app.postcss";

	interface Props {
		children: Snippet;
	}

	let { children }: Props = $props();

	afterNavigate((params) => {
		const isNewPage: boolean = params.from?.route.id !== params.to?.route.id;

		const elemPage = document.querySelector("#page");
		if (isNewPage && elemPage !== null) {
			elemPage.scrollTop = 0;
		}
	});

	let expanded = $state(false);

	/** Current color rendered on-screen. */
	let currentColor = tweened<PageGradientType>(PageGradientDefault(), {
		duration: 500,
		interpolate: (a, b) => (t) => {
			const result = a.map((aa, i) => {
				const bb = b![i];
				const newColor = interpolateLab(`rgba(${aa.join(", ")})`, `rgba(${bb.join(", ")})`)(t);
				const colors = newColor.split("(")[1].split(")")[0].split(", ").map(Number) as RGBA;
				while (colors.length < 4) {
					colors.push(1);
				}
				return colors;
			});
			return result as PageGradientType;
		},
		easing: sineOut,
	});
	run(() => {
		// ensure gradient is there and correct
		if ($PageGradient?.length !== 4) $PageGradient = PageGradientDefault();

		// set color for interpolation
		currentColor.set($PageGradient);
	});

	run(() => {
		if ($currentColor?.length == 4) {
			/** Amount of separation in alpha for colors. */
			// '4' results in 1, 0.75, 0.50, 0.25
			const ALPHA_FACTOR = 4,
				/** Default alpha of the darkening background overlay. */
				OVERLAY_ALPHA = 0.9;
			// convert gradient to list of rgba colors, in same order
			// opacity is set according to importance of color (index in array)
			const g = $currentColor.map((g, i) => {
				// clamp decimals to 3 places
				const alpha = Math.round((g[3] ?? 1) * Math.abs(1 * (i / ALPHA_FACTOR) - 1) * 1000) / 1000;
				return `rgba(${g.slice(0, 3).join(", ")}, ${alpha})`;
			});
			const totalAlpha = $currentColor.map((c) => c[3] ?? 1).reduce((a, b) => a + b) / ALPHA_FACTOR;
			//TODO: could use some work but im happy with it for now
			// the final OVERLAY_ALPHA is set closer to 1 the closer totalAlpha is to 0
			// this way when the background is blended to transparency the overlay is properly 100% opaque
			document.body.style.background = `
linear-gradient(to bottom left, ${g[1]}, ${g[3]}),
linear-gradient(to bottom right, ${g[0]}, ${g[2]}),
rgb(var(--color-surface-900) / ${OVERLAY_ALPHA + (1 - OVERLAY_ALPHA) * (1 - totalAlpha)})
`.trim();
			document.body.style.backgroundBlendMode = "overlay";
			document.body.style.backdropFilter = "blur(24px)";
		} else document.body.style.background = "";
	});
</script>

<ToastProvider>
	<div class="h-screen px-3 py-2 grid grid-rows-[auto_1fr] overflow-auto">
		<header class="sticky top-0 z-10 bg-inherit p-4 backdrop-blur-sm">
			Flixur
			<div class="input-group input-group-divider grid-cols-[auto_1fr_auto] w-fit">
				<input class="input" title="Input (text)" type="text" placeholder="Search" />
				<button class="variant-filled-secondary">
					<IconSearch size={18} />
				</button>
			</div>
		</header>

		<div class="grid grid-cols-1 md:grid-cols-[auto_1fr]">
			<Navigation.Rail
				width="w-16"
				{expanded}
				background="bg-surface-900 bg-opacity-80 backdrop-blur-xl"
			>
				{#snippet header()}
					<Navigation.Tile
						title="Menu"
						labelExpanded="Collapse"
						onclick={() => (expanded = !expanded)}
					>
						<IconMenu2 />
					</Navigation.Tile>
				{/snippet}

				{#snippet tiles()}
					<Navigation.Tile id="0" label="Home" href="/">
						<IconHome />
					</Navigation.Tile>
					<Navigation.Tile id="1" label="Music" href="/server/flixur.app/music">
						<IconMusic />
					</Navigation.Tile>
				{/snippet}

				{#snippet footer()}
					<Navigation.Tile id="2" label="Settings" href="/settings">
						<IconSettings />
					</Navigation.Tile>
				{/snippet}
			</Navigation.Rail>

			<main class="p-2">
				{@render children()}
			</main>
		</div>
	</div>
</ToastProvider>
