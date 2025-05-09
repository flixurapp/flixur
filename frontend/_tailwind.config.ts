import type { Config } from "tailwindcss";

import { contentPath, skeleton } from "@skeletonlabs/skeleton/plugin";
import forms from "@tailwindcss/forms";
import plugin from "tailwindcss/plugin";
import flixurTheme from "./_skeleton.theme";

const config = {
	darkMode: "class",
	content: ["./src/**/*.{html,js,svelte,ts}", contentPath(import.meta.url, "svelte")],
	theme: {
		extend: {},
	},
	plugins: [
		forms,
		// 4. Append the Skeleton plugin (after other plugins)
		skeleton({ themes: [flixurTheme] }),
		plugin(function ({ addVariant, addComponents, addBase, theme }) {
			addVariant("cant-hover", "@media (hover: none)");
			addVariant("has-pointer", "@media (pointer: fine)");
			addComponents([
				{
					// custom extra small icon button component (based off btn-icon-sm)
					".btn-icon-xs": {
						width: "25px",
						"font-size": "0.5rem",
						"line-height": "1rem",
					},
				},
				{
					// custom extra small badge component (add to badge)
					".badge-sm": {
						"font-size": "0.65rem",
						"line-height": "1rem",
						"padding-left": "0.35rem",
						"padding-right": "0.35rem",
						"padding-top": "0.1rem",
						"padding-bottom": "0.1rem",
					},
				},
				{
					// for cards that are to be transparent to the background gradient
					".card.variant-softer": {
						"background-color": "rgb(var(--color-surface-800) / 0.5)",
						"backdrop-filter": "blur(64px)",
					},
				},
			]);

			// https://gist.github.com/Merott/d2a19b32db07565e94f10d13d11a8574
			function extractColorVars(colorObj, colorGroup = "") {
				return Object.keys(colorObj).reduce((vars, colorKey) => {
					const value = colorObj[colorKey];
					// added to filter only hex colors out
					if (typeof value == "string" && !value.startsWith("#")) return vars;

					const newVars =
						typeof value === "string"
							? { [`--color${colorGroup}-${colorKey}`]: value }
							: extractColorVars(value, `-${colorKey}`);

					return { ...vars, ...newVars };
				}, {});
			}
			addBase({
				":root": extractColorVars(theme("colors")),
			});
		}),
	],
} satisfies Config;

export default config;
