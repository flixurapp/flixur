import { Channels, extract } from "colorgram";
import { PageGradient } from "./PageGradient";
import type { RGB, RGBF } from "./types";

/** Width used for calculating image colors. */
const CALC_WIDTH = 400;

export function calculateBackgroundGradient(image: HTMLImageElement): RGBF[] {
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
			commons = colors.slice(0, 4).map((c) => <RGB>c.slice(0, 3));
		// failsafe
		if (commons.length == 0) commons.push([0, 0, 0]);
		// ensure there's at least 4 colors in the list
		//TODO: maybe do something with % to make it look better?
		while (commons.length < 4) {
			commons.push(commons[commons.length - 1]);
		}
		PageGradient.set(<[RGB, RGB, RGB, RGB]>commons);
	});
}
