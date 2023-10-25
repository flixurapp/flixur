<!-- For Artists and Albums -->

<script lang="ts">
	import { Avatar } from "@skeletonlabs/skeleton";
	import { IconPencil, IconPlayerPlayFilled } from "@tabler/icons-svelte";
	import { createEventDispatcher } from "svelte";
	import { initials } from "./utils";

	/** Name of the media. */
	export let name: string;
	/** Link to the media. */
	export let href: string;
	/** Optional image URL for the media. If not specified, will use initials generated from `name`. */
	export let image: string | undefined = undefined;

	const dispatch = createEventDispatcher();
</script>

<div class="flex flex-col [&>:first-child>div]:hover:opacity-100 sm:w-32 w-1/3">
	<a {href} class="block relative w-full aspect-square rounded-token cursor-pointer">
		<Avatar
			src={image}
			initials={initials(name)}
			class="absolute top-0 left-0"
			rounded="rounded-[inherit]"
			width="w-full"
		/>
		<div
			class="p-2 gap-2 opacity-0 transition-opacity relative w-full h-full flex items-end justify-center rounded-[inherit] bg-black bg-opacity-50"
		>
			<button
				class="btn-icon btn-icon-sm variant-filled-primary"
				on:click|preventDefault={() => dispatch("play")}
			>
				<IconPlayerPlayFilled />
			</button>
			<button
				class="btn-icon btn-icon-sm variant-filled-secondary"
				on:click|preventDefault={() => dispatch("edit")}
			>
				<IconPencil />
			</button>
		</div>
	</a>
	<a
		class="hover:underline sm:text-base text-sm whitespace-nowrap overflow-hidden overflow-ellipsis"
		{href}
	>
		{name}
	</a>
</div>
