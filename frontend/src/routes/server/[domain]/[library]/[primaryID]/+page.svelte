<script lang="ts">
	import { page } from "$app/stores";
	import ArtistPage from "./ArtistPage.svelte";
</script>

page for primary (artist, tv show, movie) {$page.params.primaryID}

<ArtistPage />
