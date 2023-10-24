<script>
	import { page } from "$app/stores";
	import { AppBar, AppRail, AppRailAnchor, AppShell } from "@skeletonlabs/skeleton";
	import { IconHome, IconMusic, IconSettings } from "@tabler/icons-svelte";
	import "../app.postcss";
</script>

<AppShell>
	<svelte:fragment slot="header">
		<AppBar>Flixur</AppBar>
	</svelte:fragment>
	<svelte:fragment slot="sidebarLeft">
		<AppRail width="w-14">
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
