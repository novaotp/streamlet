import type { FormEventHandler } from "svelte/elements";

export type FormSubmitEvent = Parameters<FormEventHandler<HTMLFormElement>>[0];
