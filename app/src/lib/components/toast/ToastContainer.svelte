<svelte:options runes />

<script lang="ts">
    import { Toast } from "@sveltique/components";
    import { toasts } from "$states/toast.svelte";
	import { flip } from "svelte/animate";
	import { fly } from "svelte/transition";
</script>

<div
    role="status"
    aria-live="polite"
    class="right-6 bottom-6 z-1000 fixed flex flex-col justify-center gap-2 w-[calc(100%-3rem)] sm:max-w-xs"
>
    {#each toasts.current as { id, type, content } (id)}
        <div
            animate:flip={{ duration: 150 }}
            transition:fly={{ x: 50, duration: 200 }}
        >
            <Toast {type} onClose={() => toasts.dimiss(id)}>
                {content}
            </Toast>
        </div>
    {/each}
</div>
