export type Channel = {
	id: number;
	user_id: number;
	name: string;
	handle: string;
	is_verified: boolean;
	description: string | null;
	avatar_key: string | null;
	banner_key: string | null;
	avatar_path: string | null;
	banner_path: string | null;
};
