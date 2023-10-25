<script lang="ts">
	import { getToastStore } from "@skeletonlabs/skeleton";
	import { IconPencil, IconPlayerPlayFilled } from "@tabler/icons-svelte";

	const toasts = getToastStore();
</script>

<table class="table table-hover table-compact table-fixed w-1/2 mx-auto">
	<tbody>
		{#each ["Before The Bloom - Intro", "The Way I'm Wired", "Underwater", "Killing Me", "Supernova", "Love and Money - Interlude", "Oh The Glamour", "Running Blind", "Mine O Mine", "Sugar", "Beggin'", "Kiss It Better", "Playing Wit Ya", "Future"] as name, i}
			<tr
				class="flex items-center [&>:first-child>span]:hover:hidden [&>td>button]:hover:inline-flex"
			>
				<td>
					<span class="badge btn-icon-sm rounded-full variant-soft-primary">{i + 1}</span>
					<button
						class="btn-icon btn-icon-sm variant-filled-primary hidden"
						on:click={() => toasts.trigger({ message: "play button clicked" })}
					>
						<IconPlayerPlayFilled size={20} />
					</button>
				</td>
				<td class="flex-1 overflow-hidden overflow-ellipsis !whitespace-nowrap">{name}</td>
				<td align="right">
					<button
						class="btn-icon btn-icon-sm variant-filled-secondary hidden"
						on:click={() => toasts.trigger({ message: "edit button clicked" })}
					>
						<IconPencil size={20} />
					</button>
				</td>
			</tr>
		{/each}
	</tbody>
</table>
