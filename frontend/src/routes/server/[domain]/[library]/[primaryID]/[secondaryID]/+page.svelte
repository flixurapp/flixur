<script lang="ts">
	import { page } from "$app/stores";
	import AlbumPage from "./AlbumPage.svelte";
</script>

page for secondary (album, season) {$page.params.secondaryID}

<AlbumPage />
