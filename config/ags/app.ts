import app from "ags/gtk4/app"
import Gdk from "gi://Gdk?version=4.0"
import style from "./style.scss"
import Bar from "./widget/Bar"
import NotificationsPanel from "./widget/notifications/NotificationsPanel"
import NotificationPopups from "./widget/notifications/NotificationPopups"

const windows = new Map<string, any>()

function monitorKey(monitor: Gdk.Monitor, index: number) {
  const geometry = monitor.get_geometry()
  return `${geometry.x}x${geometry.y}-${geometry.width}x${geometry.height}-${index}`
}

function destroyWindows() {
  for (const [, win] of windows) {
    try {
      win.destroy()
    } catch (err) {
      console.error(err)
    }
  }
  windows.clear()
}

function rebuildWindows() {
  destroyWindows()

  const display = Gdk.Display.get_default()
  if (!display) return

  const monitors = display.get_monitors()
  const n = monitors.get_n_items()

  for (let i = 0; i < n; i++) {
    const monitor = monitors.get_item(i) as Gdk.Monitor | null
    if (!monitor) continue

    const key = monitorKey(monitor, i)

    const bar = Bar(monitor)
    const notifications = NotificationsPanel(monitor)
    const popups = NotificationPopups(monitor)

    windows.set(`bar-${key}`, bar)
    windows.set(`notifications-${key}`, notifications)
    windows.set(`popups-${key}`, popups)
  }
}

app.start({
  css: style,
  main() {
    const display = Gdk.Display.get_default()
    if (!display) return

    const monitors = display.get_monitors()

    rebuildWindows()

    monitors.connect("items-changed", () => {
      rebuildWindows()
    })
  },
})