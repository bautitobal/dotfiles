import Gtk from "gi://Gtk?version=4.0"
import NotificationItem from "./NotificationItem"
import { notifd } from "./index"

function getNotificationsArray(): any[] {
  try {
    const arr = notifd.notifications
    if (Array.isArray(arr)) return arr
  } catch {}

  try {
    const arr = notifd.get_notifications?.()
    if (Array.isArray(arr)) return arr
  } catch {}

  return []
}

export default function NotificationList() {
  return (
    <scrolledwindow
      class="NotificationsScroll"
      hscrollbarPolicy={Gtk.PolicyType.NEVER}
      vscrollbarPolicy={Gtk.PolicyType.AUTOMATIC}
      minContentHeight={420}
      $={(self) => {
        const content = new Gtk.Box({
          orientation: Gtk.Orientation.VERTICAL,
          spacing: 8,
        })
        content.add_css_class("NotificationsList")

        self.set_child(content)

        const sync = () => {
          let child = content.get_first_child()
          while (child) {
            const next = child.get_next_sibling()
            content.remove(child)
            child = next
          }

          const list = getNotificationsArray()

          if (list.length === 0) {
            const empty = new Gtk.Box({
              orientation: Gtk.Orientation.VERTICAL,
            })
            empty.add_css_class("NotificationsEmpty")

            const label = new Gtk.Label({
              label: "No notifications",
            })

            empty.append(label)
            content.append(empty)
            return
          }

          for (const notification of list) {
            content.append(NotificationItem({ notification }))
          }
        }

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
    />
  )
}