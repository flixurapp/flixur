import { writable } from "svelte/store";
import type { RGBA } from "./types";

export type PageGradientType = [RGBA, RGBA, RGBA, RGBA];

/** Global page gradient, 4 rgb colors. */
export const PageGradient = writable<PageGradientType>(PageGradientDefault());

export function PageGradientDefault(): PageGradientType {
	return <PageGradientType>new Array(4).fill([0, 0, 0, 0]);
	// this is unneccesary
	/*try {
		const computed = <
			RGB // get computed style of background
		>getComputedStyle(document.body).getPropertyValue("--color-surface-900").split(" ").map(Number);
		return <PageGradientType>new Array(4).fill(computed);
	} catch (err) {
		console.error("Failed to get default page color.", err);
		return <PageGradientType>new Array(4).fill([0, 0, 0]);
	}*/
}
