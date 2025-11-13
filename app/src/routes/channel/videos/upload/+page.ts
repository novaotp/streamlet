import { goto } from "$app/navigation";

export async function load({ parent, url }) {
	const { user } = await parent();

	if (!user) {
		const message = "Please login to access this page.";
		return goto(
			`/login?message=${encodeURIComponent(message)}&type=error&return-to=${encodeURIComponent(url.pathname)}`
		);
	}
}
