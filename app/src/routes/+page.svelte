<script lang="ts">
    let { data } = $props();
</script>

<svelte:head>
    <title>Streamlet</title>
</svelte:head>

{#if data.videos === null}
    <p>error</p>
{:else}
    {#each data.videos as video, i (i)}
        {JSON.stringify(video)}
    {:else}
        <p>no videos to show</p>
    {/each}
{/if}
