export interface NavLink {
	id: number;
	label: string;
	href: string;
	icon: string;
}
export const NavLinksTop: NavLink[] = [
	{
		id: 0,
		label: "Home",
		href: "/",
		icon: "tabler:home",
	},
	{
		id: 1,
		label: "Music",
		href: "/server/flixur.app/music",
		icon: "tabler:music",
	},
];
export const NavLinksBottom: NavLink[] = [
	{
		id: 2,
		label: "Settings",
		href: "/settings",
		icon: "tabler:settings",
	},
];
