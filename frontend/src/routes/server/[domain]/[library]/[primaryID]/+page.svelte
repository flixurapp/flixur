<script lang="ts">
	import { page } from "$app/stores";
	import ArtistPage from "./ArtistPage.svelte";
</script>

<div class="flex flex-col h-full">
	artist page for {$page.params.domain} + {$page.params.library} + {$page.params.primaryID}

	<ArtistPage />
</div>
