import { getChannel } from "$repositories/channels.js";
import { error } from "@sveltejs/kit";

export async function load({ params }) {
	const result = await getChannel(Number(params.id));

	if (!result.success) {
		throw error(404, result.message);
	}

	return {
		channel: result.data
	};
}
