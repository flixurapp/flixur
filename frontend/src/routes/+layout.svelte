<script lang="ts">
	import { afterNavigate } from "$app/navigation";
	import { page } from "$app/stores";
	import {
		AppBar,
		AppRail,
		AppRailAnchor,
		AppShell,
		Toast,
		initializeStores,
	} from "@skeletonlabs/skeleton";
	import type { AfterNavigate } from "@sveltejs/kit";
	import { IconHome, IconMusic, IconSettings } from "@tabler/icons-svelte";
	import "../app.postcss";

	initializeStores();

	afterNavigate((params: AfterNavigate) => {
		const isNewPage: boolean = params.from?.route.id !== params.to?.route.id;
		const elemPage = document.querySelector("#page");
		if (isNewPage && elemPage !== null) {
			elemPage.scrollTop = 0;
		}
	});
</script>

<Toast />

<AppShell slotPageContent="px-3 py-2">
	<svelte:fragment slot="header">
		<AppBar>Flixur</AppBar>
	</svelte:fragment>
	<svelte:fragment slot="sidebarLeft">
		<AppRail width="w-16">
			<AppRailAnchor href="/" selected={$page.url.pathname == "/"}>
				<IconHome slot="lead" />
				Home
			</AppRailAnchor>
			<AppRailAnchor
				href="/server/flixur.app/music"
				selected={$page.url.pathname == "/server/flixur.app/music"}
			>
				<IconMusic slot="lead" />
				Music
			</AppRailAnchor>
			<svelte:fragment slot="trail">
				<AppRailAnchor href="/settings" selected={$page.url.pathname == "/settings"}>
					<IconSettings slot="lead" />
					Settings
				</AppRailAnchor>
			</svelte:fragment>
		</AppRail>
	</svelte:fragment>
	<slot />
</AppShell>
