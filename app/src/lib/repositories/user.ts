import type { User } from "$lib/types/user";

export async function getUser(): Promise<User | null> {
	const response = await fetch("/api/users/me", {
		headers: {
			Accept: "application/json"
		}
	});

	if (response.status !== 200) return null;

	const result = (await response.json()).data;

	return {
		...result,
		inserted_at: new Date(result.inserted_at)
	} as User;
}
