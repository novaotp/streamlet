<script lang="ts">
    let { data } = $props();
</script>

<div class="relative place-items-center grid p-4 w-full min-h-dvh">
    <main class="relative flex flex-col items-center gap-8 w-full max-w-md">
        <div class="relative flex gap-8 w-full">
            <div class="relative bg-black rounded-full size-20"></div>
            <div class="flex flex-col gap-1">
                <h1 class="font-bold text-2xl">{data.channel.name}</h1>
                <span>@{data.channel.handle}</span>
                {#if data.channel.description}
                    <p>{data.channel.description}</p>
                {/if}
            </div>
        </div>
    </main>
</div>
