<script lang="ts">
  import { afterNavigate } from "$app/navigation";
  import favicon from "$lib/assets/favicon.svg";
  import { PageGradient, PageGradientDefault, type PageGradientType } from "$lib/background/PageGradient";
  import type { RGBA } from "$lib/background/types";
  import { interpolateLab } from "d3-interpolate";
  import "iconify-icon";
  import { type Snippet } from "svelte";
  import { sineOut } from "svelte/easing";
  import { Tween } from "svelte/motion";
  import "./layout.css";

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
  let currentColor = new Tween<PageGradientType>(PageGradientDefault(), {
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
    if (currentColor.current?.length == 4) {
      /** Amount of separation in alpha for colors. */
      // '4' results in 1, 0.75, 0.50, 0.25
      const ALPHA_FACTOR = 4,
        /** Default alpha of the darkening background overlay. */
        OVERLAY_ALPHA = 0.9;
      // convert gradient to list of rgba colors, in same order
      // opacity is set according to importance of color (index in array)
      const g = currentColor.current.map((g, i) => {
        // clamp decimals to 3 places
        const alpha = Math.round((g[3] ?? 1) * Math.abs(1 * (i / ALPHA_FACTOR) - 1) * 1000) / 1000;
        return `rgba(${g.slice(0, 3).join(", ")}, ${alpha})`;
      });
      const totalAlpha = currentColor.current.map((c) => c[3] ?? 1).reduce((a, b) => a + b) / ALPHA_FACTOR;
      //TODO: could use some work but im happy with it for now
      // the final OVERLAY_ALPHA is set closer to 1 the closer totalAlpha is to 0
      // this way when the background is blended to transparency the overlay is properly 100% opaque
      document.body.style.background = `
linear-gradient(to bottom left, ${g[1]}, ${g[3]}),
linear-gradient(to bottom right, ${g[0]}, ${g[2]}),
color-mix(in oklch, var(--color-gray-900) ${(OVERLAY_ALPHA + (1 - OVERLAY_ALPHA) * (1 - totalAlpha)) * 100}%, white)
`.trim();
      document.body.style.backgroundBlendMode = "overlay";
      document.body.style.backdropFilter = "blur(24px)";
    } else document.body.style.background = "";
  });
</script>

<svelte:head><link rel="icon" href={favicon} /></svelte:head>
{@render children()}
