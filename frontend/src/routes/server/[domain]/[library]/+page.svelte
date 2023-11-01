<script lang="ts">
	import { page } from "$app/stores";
	import MusicLibrary from "./MusicLibrary.svelte";
</script>

<div class="flex flex-col h-full">
	library page for {$page.params.domain} + {$page.params.library}

	<MusicLibrary />
</div>
