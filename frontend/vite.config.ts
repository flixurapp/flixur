import { sveltekit } from "@sveltejs/kit/vite";
import { defineConfig } from "vite";

export default defineConfig({
	plugins: [sveltekit()],
	server: {
		cors: true,
		port: 8787,
		host: true,
	},
});
