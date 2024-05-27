import { Channels, extract } from "colorgram";
import type { RGBF } from "./types";

/** Width used for calculating image colors. */
const CALC_WIDTH = 400;

export function calculateBackgroundGradient(image: HTMLImageElement): RGBF[] {
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
}
