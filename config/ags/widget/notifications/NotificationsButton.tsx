import { createState } from "ags"
import { notifd, toggleNotificationsPanel, panelOpen } from "./index"

function getNotificationsCount(): number {
  try {
    const arr = notifd.notifications
    if (Array.isArray(arr)) return arr.length
  } catch {}

  try {
    const arr = notifd.get_notifications?.()
    if (Array.isArray(arr)) return arr.length
  } catch {}

  return 0
}

export default function NotificationsButton() {
  const [count, setCount] = createState(getNotificationsCount())

  const sync = () => {
    setCount(getNotificationsCount())
  }

  return (
    <button
      class={panelOpen((open) => `NotificationsButton ${open ? "active" : ""}`)}
      tooltipText={count((n) => `Notifications: ${n}`)}
      onClicked={toggleNotificationsPanel}
      $={(self) => {
        sync()

        const ids: number[] = []

        for (const signal of [
          "notified",
          "resolved",
          "dismissed",
          "closed",
          "notify::notifications",
        ]) {
          try {
            ids.push(notifd.connect(signal, sync))
          } catch {}
        }

        self.connect("destroy", () => {
          for (const id of ids) {
            try {
              notifd.disconnect(id)
            } catch (err) {
              console.error(err)
            }
          }
        })
      }}
    >
      <box spacing={4}>
        <label label="󰂚" />
        <label
          class="notifications-count"
          visible={count((n) => n > 0)}
          label={count((n) => `${n}`)}
        />
      </box>
    </button>
  )
}