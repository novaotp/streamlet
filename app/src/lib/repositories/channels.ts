import type { Channel } from "$types/channel";
import type { ChangesetErrors } from "$types/ecto";

export type GetChannelReturn =
	| {
			success: true;
			data: Channel;
	  }
	| {
			success: false;
			message: string;
	  };

export async function getChannel(id: number): Promise<GetChannelReturn> {
	const response = await fetch(`/api/channels/${id}`, {
		headers: {
			Accept: "application/json"
		}
	});

	const result = await response.json();

	return {
		success: response.status === 200,
		...result
	};
}

type CreateChannelData = {
	name: string;
	handle: string;
	description: string;
};

type CreateChannelReturn =
	| {
			success: true;
			message: string;
			data: Channel;
	  }
	| {
			success: false;
			message: string;
			errors: ChangesetErrors;
	  };

export async function createChannel(data: CreateChannelData): Promise<CreateChannelReturn> {
	const response = await fetch("/api/channels", {
		method: "POST",
		body: JSON.stringify(data),
		headers: {
			Accept: "application/json",
            "Content-Type": "application/json"
		}
	});

	const result = await response.json();

	return {
		success: response.status === 201,
		...result
	};
}

type UpdateChannelData = {
	name: string;
	handle: string;
	description: string;
};

type UpdateChannelReturn =
	| {
			success: true;
			message: string;
			data: Channel;
	  }
	| {
			success: false;
			message: string;
			errors?: ChangesetErrors;
	  };

export async function updateChannel(id: number, data: UpdateChannelData): Promise<UpdateChannelReturn> {
	const response = await fetch(`/api/channels/${id}`, {
		method: "PATCH",
		body: JSON.stringify(data),
		headers: {
			Accept: "application/json",
			"Content-Type": "application/json"
		}
	});

	const result = await response.json();

	return {
		success: response.status === 200,
		...result
	};
}

export async function updateChannelAvatar(id: number, avatar: File) {
    const formData = new FormData();
    formData.append("avatar", avatar)

	const response = await fetch(`/api/channels/${id}/avatar`, {
		method: "PUT",
		body: formData,
		headers: {
			Accept: "application/json",
		}
	});

	// const result = await response.json();

	// return {
	// 	success: response.status === 200,
	// 	...result
	// };
}
