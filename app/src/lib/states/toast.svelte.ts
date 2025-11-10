import type { ToastVariants } from "@sveltique/components";

interface AddData {
	/** @default 'info' */
	type?: ToastVariants["type"];
	content: string;
}

interface ToastData extends Required<AddData> {
	id: string;
}

class Toasts {
	private _current = $state<ToastData[]>([]);

	get current() {
		return this._current;
	}

	public success(content: string) {
		return this.add({ type: "success", content });
	}

	public danger(content: string) {
		return this.add({ type: "danger", content });
	}

	public dimiss(id: string) {
		this._current = this._current.filter((toast) => toast.id !== id);
	}

	private add(data: AddData) {
		const { type = "info", content } = data;

		const id = crypto.randomUUID();

		this._current.push({ id, type, content });

		setTimeout(() => {
			this.dimiss(id);
		}, 3000);
	}
}

export const toasts = new Toasts();
