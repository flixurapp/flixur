import { join } from "path";
import type { Config } from "tailwindcss";

// 1. Import the Skeleton plugin
import { skeleton } from "@skeletonlabs/tw-plugin";
import forms from "@tailwindcss/forms";
import plugin from "tailwindcss/plugin";
import { flixurTheme } from "./skeleton.theme";

const config = {
	// 2. Opt for dark mode to be handled via the class method
	darkMode: "class",
	content: [
		"./src/**/*.{html,js,svelte,ts}",
		// 3. Append the path to the Skeleton package
		join(require.resolve("@skeletonlabs/skeleton"), "../**/*.{html,js,svelte,ts}"),
	],
	theme: {
		extend: {},
	},
	plugins: [
		// 4. Append the Skeleton plugin (after other plugins)
		skeleton({ themes: { custom: [flixurTheme] } }),
		plugin(function ({ addVariant, addComponents, addBase, theme }) {
			addVariant("cant-hover", "@media (hover: none)");
			addVariant("has-pointer", "@media (pointer: fine)");
			addComponents([
				// custom extra small icon button component (based off btn-icon-sm)
				{
					".btn-icon-xs": {
						width: "25px",
						"font-size": "0.5rem",
						"line-height": "1rem",
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
		forms,
	],
} satisfies Config;

export default config;
