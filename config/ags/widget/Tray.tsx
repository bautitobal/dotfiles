import Gtk from "gi://Gtk?version=4.0"
import Gdk from "gi://Gdk?version=4.0"
import AstalTray from "gi://AstalTray"
import { createBinding, For } from "ags"

const tray = AstalTray.get_default()

function setupTrayButton(button: Gtk.Button, item: any) {
  let popover: Gtk.PopoverMenu | null = null

  const rebuildPopover = () => {
    if (popover) {
      popover.unparent()
      popover = null
    }

    if (item.menuModel) {
      popover = Gtk.PopoverMenu.new_from_model(item.menuModel)
      popover.set_has_arrow(false)
      popover.set_position(Gtk.PositionType.BOTTOM)
      popover.insert_action_group("dbusmenu", item.actionGroup ?? null)
      popover.set_parent(button)
    }
  }

  rebuildPopover()

  item.connect("notify::menu-model", rebuildPopover)
  item.connect("notify::action-group", rebuildPopover)

  const gesture = Gtk.GestureClick.new()
  gesture.set_button(0)

  gesture.connect("pressed", (_gesture, _nPress, _x, _y) => {
    const current = gesture.get_current_button()

    if (current === Gdk.BUTTON_PRIMARY) {
      item.activate?.(0, 0)
    } else if (current === Gdk.BUTTON_SECONDARY) {
      if (popover) {
        popover.popup()
      } else {
        item.secondary_activate?.(0, 0)
      }
    }
  })

  button.add_controller(gesture)
}

export default function Tray() {
  const items = createBinding(tray, "items")

  return (
    <box class="Tray" spacing={4}>
      <For each={items}>
        {(item: any) => (
          <button
            class="TrayButton"
            tooltipText={createBinding(item, "tooltipText")}
            $={(self) => setupTrayButton(self, item)}
          >
            <image class="TrayIcon" gicon={createBinding(item, "gicon")} />
          </button>
        )}
      </For>
    </box>
  )
}