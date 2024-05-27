import { writable } from "svelte/store";
import type { RGB } from "./types";

/** Global page gradient, 4 rgb colors. */
export const PageGradient = writable<[RGB, RGB, RGB, RGB] | null>(null);
