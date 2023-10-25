<script lang="ts">
	import { Avatar } from "@skeletonlabs/skeleton";
	import { IconPencil, IconPlayerPlayFilled } from "@tabler/icons-svelte";
</script>

<div class="relative w-32 h-32 rounded-token [&>div]:hover:opacity-100 cursor-pointer">
	<Avatar
		src="https://i.scdn.co/image/ab6761610000e5ebfd31c630c1a72de7e89a2be7"
		class="absolute top-0 left-0"
		rounded="rounded-[inherit]"
		width="w-full"
	/>
	<div
		class="p-2 gap-2 opacity-0 transition-opacity relative w-full h-full flex items-end justify-center rounded-[inherit] bg-black bg-opacity-50"
	>
		<button class="btn-icon btn-icon-sm variant-filled-primary">
			<IconPlayerPlayFilled />
		</button>
		<button class="btn-icon btn-icon-sm variant-filled-secondary">
			<IconPencil />
		</button>
	</div>
</div>
