export interface ArtistJSON {
	id: string;
	name: string;
	icon: string;
	albums: AlbumJSON[];
}
export interface AlbumJSON {
	id: string;
	name: string;
	icon: string;
	year: number;
	tracks: TrackJSON[];
}
export interface TrackJSON {
	id: string;
	index: number;
	title: string;
}

export const TEST_DATA: ArtistJSON[] = [
	{
		id: "testjd",
		name: "Josh Dorey",
		icon: "https://i.scdn.co/image/ab6761610000e5ebf63d17339cf210576a8495fc",
		albums: [
			{
				id: "testmjd",
				name: "Motions",
				icon: "https://i.scdn.co/image/ab67616d0000b273e1f7a2b6c4c13179e724e3dc",
				year: 2024,
				tracks: [
					{ id: "test1mjd", index: 1, title: "Kiss" },
					{ id: "test2mjd", index: 2, title: "Motions" },
					{ id: "test3mjd", index: 3, title: "Outta My Mind" },
					{ id: "test4mjd", index: 4, title: "When It's Over" },
				],
			},
		],
	},
];
