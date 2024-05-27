<script lang="ts">
	import { removePageGradient } from "$lib/background/gradient";
	import Rating from "$lib/components/Rating.svelte";
	import { onMount } from "svelte";

	onMount(removePageGradient);
</script>

<p>ui test page</p>

<Rating type="heart" />
<Rating type="mood" />
<Rating type="stars3" />
<Rating type="stars5" />
<Rating type="stars10" />
