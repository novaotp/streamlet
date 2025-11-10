import type { User } from "$lib/types/user";

export async function getUser() {
	const response = await fetch("/api/users/me", {
		headers: {
			Accept: "application/json"
		}
	});

	if (response.status !== 200) return null;

	const result = await response.json();

	return {
		email: result.email,
		username: result.username,
		inserted_at: new Date(result.inserted_at)
	} satisfies User;
}
