import Gtk from "gi://Gtk?version=4.0"

function safeText(value: unknown, fallback = ""): string {
  if (typeof value === "string") return value
  if (value === null || value === undefined) return fallback
  return String(value)
}

function getId(notification: any): number {
  return Number(notification?.id ?? 0)
}

function getAppName(notification: any): string {
  return safeText(notification?.appName ?? notification?.app_name, "Notification")
}

function getSummary(notification: any): string {
  return safeText(notification?.summary, "")
}

function getBody(notification: any): string {
  return safeText(notification?.body, "")
}

function dismissNotification(notification: any) {
  try {
    notification.dismiss?.()
    return
  } catch {}

  try {
    notification.close?.()
    return
  } catch {}

  try {
    notification.remove?.()
    return
  } catch {}

  try {
    notification.resolved?.()
  } catch {}
}

export default function NotificationItem({ notification }: { notification: any }) {
  const root = new Gtk.Box({
    orientation: Gtk.Orientation.VERTICAL,
  })
  root.add_css_class("NotificationItem")

  const top = new Gtk.Box({
    orientation: Gtk.Orientation.HORIZONTAL,
  })
  top.add_css_class("notification-top")

  const app = new Gtk.Label({
    label: getAppName(notification),
    xalign: 0,
    hexpand: true,
  })
  app.add_css_class("notification-app")

  const closeButton = new Gtk.Button()
  closeButton.add_css_class("notification-close")
  closeButton.set_child(
    new Gtk.Label({
      label: "󰅖",
    })
  )
  closeButton.connect("clicked", () => dismissNotification(notification))

  top.append(app)
  top.append(closeButton)
  root.append(top)

  const summary = getSummary(notification)
  if (summary.length > 0) {
    const summaryLabel = new Gtk.Label({
      label: summary,
      wrap: true,
      xalign: 0,
    })
    summaryLabel.add_css_class("notification-summary")
    root.append(summaryLabel)
  }

  const body = getBody(notification)
  if (body.length > 0) {
    const bodyLabel = new Gtk.Label({
      label: body,
      wrap: true,
      xalign: 0,
    })
    bodyLabel.add_css_class("notification-body")
    root.append(bodyLabel)
  }

  const idLabel = new Gtk.Label({
    label: `#${getId(notification)}`,
    xalign: 0,
  })
  idLabel.add_css_class("notification-id")
  root.append(idLabel)

  return root
}