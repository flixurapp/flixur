<script lang="ts">
	import { page } from "$app/stores";
	import MusicLibrary from "./MusicLibrary.svelte";
</script>

library page for {$page.params.domain} + {$page.params.library}

<MusicLibrary />
