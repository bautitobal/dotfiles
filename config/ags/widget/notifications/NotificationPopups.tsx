import Gtk from "gi://Gtk?version=4.0"
import GLib from "gi://GLib"
import app from "ags/gtk4/app"
import { Astal, Gdk } from "ags/gtk4"
import AstalHyprland from "gi://AstalHyprland"
import { notifd, focusedMonitorName } from "./index"

const hypr = AstalHyprland.get_default()

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

function createPopupWidget(notification: any, remove: () => void) {
  const root = new Gtk.Box({
    orientation: Gtk.Orientation.VERTICAL,
  })
  root.add_css_class("NotificationPopupItem")

  const top = new Gtk.Box({
    orientation: Gtk.Orientation.HORIZONTAL,
  })
  top.add_css_class("notification-popup-top")

  const appLabel = new Gtk.Label({
    label: getAppName(notification),
    xalign: 0,
    hexpand: true,
  })
  appLabel.add_css_class("notification-popup-app")

  const closeButton = new Gtk.Button()
  closeButton.add_css_class("notification-popup-close")
  closeButton.set_child(new Gtk.Label({ label: "󰅖" }))
  closeButton.connect("clicked", remove)

  top.append(appLabel)
  top.append(closeButton)
  root.append(top)

  const summary = getSummary(notification)
  if (summary.length > 0) {
    const summaryLabel = new Gtk.Label({
      label: summary,
      wrap: true,
      xalign: 0,
    })
    summaryLabel.add_css_class("notification-popup-summary")
    root.append(summaryLabel)
  }

  const body = getBody(notification)
  if (body.length > 0) {
    const bodyLabel = new Gtk.Label({
      label: body,
      wrap: true,
      xalign: 0,
    })
    bodyLabel.add_css_class("notification-popup-body")
    root.append(bodyLabel)
  }

  const idLabel = new Gtk.Label({
    label: `#${getId(notification)}`,
    xalign: 0,
  })
  idLabel.add_css_class("notification-popup-id")
  root.append(idLabel)

  return root
}

export default function NotificationPopups(gdkmonitor: Gdk.Monitor) {
  const { TOP, RIGHT } = Astal.WindowAnchor
  const geometry = gdkmonitor.get_geometry()
  const name = `notifications-popups-${geometry.x}-${geometry.y}`
  const currentMonitorName = getCurrentWindowMonitorName(gdkmonitor)

  return (
    <window
      visible={false}
      name={name}
      class="NotificationPopupsWindow"
      gdkmonitor={gdkmonitor}
      anchor={TOP | RIGHT}
      exclusivity={Astal.Exclusivity.IGNORE}
      application={app}
      $={(win) => {
        const container = new Gtk.Box({
          orientation: Gtk.Orientation.VERTICAL,
          spacing: 8,
        })
        container.add_css_class("NotificationPopups")
        win.set_child(container)

        const popupTimeouts = new Map<number, number>()

        const refreshWindowVisibility = () => {
          win.visible = container.get_first_child() !== null
        }

        const removePopup = (id: number, widget?: Gtk.Widget | null) => {
          const timeoutId = popupTimeouts.get(id)
          if (timeoutId) {
            try {
              GLib.source_remove(timeoutId)
            } catch {}
            popupTimeouts.delete(id)
          }

          if (widget) {
            try {
              container.remove(widget)
            } catch {}
            refreshWindowVisibility()
            return
          }

          let child = container.get_first_child()
          while (child) {
            const next = child.get_next_sibling()
            const popupId = (child as any)._popupId
            if (popupId === id) {
              try {
                container.remove(child)
              } catch {}
              break
            }
            child = next
          }

          refreshWindowVisibility()
        }

        const addPopup = (id: number) => {
          const focused = focusedMonitorName.get()

          if (!focused || focused !== currentMonitorName) {
            return
          }

          let notification: any = null

          try {
            notification = notifd.get_notification?.(id)
          } catch {}

          if (!notification) {
            return
          }

          removePopup(id)

          let popup: Gtk.Widget | null = null
          popup = createPopupWidget(notification, () => removePopup(id, popup))
          ;(popup as any)._popupId = id

          container.prepend(popup)
          refreshWindowVisibility()

          const timeoutId = GLib.timeout_add(GLib.PRIORITY_DEFAULT, 5000, () => {
            removePopup(id, popup)
            return GLib.SOURCE_REMOVE
          })

          popupTimeouts.set(id, timeoutId)
        }

        const ids: number[] = []

        try {
          ids.push(
            notifd.connect("notified", (_src: any, id: number) => {
              addPopup(id)
            })
          )
        } catch (err) {
          console.error(err)
        }

        win.connect("destroy", () => {
          for (const [, timeoutId] of popupTimeouts) {
            try {
              GLib.source_remove(timeoutId)
            } catch {}
          }
          popupTimeouts.clear()

          for (const id of ids) {
            try {
              notifd.disconnect(id)
            } catch (err) {
              console.error(err)
            }
          }
        })
      }}
    />
  )
}