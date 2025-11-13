import { getVideos } from "$repositories/videos";

export async function load() {
	return {
		videos: await getVideos()
	};
}
