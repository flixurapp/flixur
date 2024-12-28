<script lang="ts">
	import {
		IconHeart,
		IconHeartFilled,
		IconMoodEmpty,
		IconMoodEmptyFilled,
		IconMoodSad,
		IconMoodSadFilled,
		IconMoodSmile,
		IconMoodSmileFilled,
		IconStar,
		IconStarFilled,
		IconStarHalfFilled,
	} from "@tabler/icons-svelte";
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

	const STAR_ICON: [ConstructorOfATypedSvelteComponent, ConstructorOfATypedSvelteComponent] = [
			IconStar,
			IconStarFilled,
		],
		STAR_COLOR = "yellow-400";
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
			icons={[IconHeart, IconHeartFilled]}
			{size}
			color="red-600"
			value={displayValue > 0 ? 10 : 0}
			toggle
			rawValue={value}
			on:change={({ detail }) => {
				displayValue = value = detail ? 10 : 0;
			}}
			on:hover={({ detail }) => {
				displayValue = detail === null ? value : 10;
			}}
		/>
	{:else if type == "mood" || type == "stars3"}
		{@const stars = type == "stars3"}
		<RatingIcon
			icons={stars ? STAR_ICON : [IconMoodSad, displayValue > 3 ? IconMoodSad : IconMoodSadFilled]}
			{size}
			color={stars ? STAR_COLOR : displayValue > 3 ? "" : "red-600"}
			value={displayValue >= 3 ? 2 : 0}
			on:change={({ detail }) => {
				displayValue = value = detail ? 3 : 0;
			}}
			on:hover={({ detail }) => {
				displayValue = detail === null ? value : 3;
			}}
		/>
		<RatingIcon
			icons={stars
				? STAR_ICON
				: [IconMoodEmpty, displayValue > 7 ? IconMoodEmpty : IconMoodEmptyFilled]}
			{size}
			color={stars ? STAR_COLOR : displayValue > 7 ? "" : "yellow-600"}
			value={displayValue >= 7 ? 2 : 0}
			on:change={({ detail }) => {
				displayValue = value = detail ? 7 : 0;
			}}
			on:hover={({ detail }) => {
				displayValue = detail === null ? value : 7;
			}}
		/>
		<RatingIcon
			icons={stars ? STAR_ICON : [IconMoodSmile, IconMoodSmileFilled]}
			{size}
			color={stars ? STAR_COLOR : "green-600"}
			value={displayValue >= 10 ? 2 : 0}
			on:change={({ detail }) => {
				displayValue = value = detail ? 10 : 0;
			}}
			on:hover={({ detail }) => {
				displayValue = detail === null ? value : 10;
			}}
		/>
	{:else if type == "stars5" || type == "stars10"}
		{#each new Array(5).fill(null) as _, i}
			<RatingIcon
				icons={STAR_ICON}
				halfIcon={type == "stars10" ? IconStarHalfFilled : undefined}
				{size}
				color={STAR_COLOR}
				value={Math.max(displayValue - 2 * i)}
				index={i}
				on:change={({ detail }) => {
					displayValue = value = i * 2 + detail;
				}}
				on:hover={({ detail }) => {
					displayValue = detail ?? value;
				}}
			/>
		{/each}
	{/if}
</div>
