<script lang="ts">
	import { afterNavigate } from "$app/navigation";
	import { toaster } from "$lib";
	import {
		PageGradient,
		PageGradientDefault,
		type PageGradientType,
	} from "$lib/background/PageGradient";
	import type { RGBA } from "$lib/background/types";
	import { type NavLink, NavLinksBottom, NavLinksTop } from "$lib/nav";
	import { Dialog, Navigation, Portal, Toast } from "@skeletonlabs/skeleton-svelte";
	import { interpolateLab } from "d3-interpolate";
	import "iconify-icon";
	import { type Snippet } from "svelte";
	import { sineOut } from "svelte/easing";
	import { tweened } from "svelte/motion";
	import { innerWidth } from "svelte/reactivity/window";
	import { fly } from "svelte/transition";
	import "../app.css";

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

	let railValue = $state("0"),
		navOpen = $state(false),
		searchInput: HTMLInputElement;

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

<Toast.Group {toaster}></Toast.Group>

<div
	class="h-screen grid not-md:grid-cols-1 not-md:grid-rows-[1fr_auto] md:grid-rows-1 md:grid-cols-[1fr_auto]"
>
	<main class="overflow-auto w-full">
		{@render children()}
	</main>

	<!-- Desktop -->
	<Navigation
		layout={innerWidth.current! > 768 ? "rail" : "bar"}
		class="w-16 bg-surface-950/70 backdrop-blur-xl not-md:absolute not-md:bottom-0 flex"
	>
		{@const className =
			"btn hover:preset-tonal w-full max-w-full flex flex-col items-center gap-0.5 text-xs"}
		<Navigation.Header>
			<button
				class={["aspect-square", className]}
				onclick={() => (navOpen = true)}
				aria-label="Expand"
			>
				<iconify-icon icon="tabler:menu-2"></iconify-icon>
			</button>
		</Navigation.Header>
		<Navigation.Content>
			{@render renderLinks(NavLinksTop, className)}
		</Navigation.Content>
		<Navigation.Footer class="mt-auto">
			{@render renderLinks(NavLinksBottom, className, true)}
		</Navigation.Footer>
	</Navigation>
</div>
<!-- { x: 250, duration: 250 } -->
<Dialog open={navOpen} onEscapeKeyDown={() => (navOpen = false)}>
	<Dialog.Backdrop class="backdrop-blur-sm bg-surface-50-950/75 fixed inset-0 z-50" />
	<Portal>
		<Dialog.Positioner class="fixed inset-0 z-50 flex justify-end">
			<Dialog.Content class="bg-surface-900 py-4 px-2 shadow-xl h-screen w-[250px]">
				<!-- Search Center -->
				<aside
					class="absolute top-8 left-8 right-[calc(250px+--spacing(8))] bottom-8"
					in:fly={{ y: -100, duration: 100, delay: 100 }}
				>
					<div
						class="input-group grid-cols-[auto_1fr] mt-1 h-16 backdrop-blur-md focus-within:outline focus-within:outline-primary-500"
					>
						<div class="ig-cell preset-tonal w-14">
							<iconify-icon icon="tabler:search" height={16} noobserver></iconify-icon>
						</div>
						<input
							class="ig-input outline-none text-lg"
							type="search"
							placeholder="Search..."
							bind:this={searchInput}
						/>
					</div>
				</aside>

				<!-- Navigation -->
				<Navigation layout="sidebar" class="w-full flex flex-col">
					{@const className =
						"btn hover:preset-tonal w-full flex justify-start items-center gap-1 p-2"}
					<Navigation.Header class="flex mb-2">
						<button class="btn preset-tonal-surface ml-auto" onclick={() => (navOpen = false)}>
							Back
							<iconify-icon icon="tabler:arrow-right" class="mt-1" noobserver></iconify-icon>
						</button>
					</Navigation.Header>
					<Navigation.Content>
						{@render renderLinks(NavLinksTop, className)}
					</Navigation.Content>
					<Navigation.Footer class="mt-auto">
						{@render renderLinks(NavLinksBottom, className)}
					</Navigation.Footer>
				</Navigation>
			</Dialog.Content>
		</Dialog.Positioner>
	</Portal>
</Dialog>

{#snippet renderLinks(links: NavLink[], className: string, noLabel = false)}
	{#each links as link}
		<a
			class={[noLabel && "aspect-square", className]}
			href={link.href}
			onclick={() => {
				if (navOpen) navOpen = false;
			}}
		>
			<iconify-icon icon={link.icon} class="mt-1" noobserver></iconify-icon>
			{#if !noLabel}{link.label}{/if}
		</a>
	{/each}
{/snippet}
