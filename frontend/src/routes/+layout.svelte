<script lang="ts">
	import { run } from "svelte/legacy";

	import { afterNavigate } from "$app/navigation";
	import { page } from "$app/stores";
	import {
		PageGradient,
		PageGradientDefault,
		type PageGradientType,
	} from "$lib/background/PageGradient";
	import type { RGBA } from "$lib/background/types";
	import EditModal from "$lib/modals/edit/EditModal.svelte";
	import {
		AppBar,
		AppRail,
		AppRailAnchor,
		AppShell,
		Modal,
		Toast,
		initializeStores,
		type ModalComponent,
	} from "@skeletonlabs/skeleton";
	import { IconHome, IconMusic, IconSearch, IconSettings } from "@tabler/icons-svelte";
	import { interpolateLab } from "d3-interpolate";
	import { sineOut } from "svelte/easing";
	import { tweened } from "svelte/motion";
	import "../app.postcss";
	interface Props {
		children?: import("svelte").Snippet;
	}

	let { children }: Props = $props();

	initializeStores();

	afterNavigate((params) => {
		const isNewPage: boolean = params.from?.route.id !== params.to?.route.id;

		const elemPage = document.querySelector("#page");
		if (isNewPage && elemPage !== null) {
			elemPage.scrollTop = 0;
		}
	});

	const modalRegistry: Record<string, ModalComponent> = {
		edit: { ref: EditModal },
	};

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

<Modal components={modalRegistry} />
<Toast />

<AppShell slotPageContent="px-3 py-2">
	{#snippet header()}
		<AppBar>
			{#snippet lead()}
				Flixur
			{/snippet}
			<div class="input-group input-group-divider grid-cols-[auto_1fr_auto] w-fit">
				<input class="input" title="Input (text)" type="text" placeholder="Search" />
				<button class="variant-filled-secondary">
					<IconSearch size={18} />
				</button>
			</div>
		</AppBar>
	{/snippet}
	{#snippet sidebarLeft()}
		<AppRail width="w-16">
			<AppRailAnchor href="/" selected={$page.url.pathname == "/"}>
				{#snippet lead()}
					<IconHome />
				{/snippet}
				Home
			</AppRailAnchor>
			<AppRailAnchor
				href="/server/flixur.app/music"
				selected={$page.url.pathname == "/server/flixur.app/music"}
			>
				{#snippet lead()}
					<IconMusic />
				{/snippet}
				Music
			</AppRailAnchor>
			{#snippet trail()}
				<AppRailAnchor href="/settings" selected={$page.url.pathname == "/settings"}>
					{#snippet lead()}
						<IconSettings />
					{/snippet}
					Settings
				</AppRailAnchor>
			{/snippet}
		</AppRail>
	{/snippet}
	{@render children?.()}
</AppShell>

<style>
	/* blur navbar with background */
	:global(#appShell .bg-surface-100-800-token) {
		background-color: rgb(var(--color-surface-800) / 0.75);
		backdrop-filter: blur(24px);
	}
</style>
