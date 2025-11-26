<script module lang="ts">
    type FormSubmitEvent = Parameters<FormEventHandler<HTMLFormElement>>[0];
</script>

<script lang="ts">
	import { goto } from "$app/navigation";
	import { page } from "$app/state";
	import { login } from "$lib/repositories/auth";
	import { toasts } from "$states/toast.svelte";
	import { toAlertType } from "$utils/to-alert-type";
	import { Alert, Button, Field, Link, TextInput } from "@sveltique/components";
	import type { FormEventHandler } from "svelte/elements";

    let email = $state("");
    let password = $state("")

    async function onsubmit(event: FormSubmitEvent) {
        event.preventDefault();

        const result = await login(email, password);

        if (!result.success) {
            return toasts.danger(result.message);
        }

        toasts.success(result.message);
        goto("/");
    }
</script>

<svelte:head>
    <title>Login - Streamlet</title>
</svelte:head>

<div class="relative place-items-center grid p-4 w-full min-h-dvh">
    <main class="relative flex flex-col items-center gap-8 w-full max-w-md">
        {#if page.url.searchParams.has("message")}
            <Alert type={toAlertType(page.url.searchParams.get("type") ?? "info")}>
                {page.url.searchParams.get("message")}
            </Alert>
        {/if}
        <h1 class="font-bold text-3xl">Login</h1>
        <form {onsubmit} class="relative flex flex-col items-center gap-4 w-full">
            <Field label="Email">
                {#snippet input({ props })}
                    <TextInput bind:value={email} name="email" type="email" required {...props} />
                {/snippet}
            </Field>
            <Field label="Password">
                {#snippet input({ props })}
                    <TextInput bind:value={password} name="password" type="password" required {...props} />
                {/snippet}
            </Field>
            <Button type="submit">Log in</Button>
        </form>
        <p class="text-muted-foreground text-sm">Don't have an account ? <Link href="/register">Register</Link></p>
    </main>
</div>
