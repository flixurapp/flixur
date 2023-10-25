export function initials(name: string): string {
	return (
		name
			.split(" ")
			.map((a) => a[0].toUpperCase())
			.join("") || ""
	);
}
