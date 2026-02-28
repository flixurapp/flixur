<script lang="ts">
	import type { RatingType } from "./Rating";
	import RatingIcon from "./RatingIcon.svelte";

	interface Props {
		type: RatingType;
		value?: number;
		size?: number;
		class?: string;
	}

	let { type, value = $bindable(0), size = 24, class: className = "" }: Props = $props();

	let displayValue = $state(value);

	const STAR_ICON: [string, string] = ["tabler:star", "tabler:star-filled"],
		STAR_COLOR = "text-yellow-400";
</script>

<div
	class="flex w-fit {className}"
	onmouseleave={() => {
		displayValue = value;
	}}
	role="radiogroup"
	tabindex="-1"
>
	{#if type == "heart"}
		<RatingIcon
			icons={["tabler:heart", "tabler:heart-filled"]}
			{size}
			color="text-red-600"
			value={displayValue > 0 ? 10 : 0}
			toggle
			rawValue={value}
			onchange={(detail) => {
				displayValue = value = detail ? 10 : 0;
			}}
			onhover={(detail) => {
				displayValue = detail === null ? value : 10;
			}}
		/>
	{:else if type == "mood" || type == "stars3"}
		{@const stars = type == "stars3"}
		<RatingIcon
			icons={stars
				? STAR_ICON
				: ["tabler:mood-sad", displayValue > 3 ? "tabler:mood-sad" : "tabler:mood-sad-filled"]}
			{size}
			color={stars ? STAR_COLOR : displayValue > 3 ? "" : "text-red-600"}
			value={displayValue >= 3 ? 2 : 0}
			onchange={(detail) => {
				displayValue = value = detail ? 3 : 0;
			}}
			onhover={(detail) => {
				displayValue = detail === null ? value : 3;
			}}
		/>
		<RatingIcon
			icons={stars
				? STAR_ICON
				: [
						"tabler:mood-empty",
						displayValue > 7 ? "tabler:mood-empty" : "tabler:mood-empty-filled",
					]}
			{size}
			color={stars ? STAR_COLOR : displayValue > 7 ? "" : "text-yellow-600"}
			value={displayValue >= 7 ? 2 : 0}
			onchange={(detail) => {
				displayValue = value = detail ? 7 : 0;
			}}
			onhover={(detail) => {
				displayValue = detail === null ? value : 7;
			}}
		/>
		<RatingIcon
			icons={stars ? STAR_ICON : ["tabler:mood-smile", "tabler:mood-smile-filled"]}
			{size}
			color={stars ? STAR_COLOR : "text-green-600"}
			value={displayValue >= 10 ? 2 : 0}
			onchange={(detail) => {
				displayValue = value = detail ? 10 : 0;
			}}
			onhover={(detail) => {
				displayValue = detail === null ? value : 10;
			}}
		/>
	{:else if type == "stars5" || type == "stars10"}
		{#each new Array(5).fill(null) as _, i}
			<RatingIcon
				icons={STAR_ICON}
				halfIcon={type == "stars10" ? "tabler:star-half-filled" : undefined}
				{size}
				color={STAR_COLOR}
				value={Math.max(displayValue - 2 * i)}
				index={i}
				onchange={(detail) => {
					displayValue = value = i * 2 + detail;
				}}
				onhover={(detail) => {
					displayValue = detail ?? value;
				}}
			/>
		{/each}
	{/if}
</div>
