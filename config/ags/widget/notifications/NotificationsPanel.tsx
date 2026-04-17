import Gtk from "gi://Gtk?version=4.0"
import app from "ags/gtk4/app"
import { Astal, Gdk } from "ags/gtk4"
import AstalHyprland from "gi://AstalHyprland"
import NotificationList from "./NotificationList"
import { notifd, panelOpen, closeNotificationsPanel, focusedMonitorName } from "./index"

const hypr = AstalHyprland.get_default()

function clearAll() {
  try {
    const list = Array.isArray(notifd.notifications) ? notifd.notifications : []

    for (const notification of list) {
      try {
        notification.dismiss?.()
      } catch {}

      try {
        notification.close?.()
      } catch {}
    }
  } catch (err) {
    console.error(err)
  }
}

function getCurrentWindowMonitorName(gdkmonitor: Gdk.Monitor): string | null {
  const geometry = gdkmonitor.get_geometry()

  const match = (hypr.monitors ?? []).find((monitor: any) => {
    return monitor.x === geometry.x && monitor.y === geometry.y
  })

  if (match?.name) return match.name

  if ((hypr.monitors ?? []).length === 1) {
    return hypr.monitors[0]?.name ?? null
  }

  return null
}

export default function NotificationsPanel(gdkmonitor: Gdk.Monitor) {
  const { TOP, RIGHT } = Astal.WindowAnchor
  const geometry = gdkmonitor.get_geometry()
  const name = `notifications-panel-${geometry.x}-${geometry.y}`
  const currentMonitorName = getCurrentWindowMonitorName(gdkmonitor)

  const visible = panelOpen.as((open) => {
    const focused = focusedMonitorName.get()
    return open && focused !== null && focused === currentMonitorName
  })

  return (
    <window
      visible={visible}
      name={name}
      class="NotificationsPanelWindow"
      gdkmonitor={gdkmonitor}
      anchor={TOP | RIGHT}
      exclusivity={Astal.Exclusivity.IGNORE}
      application={app}
    >
      <box class="NotificationsPanel" orientation={Gtk.Orientation.VERTICAL}>
        <box class="notifications-header">
          <label class="notifications-title" label="Notifications" hexpand xalign={0} />

          <button class="notifications-clear" onClicked={clearAll}>
            <label label="Clear" />
          </button>

          <button class="notifications-close" onClicked={closeNotificationsPanel}>
            <label label="󰅖" />
          </button>
        </box>

        <NotificationList />
      </box>
    </window>
  )
}