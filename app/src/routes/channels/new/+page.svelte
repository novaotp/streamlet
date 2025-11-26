<script lang="ts">
	import { createChannel, updateChannelAvatar } from "$repositories/channels";
	import { toasts } from "$states/toast.svelte";
	import { Button, FileInput, Label, TextArea, TextInput } from "@sveltique/components";
	import type { FormSubmitEvent } from "$types/form";
	import type { Channel } from "$types/channel";

    let isCreatedSuccessfully = $state(false)

    let channel = $state<Channel>()

    let name = $state("")
    let handle = $state("")
    let description = $state("")
    let avatarFile = $state<File>()

    async function onsubmit(event: FormSubmitEvent) {
        event.preventDefault();

        const result = await createChannel({ name, handle, description })

        if (!result.success) {
            return toasts.danger(result.message)
        }

        channel = result.data
        isCreatedSuccessfully = true
        toasts.success(result.message)
    }

    async function onAvatarSubmit(event: FormSubmitEvent) {
        event.preventDefault();

        if (!avatarFile) {
            return toasts.danger("Please add an avatar file.")
        }

        const result = await updateChannelAvatar(channel!.id, avatarFile)

        // if (!result.success) {
        //     return toasts.danger(result.message)
        // }

        // toasts.success(result.message)
    }
</script>

<svelte:head>
    <title>New channel | Channels - Streamlet</title>
</svelte:head>

<div class="relative place-items-center grid p-4 w-full min-h-dvh">
    <main class="relative flex flex-col items-center gap-8 w-full max-w-md">
        {#if !isCreatedSuccessfully}
            <form {onsubmit} class="relative flex flex-col gap-4 w-full">
                <div class="flex flex-col gap-2">
                    <Label for="name">Name *</Label>
                    <TextInput bind:value={name} id="name" name="name" placeholder="John Doe" required />
                </div>
                <div class="flex flex-col gap-2">
                    <Label for="handle">Handle *</Label>
                    <div class="relative">
                        <div class="top-1/2 left-0 absolute place-items-center grid bg-muted px-4 rounded-l-2xl h-full -translate-y-1/2">
                            <span class="text-muted-foreground">@</span>
                        </div>
                        <TextInput bind:value={handle} id="handle" name="handle" placeholder="johndoe" required class="pl-16" />
                    </div>
                </div>
                <div class="flex flex-col gap-2">
                    <Label for="description">Description</Label>
                    <TextArea
                        bind:value={description}
                        id="description"
                        name="description"
                        placeholder="Welcome to my awesome channel where I upload videos about cats and cute animals..."
                        class="min-h-40 resize-none"
                    />
                </div>
                <Button type="submit">Create channel</Button>
            </form>
        {:else}
            <h1>Would you like to add an avatar to your channel ?</h1>
            <form onsubmit={onAvatarSubmit} class="relative w-full flex flex-col gap-4">
                <div class="flex flex-col gap-2">
                    <Label for="avatar">Avatar</Label>
                    <FileInput bind:file={avatarFile} id="avatar" />
                    <p class="text-sm text-muted-foreground">You will be able to add it later.</p>
                </div>
                <div class="relative w-full flex gap-2">
                    <a href="/channels/{channel!.id}">Skip</a>
                    <Button type="submit">Add</Button>
                </div>
            </form>
        {/if}
    </main>
</div>
