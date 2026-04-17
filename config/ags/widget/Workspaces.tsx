import Gtk from "gi://Gtk?version=4.0"
import Gdk from "gi://Gdk?version=4.0"
import AstalHyprland from "gi://AstalHyprland"

const hypr = AstalHyprland.get_default()

const HDMI_NAME = "HDMI-A-1"
const PRIMARY_RANGE = [1, 2, 3, 4, 5]
const HDMI_RANGE = [6, 7, 8, 9, 10]
const ALL_IDS = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

function getFocusedWorkspaceId(): number | null {
  const candidates = [
    hypr?.focused_workspace?.id,
    hypr?.focusedWorkspace?.id,
    hypr?.active?.workspace?.id,
    hypr?.activeWorkspace?.id,
  ]

  for (const id of candidates) {
    if (typeof id === "number") {
      return id
    }
  }

  return null
}

function getCurrentBarMonitorName(gdkmonitor: Gdk.Monitor): string | null {
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

function workspaceObject(id: number) {
  return (hypr.workspaces ?? []).find((ws: any) => ws.id === id) ?? null
}

function workspaceBelongsToMonitor(id: number, monitorName: string | null): boolean {
  if (!monitorName) return true

  const ws = workspaceObject(id)
  if (!ws) return true

  if (typeof ws.monitor === "string") {
    return ws.monitor === monitorName
  }

  if (ws.monitor?.name) {
    return ws.monitor.name === monitorName
  }

  return true
}

function workspaceOccupied(id: number): boolean {
  const ws = workspaceObject(id)
  if (ws && typeof ws.windows === "number") {
    return ws.windows > 0
  }

  return (hypr.clients ?? []).some((client: any) => client.workspace?.id === id)
}

function allowedIdsForMonitor(monitorName: string | null): number[] {
  const hasHdmi = (hypr.monitors ?? []).some((m: any) => m.name === HDMI_NAME)

  if (!hasHdmi) {
    return ALL_IDS
  }

  if (monitorName === HDMI_NAME) {
    return HDMI_RANGE
  }

  return PRIMARY_RANGE
}

function shouldShowWorkspace(id: number, currentMonitorName: string | null): boolean {
  const focusedId = getFocusedWorkspaceId()
  const focused = focusedId === id
  const occupied = workspaceOccupied(id)
  const allowed = allowedIdsForMonitor(currentMonitorName)

  if (!allowed.includes(id)) {
    return false
  }

  if (focused) {
    return true
  }

  if (!occupied) {
    return false
  }

  return workspaceBelongsToMonitor(id, currentMonitorName)
}

function classesForWorkspace(id: number): string[] {
  const focusedId = getFocusedWorkspaceId()
  const focused = focusedId === id
  const occupied = workspaceOccupied(id)

  const classes = ["workspace"]

  if (occupied) classes.push("occupied")
  if (focused) classes.push("active")

  return classes
}

export default function Workspaces({ gdkmonitor }: { gdkmonitor: Gdk.Monitor }) {
  const buttons = new Map<number, Gtk.Button>()

  return (
    <box
      class="Workspaces"
      spacing={10}
      $={(self) => {
        const sync = () => {
          const currentMonitorName = getCurrentBarMonitorName(gdkmonitor)

          for (const id of ALL_IDS) {
            const button = buttons.get(id)
            if (!button) continue

            button.visible = shouldShowWorkspace(id, currentMonitorName)
            button.set_css_classes(classesForWorkspace(id))
          }
        }

        sync()

        const ids = [
          hypr.connect("event", sync),
          hypr.connect("monitor-added", sync),
          hypr.connect("monitor-removed", sync),
          hypr.connect("workspace-added", sync),
          hypr.connect("workspace-removed", sync),
          hypr.connect("client-added", sync),
          hypr.connect("client-removed", sync),
        ]

        self.connect("destroy", () => {
          for (const id of ids) {
            try {
              hypr.disconnect(id)
            } catch (err) {
              console.error(err)
            }
          }
        })
      }}
    >
      {ALL_IDS.map((id) => (
        <button
          class="workspace"
          $={(self) => buttons.set(id, self)}
          onClicked={() => hypr.message(`dispatch workspace ${id}`)}
        >
          <label label={`${id}`} />
        </button>
      ))}
    </box>
  )
}