import { Channels, extract } from "colorgram";
import { PageGradient, PageGradientDefault, type PageGradientType } from "./PageGradient";
import type { RGBA } from "./types";

/** Width used for calculating image colors. */
const CALC_WIDTH = 400;

/** Calculates background gradient for given image. Alpha channel in returned colors is used for color frequency. */
export function calculateBackgroundGradient(image: HTMLImageElement): RGBA[] {
	try {
		// convert image to imagedata
		const canvas = document.createElement("canvas");
		canvas.width = CALC_WIDTH;
		canvas.height = CALC_WIDTH * (image.height / image.width);
		const ctx = canvas.getContext("2d")!;
		ctx.drawImage(image, 0, 0, canvas.width, canvas.height);
		const { data } = ctx.getImageData(0, 0, canvas.width, canvas.height);

		const start = Date.now(),
			colors = extract({
				data: <any>data, // Uint8ClampedArray
				channels: Channels.RGBAlpha,
			});

		//TODO:logger
		console.log(`Gradient time: ${Date.now() - start}ms`);

		return colors;
	} catch (err) {
		console.error("Failed to generate gradient for image", err, image);
		return [];
	}
}

/** Action to add to an image element to set the page gradient to its colors. */
export function iconBackgroundAction(img: HTMLElement) {
	img.addEventListener("load", () => {
		const colors = calculateBackgroundGradient(<HTMLImageElement>img),
			commons = colors.slice(0, 4).map((c) => <RGBA>[...c.slice(0, 3), 1]);
		// failsafe
		if (commons.length == 0) commons.push([0, 0, 0, 0]);
		// ensure there's at least 4 colors in the list
		//TODO: maybe do something with % to make it look better?
		while (commons.length < 4) {
			commons.push(commons[commons.length - 1]);
		}
		PageGradient.set(<PageGradientType>commons);
	});
	img.addEventListener("error", () => removePageGradient());
}

/** Removes the page gradient. */
export function removePageGradient() {
	PageGradient.set(PageGradientDefault());
}
