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
