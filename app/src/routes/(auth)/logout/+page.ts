import { goto } from "$app/navigation";
import { resolve } from "$app/paths";
import { logout } from "$lib/repositories/auth";

export async function load() {
	await logout();

	goto(resolve("/"));
}
