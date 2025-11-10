<script module lang="ts">
    type FormSubmitEvent = Parameters<FormEventHandler<HTMLFormElement>>[0];
</script>

<script lang="ts">
	import { Button, Label, Link, TextInput } from "@sveltique/components";
    import IconInfoCircleFilled from "@tabler/icons-svelte/icons/info-circle-filled"
	import { goto } from "$app/navigation";
	import { register } from "$lib/repositories/auth";
	import { toasts } from "$states/toast.svelte";
	import type { FormEventHandler } from "svelte/elements";

    let email = $state("");
    let emailErrors = $state<string[]>([]);

    let password = $state("");
    let passwordErrors = $state<string[]>([]);

    async function onsubmit(event: FormSubmitEvent) {
        event.preventDefault();

        const result = await register(email, password)

        if (!result.success) {
            emailErrors = result.errors.email ?? [];
            passwordErrors = result.errors.password ?? [];

            return toasts.danger(result.message);
        }

        toasts.success(result.message)
        goto("/");
    }
</script>

<svelte:head>
    <title>Register - Streamlet</title>
</svelte:head>

<div class="relative place-items-center grid p-4 w-full min-h-dvh">
    <main class="relative flex flex-col items-center gap-8 w-full max-w-md">
        <h1 class="font-bold text-3xl">Register</h1>
        <form {onsubmit} class="relative flex flex-col items-center gap-4 w-full">
            <div class="relative flex flex-col gap-3 w-full">
                <Label for="email">Email</Label>
                <TextInput
                    bind:value={email}
                    id="email"
                    type="email"
                    required
                    aria-invalid={!!emailErrors.length}
                    class="aria-invalid:border-danger/50 aria-invalid:ring-danger"
                />
                {#if emailErrors.length}
                    <ul class="flex flex-col gap-1">
                        {#each emailErrors as error, i (i)}
                            <li class="flex items-center gap-3">
                                <IconInfoCircleFilled class="size-4 text-danger" />
                                <p class="text-danger text-sm">{error}</p>
                            </li>
                        {/each}
                    </ul>
                {/if}
            </div>
            <div class="relative flex flex-col gap-3 w-full">
                <Label for="password">Password</Label>
                <TextInput
                    bind:value={password}
                    id="password"
                    type="password"
                    required
                    aria-invalid={!!passwordErrors.length}
                    class="aria-invalid:border-danger/50 aria-invalid:ring-danger"
                />
                {#if passwordErrors.length}
                    <ul class="flex flex-col gap-1">
                        {#each passwordErrors as error, i (i)}
                            <li class="flex items-center gap-3">
                                <IconInfoCircleFilled class="size-4 text-danger" />
                                <p class="text-danger text-sm">{error}</p>
                            </li>
                        {/each}
                    </ul>
                {/if}
            </div>
            <Button type="submit">Register</Button>
        </form>
        <p class="text-muted-foreground text-sm">Already have an account ? <Link href="/login">Log in</Link></p>
    </main>
</div>
