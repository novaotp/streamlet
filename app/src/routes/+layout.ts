import { getUser } from "$lib/repositories/user";

export const ssr = false;

export async function load() {
	return {
		user: await getUser()
	};
}
