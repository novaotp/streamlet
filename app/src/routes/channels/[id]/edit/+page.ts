import { error } from "@sveltejs/kit";
import { goto } from "$app/navigation";
import { getChannel } from "$repositories/channels";

export async function load({ params, parent }) {
	const data = await parent();

	if (!data.user) {
		const message = "You must be authenticated to create a channel.";

		// eslint-disable-next-line svelte/no-navigation-without-resolve
		return goto(`/login?message=${encodeURIComponent(message)}&type=error`);
	}

	const result = await getChannel(Number(params.id));

	if (!result.success) {
		throw error(404, result.message);
	}

	if (result.data.user_id !== data.user.id) {
		throw error(403, "You are not allowed to update this channel.");
	}

	return {
		channel: result.data
	};
}
