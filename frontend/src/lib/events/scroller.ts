import { browser } from "$app/environment";
import EventEmitter from "eventemitter3";

let IS_SCROLLING = false;

const SCROLL_EMITTER = new EventEmitter<{
	scrollend(): void;
}>();

export const Scrolling = new (class Scrolling {
	constructor() {}
	onScrollEnd(fn: () => void) {
		// if we aren't scrolling then callback can fire immediately
		if (!IS_SCROLLING) fn();
		else SCROLL_EMITTER.once("scrollend", fn);
	}
})();

export function initScrollingEmitter() {
	if (!browser) return;
	let SCROLL_TIMEOUT: NodeJS.Timeout | null = null;
	window.addEventListener(
		"scroll",
		() => {
			IS_SCROLLING = true;
			if (SCROLL_TIMEOUT) clearTimeout(SCROLL_TIMEOUT);
			SCROLL_TIMEOUT = setTimeout(() => {
				IS_SCROLLING = false;
				SCROLL_TIMEOUT = null;
				SCROLL_EMITTER.emit("scrollend");
				// give scrolling a 50ms delay before being "finished"
				// minimum scroll event interval seems to be about 20-30ms
			}, 50);
		},
		true,
	);
}
