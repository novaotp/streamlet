<script lang="ts">
    import { Button, FileInput, Label, TextArea, TextInput } from "@sveltique/components";
	import { createVideo } from "$repositories/videos";
	import { toasts } from "$states/toast.svelte";
	import type { FormSubmitEvent } from "$types/events";

    let title = $state("");
    let description = $state("");
    let file = $state<File>();

    async function onsubmit(event: FormSubmitEvent) {
        event.preventDefault();

        if (!title || !file) return;

        const { message, success } = await createVideo(title, description, file);

        if (!success) {
            return toasts.danger(message);
        }
        
        toasts.success(message);
    }
</script>

<svelte:head>
    <title>Upload a video | Channel - Streamlet</title>
</svelte:head>

<div class="relative place-items-center grid p-4 w-full min-h-dvh">
    <main class="relative flex flex-col items-center gap-8 w-full max-w-md">
        <h1>Upload a video</h1>
        <form {onsubmit} class="relative flex flex-col gap-4 w-full">
            <div class="flex flex-col gap-2">
                <Label for="title">Title *</Label>
                <TextInput bind:value={title} placeholder="My awesome video..." required class="rounded-lg" />
            </div>
            <div class="flex flex-col gap-2">
                <Label for="title">Description</Label>
                <TextArea bind:value={description} placeholder="My awesome description..." required class="rounded-lg" />
            </div>
            <div class="flex flex-col gap-2">
                <Label for="video">Video *</Label>
                <FileInput bind:file accept=".mp4" required class="rounded-lg" />
            </div>
            <Button type="submit">Submit</Button>
        </form>
    </main>
</div>
