import type { ChangesetErrors } from "$types/ecto";
import type { Video } from "$types/video";

export async function getVideos(): Promise<Video[] | null> {
	const response = await fetch("/api/videos", {
		headers: {
			Accept: "application/json"
		}
	});

	if (response.status !== 200) return null;

	const result = await response.json();

	return result.videos.map((video: Record<string, any>) => {
		return {
			...video,
			inserted_at: new Date(video.inserted_at)
		};
	}) as Video[];
}

type CreateVideoReturn<Success extends boolean> = {
	success: Success;
	message: string;
	data: Success extends false ? never : Video;
	errors: Success extends true ? never : ChangesetErrors;
};

export async function createVideo(
	title: string,
	description: string,
	video: File
): Promise<CreateVideoReturn<boolean>> {
	const formData = new FormData();

	formData.append("title", title);
	formData.append("description", description);
	formData.append("video", video);

	const response = await fetch("/api/videos", {
		method: "POST",
		body: formData,
		headers: {
			Accept: "application/json"
		}
	});

	const result = await response.json();

	return {
		success: response.ok,
		...result
	} as CreateVideoReturn<typeof response.ok>;
}
