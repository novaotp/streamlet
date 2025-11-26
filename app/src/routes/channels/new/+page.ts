import { goto } from "$app/navigation";

export async function load({ parent }) {
	const data = await parent();

	if (!data.user) {
		const message = "You must be authenticated to create a channel.";

		// eslint-disable-next-line svelte/no-navigation-without-resolve
		goto(`/login?message=${encodeURIComponent(message)}&type=error`);
	}
}
