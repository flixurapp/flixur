import { browser } from "$app/environment";
import { ArtistsApi, Configuration, DefaultApi } from "@flixur/openapi";

export function initials(name: string): string {
	return (
		name
			.split(" ")
			.map((a) => a[0].toUpperCase())
			.join("") || ""
	);
}

// polyfill requestIdleCallback (safari...)
export function requestIdleWork(callback: () => void) {
	if (typeof requestIdleCallback !== "undefined") {
		requestIdleCallback(callback, { timeout: 100 });
	} else {
		setTimeout(callback, 16);
	}
}

const config = new Configuration({
	basePath: `${browser ? window.location.origin : "http://localhost:8787"}/api`,
});

// we dont really care about 'music' or 'search' since they are covered by others
export const API = {
	base: new DefaultApi(config),
	artists: new ArtistsApi(config),
};
