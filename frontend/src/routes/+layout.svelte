<script lang="ts">
	import { afterNavigate } from "$app/navigation";
	import { page } from "$app/stores";
	import { PageGradient } from "$lib/background/PageGradient";
	import EditModal from "$lib/modals/edit/EditModal.svelte";
	import {
		AppBar,
		AppRail,
		AppRailAnchor,
		AppShell,
		Modal,
		Toast,
		initializeStores,
		type ModalComponent,
	} from "@skeletonlabs/skeleton";
	import { IconHome, IconMusic, IconSearch, IconSettings } from "@tabler/icons-svelte";
	import "../app.postcss";

	initializeStores();

	afterNavigate((params) => {
		const isNewPage: boolean = params.from?.route.id !== params.to?.route.id;

		const elemPage = document.querySelector("#page");
		if (isNewPage && elemPage !== null) {
			elemPage.scrollTop = 0;
		}
	});

	const modalRegistry: Record<string, ModalComponent> = {
		edit: { ref: EditModal },
	};

	let oldColors: typeof $PageGradient = null;
	$: if (typeof document !== "undefined" && document.body) {
		// ensure gradient is there and correct
		if ($PageGradient?.length == 4) {
			// convert gradient to list of rgba colors, in same order
			// opacity is set according to importance of color (index in array)
			const g = $PageGradient.map((g, i) => `rgba(${g.join(",")}, ${Math.abs(1 * (i / 4) - 1)})`);
			//TODO: could use some work but im happy with it for now
			document.body.style.background = `
				linear-gradient(to bottom left, ${g[1]}, ${g[3]}),
				linear-gradient(to bottom right, ${g[0]}, ${g[2]}),
				rgb(var(--color-surface-900) / 0.9)
				`.trim();
			document.body.style.backgroundBlendMode = "overlay";
			document.body.style.backdropFilter = "blur(24px)";
		} else document.body.style.background = "";

		// save colors for interpolation
		oldColors = $PageGradient;
	}
</script>

<Modal components={modalRegistry} />
<Toast />

<AppShell slotPageContent="px-3 py-2">
	<svelte:fragment slot="header">
		<AppBar>
			<svelte:fragment slot="lead">Flixur</svelte:fragment>
			<div class="input-group input-group-divider grid-cols-[auto_1fr_auto] w-fit">
				<input class="input" title="Input (text)" type="text" placeholder="Search" />
				<button class="variant-filled-secondary">
					<IconSearch size={18} />
				</button>
			</div>
		</AppBar>
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
