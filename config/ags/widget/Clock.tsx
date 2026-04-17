import Gtk from "gi://Gtk?version=4.0"
import GLib from "gi://GLib"
import { createPoll } from "ags/time"

export default function Clock() {
  const time = createPoll("", 1000, `date "+%d/%m/%y · %H:%M"`)

  return (
    <button
      class="Clock"
      $={(self) => {
        const popover = new Gtk.Popover()
        const calendar = new Gtk.Calendar()

        popover.set_has_arrow(false)
        popover.set_child(calendar)
        popover.set_parent(self)

        const resetCalendar = () => {
          const now = GLib.DateTime.new_now_local()
          if (!now) return

          calendar.set_year(now.get_year())
          calendar.set_month(now.get_month() - 1)
          calendar.set_day(now.get_day_of_month())
        }

        self.connect("clicked", () => {
          if (popover.is_visible()) {
            popover.popdown()
          } else {
            resetCalendar()
            popover.popup()
          }
        })

        self.connect("destroy", () => {
          try {
            popover.unparent()
          } catch (err) {
            console.error(err)
          }
        })
      }}
    >
      <label label={time} />
    </button>
  )
}