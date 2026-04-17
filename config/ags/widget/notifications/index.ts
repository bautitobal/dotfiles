import { createState } from "ags"
import Notifd from "gi://AstalNotifd"
import AstalHyprland from "gi://AstalHyprland"

export const notifd = Notifd.get_default()
const hypr = AstalHyprland.get_default()

export const [panelOpen, setPanelOpen] = createState(false)
export const [focusedMonitorName, setFocusedMonitorName] = createState<string | null>(null)

function getFocusedMonitor(): string | null {
  const candidates = [
    hypr?.focused_monitor?.name,
    hypr?.focusedMonitor?.name,
    hypr?.active?.monitor?.name,
    hypr?.activeMonitor?.name,
  ]

  for (const name of candidates) {
    if (typeof name === "string" && name.length > 0) {
      return name
    }
  }

  return null
}

function syncFocusedMonitor() {
  setFocusedMonitorName(getFocusedMonitor())
}

syncFocusedMonitor()

for (const signal of [
  "event",
  "monitor-added",
  "monitor-removed",
]) {
  try {
    hypr.connect(signal, syncFocusedMonitor)
  } catch {}
}

export function toggleNotificationsPanel() {
  setPanelOpen((open) => !open)
}

export function closeNotificationsPanel() {
  setPanelOpen(false)
}

export function openNotificationsPanel() {
  setPanelOpen(true)
}