import type { AlertProps } from "@sveltique/components";

type AlertType = NonNullable<AlertProps["type"]>;

const ALERT_TYPES = ["info", "success", "warning", "danger"] as const satisfies AlertType[];

export function toAlertType(str: string, fallback: AlertType = "info"): AlertType {
	if (ALERT_TYPES.includes(str as AlertType)) {
		return str as AlertType;
	}

	return fallback;
}
