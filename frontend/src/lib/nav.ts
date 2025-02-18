import type { Icon } from "@tabler/icons-svelte";
import Home from "@tabler/icons-svelte/icons/home";
import Music from "@tabler/icons-svelte/icons/music";
import Settings from "@tabler/icons-svelte/icons/settings";

export interface NavLink {
	id: number;
	label: string;
	href: string;
	icon: Icon;
}
export const NavLinksTop: NavLink[] = [
	{
		id: 0,
		label: "Home",
		href: "/",
		icon: Home,
	},
	{
		id: 1,
		label: "Music",
		href: "/server/flixur.app/music",
		icon: Music,
	},
];
export const NavLinksBottom: NavLink[] = [
	{
		id: 2,
		label: "Settings",
		href: "/settings",
		icon: Settings,
	},
];
