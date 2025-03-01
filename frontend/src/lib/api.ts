import type { RatingType } from "./components/Rating";

export interface ArtistJSON {
	id: string;
	name: string;
	icon: string;
	description?: string;
	location?: string;
	rating: number;
	albums: AlbumJSON[];
}
export interface AlbumJSON {
	id: string;
	name: string;
	icon: string;
	year: number;
	description?: string;
	rating: number;
	type: "single" | "album";
	tracks: TrackJSON[];
}
export interface TrackJSON {
	id: string;
	index: number;
	title: string;
	duration: number;
}

function d(dur: string): number {
	// convert mm:ss to ms
	const [mm, ss] = dur.split(":").map(Number);
	return (mm * 60 + ss) * 1000;
}

export const RATING_SETTING: RatingType = "stars5";

export const SCHEME = location.protocol === "https:" ? "https" : "http";

// TODO: fix ts-ignore
// @ts-ignore
export const TEST_DATA: ArtistJSON[] = [
	{
		id: "testal",
		name: "Aluna",
		icon: "https://i.scdn.co/image/ab6761610000e5ebfd31c630c1a72de7e89a2be7",
		location: "United Kingdom",
		description: `Singer/songwriter Aluna Francis is one-half of the 2012-formed U.K. electronic duo AlunaGeorge and builds upon that act's sound in a solo context to venture further into eclectic dance-pop territory. She debuted with 2020's stylistically elastic Renaissance, followed over the next few years by a string of singles including "Forget About Me," "Nowhere to Hide," and "Killing Me."`,
		rating: 8,
		albums: [
			{
				id: "testalm",
				name: "MYCELiUM",
				icon: "https://i.scdn.co/image/ab67616d0000b273791e5ad29bbd6253aa453293",
				year: 2023,
				rating: 2,
				type: "album",
				tracks: [
					{ id: "test1alm", index: 1, title: "Before The Bloom - Intro", duration: d("00:48") },
					{ id: "test2alm", index: 2, title: "The Way I'm Wired", duration: d("02:51") },
					{ id: "test3alm", index: 3, title: "Underwater", duration: d("03:03") },
					{ id: "test4alm", index: 4, title: "Killing Me", duration: d("03:14") },
					{ id: "test5alm", index: 5, title: "Supernova", duration: d("03:41") },
					{ id: "test6alm", index: 6, title: "Love and Money - Interlude", duration: d("00:30") },
					{ id: "test7alm", index: 7, title: "Oh The Glamour", duration: d("03:21") },
					{ id: "test8alm", index: 8, title: "Running Blind", duration: d("04:39") },
					{ id: "test9alm", index: 9, title: "Mine O Mine", duration: d("03:13") },
					{ id: "test10alm", index: 10, title: "Sugar", duration: d("04:32") },
					{ id: "test11alm", index: 11, title: "Beggin'", duration: d("03:03") },
					{ id: "test12alm", index: 12, title: "Kiss It Better", duration: d("04:17") },
					{ id: "test13alm", index: 13, title: "Playing Wit Ya", duration: d("03:41") },
					{ id: "test14alm", index: 14, title: "Future", duration: d("03:58") },
				],
			},
		],
	},
	{
		id: "testjd",
		name: "Josh Dorey",
		icon: "https://i.scdn.co/image/ab6761610000e5ebf63d17339cf210576a8495fc",
		rating: 10,
		albums: [
			{
				id: "testmjd",
				name: "Motions",
				icon: "https://i.scdn.co/image/ab67616d0000b273e1f7a2b6c4c13179e724e3dc",
				year: 2024,
				rating: 10,
				type: "album",
				tracks: [
					{ id: "test1mjd", index: 1, title: "Kiss", duration: d("02:29") },
					{ id: "test2mjd", index: 2, title: "Motions", duration: d("02:27") },
					{ id: "test3mjd", index: 3, title: "Outta My Mind", duration: d("02:21") },
					{ id: "test4mjd", index: 4, title: "When It's Over", duration: d("04:21") },
				],
			},
		],
	},
	{
		id: "testpi",
		name: "piri",
		icon: "https://i1.sndcdn.com/avatars-SbmE2u9ptJqUzPKO-11Mn2Q-t200x200.jpg",
		rating: 6,
		albums: [
			{
				id: "testpib",
				name: "beachin",
				icon: "https://i1.sndcdn.com/artworks-iit0IbRe4K3N-0-t500x500.jpg",
				year: 2022,
				rating: 8,
				type: "single",
				tracks: [{ id: "test1pib", index: 1, title: "beachin", duration: d("03:14") }],
			},
			{
				id: "testpio",
				name: "on & on",
				icon: "https://i1.sndcdn.com/artworks-7yGAW7enZ1Fc-0-t500x500.jpg",
				year: 2022,
				rating: 10,
				type: "single",
				tracks: [{ id: "test1pio", index: 1, title: "on & on", duration: d("02:19") }],
			},
			{
				id: "testpis",
				name: "soft spot",
				icon: "https://i1.sndcdn.com/artworks-JODSh91actkm-0-t500x500.jpg",
				year: 2022,
				rating: 4,
				type: "single",
				tracks: [{ id: "test1pis", index: 1, title: "soft spot", duration: d("03:39") }],
			},
		],
	},
]
	.map((a) => new Array(100).fill(Math.random()).map((b) => ({ ...a, id: a.id + Math.random() })))
	.flat(1);
