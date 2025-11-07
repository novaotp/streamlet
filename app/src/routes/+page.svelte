<script lang="ts">
    async function getPing() {
        const response = await fetch('/api/ping', {
            headers: {
                "Accept": "application/json"
            }
        });

        const result = await response.json();

        return result.message as string;
    }
</script>

{#await getPing() then message}
    <p>received : {message}</p>
{/await}
