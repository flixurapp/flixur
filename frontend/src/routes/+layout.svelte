<script lang="ts">
	import { browser } from "$app/environment";
	import { afterNavigate } from "$app/navigation";
	import { toaster } from "$lib";
	import {
		PageGradient,
		PageGradientDefault,
		type PageGradientType,
	} from "$lib/background/PageGradient";
	import type { RGBA } from "$lib/background/types";
	import { type NavLink, NavLinksBottom, NavLinksTop } from "$lib/nav";
	import { Modal, Navigation, Toaster } from "@skeletonlabs/skeleton-svelte";
	import { QueryClient, QueryClientProvider } from "@tanstack/svelte-query";
	import { SvelteQueryDevtools } from "@tanstack/svelte-query-devtools";
	import { interpolateLab } from "d3-interpolate";
	import "iconify-icon";
	import { type Snippet } from "svelte";
	import { sineOut } from "svelte/easing";
	import { tweened } from "svelte/motion";
	import "../app.css";
	import SearchCenter from "./SearchCenter.svelte";

	interface Props {
		children: Snippet;
	}

	let { children }: Props = $props();

	const queryClient = new QueryClient({
		defaultOptions: {
			queries: {
				enabled: browser,
			},
		},
	});

	afterNavigate((params) => {
		const isNewPage: boolean = params.from?.route.id !== params.to?.route.id;

		const elemPage = document.querySelector("#page");
		if (isNewPage && elemPage !== null) {
			elemPage.scrollTop = 0;
		}
	});

	let railValue = $state("0"),
		navOpen = $state(false);

	$effect(() => {
		if (railValue.startsWith("_")) {
			railValue = "0";
		}
	});

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
	$effect(() => {
		// ensure gradient is there and correct
		if ($PageGradient?.length !== 4) $PageGradient = PageGradientDefault();

		// set color for interpolation
		currentColor.set($PageGradient);
	});

	$effect(() => {
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
color-mix(in oklch, var(--color-surface-900) ${(OVERLAY_ALPHA + (1 - OVERLAY_ALPHA) * (1 - totalAlpha)) * 100}%, white)
`.trim();
			document.body.style.backgroundBlendMode = "overlay";
			document.body.style.backdropFilter = "blur(24px)";
		} else document.body.style.background = "";
	});
</script>

<Toaster {toaster}></Toaster>

<QueryClientProvider client={queryClient}>
	<div
		class="h-screen grid not-md:grid-cols-1 not-md:grid-rows-[1fr_auto] md:grid-rows-1 md:grid-cols-[1fr_auto]"
	>
		<main class="overflow-auto w-full">
			{@render children()}
		</main>

		<!-- Desktop -->
		<Navigation.Rail
			value={railValue}
			onValueChange={(newValue) => (railValue = newValue)}
			width="w-16"
			classes="not-md:hidden"
			background="bg-surface-950/70 backdrop-blur-xl"
		>
			{#snippet header()}
				<Navigation.Tile id="_expand" onclick={() => (navOpen = true)}>
					<iconify-icon icon="tabler:menu-2"></iconify-icon>
				</Navigation.Tile>
			{/snippet}

			{#snippet tiles()}
				{@render renderLinks(NavLinksTop)}
			{/snippet}
			{#snippet footer()}
				{@render renderLinks(NavLinksBottom)}
			{/snippet}
		</Navigation.Rail>

		<!-- Mobile -->
		<Navigation.Bar
			value={railValue}
			onValueChange={(newValue) => (railValue = newValue)}
			classes="md:hidden absolute bottom-0"
			background="bg-surface-950/70 backdrop-blur-xl"
		>
			<Navigation.Tile id="_expand" onclick={() => (navOpen = true)}>
				<iconify-icon icon="tabler:menu-2"></iconify-icon>
			</Navigation.Tile>
			{@render renderLinks(NavLinksTop)}
			{@render renderLinks(NavLinksBottom)}
		</Navigation.Bar>
	</div>
	<Modal
		open={navOpen}
		onEscapeKeyDown={() => (navOpen = false)}
		contentBase="bg-surface-900 py-4 px-2 shadow-xl h-screen w-[250px]"
		backdropClasses="backdrop-blur-sm"
		positionerJustify="justify-end"
		positionerPadding=""
		transitionsPositionerIn={{ x: 250, duration: 250 }}
	>
		{#snippet content()}
			<SearchCenter />

			<!-- Navigation -->
			<Navigation.Rail
				value={railValue}
				onValueChange={(newValue) => (railValue = newValue)}
				expanded
				widthExpanded="w-full"
				background=""
			>
				{#snippet header()}
					<Navigation.Tile
						id="_close"
						labelExpanded="Back"
						expandedClasses="flex-row-reverse"
						onclick={() => (navOpen = false)}
					>
						<iconify-icon icon="tabler:arrow-right" class="mt-1" noobserver></iconify-icon>
					</Navigation.Tile>
				{/snippet}

				{#snippet tiles()}
					{@render renderLinks(NavLinksTop)}
				{/snippet}
				{#snippet footer()}
					{@render renderLinks(NavLinksBottom)}
				{/snippet}
			</Navigation.Rail>
		{/snippet}
	</Modal>
	<SvelteQueryDevtools />
</QueryClientProvider>

{#snippet renderLinks(links: NavLink[])}
	{#each links as link}
		<Navigation.Tile
			id={String(link.id)}
			label={link.label}
			labelExpanded={link.label}
			href={link.href}
			onclick={() => {
				if (navOpen) navOpen = false;
			}}
		>
			<iconify-icon icon={link.icon} class="mt-1" noobserver></iconify-icon>
		</Navigation.Tile>
	{/each}
{/snippet}
