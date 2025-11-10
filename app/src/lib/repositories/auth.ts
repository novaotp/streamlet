import type { ChangesetErrors } from "$types/ecto";

type RegisterFailure = {
	success: false;
	message: string;
	errors: ChangesetErrors;
};

type RegisterSuccess = {
	success: true;
	message: string;
};

/** Registers a user. */
export async function register(email: string, password: string): Promise<RegisterSuccess | RegisterFailure> {
	const response = await fetch("/api/auth/register", {
		method: "POST",
		body: JSON.stringify({ email, password }),
		headers: {
			Accept: "application/json",
			"Content-Type": "application/json"
		}
	});

	const result = await response.json();

	if (response.status !== 201) {
		return { success: false, ...result } satisfies RegisterFailure;
	}

	return { success: true, ...result } satisfies RegisterSuccess;
}

type LoginResult = {
	success: boolean;
	message: string;
};

export async function login(email: string, password: string): Promise<LoginResult> {
	const response = await fetch("/api/auth/login", {
		method: "POST",
		body: JSON.stringify({ email, password }),
		headers: {
			Accept: "application/json",
			"Content-Type": "application/json"
		}
	});

	const result = await response.json();

	return {
		success: response.status === 200,
		...result
	} satisfies LoginResult;
}

export async function logout() {
	await fetch("/api/auth/logout", {
		method: "POST"
	});
}
