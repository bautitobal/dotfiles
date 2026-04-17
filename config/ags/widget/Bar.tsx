import app from "ags/gtk4/app"
import { Astal, Gdk } from "ags/gtk4"
import Clock from "./Clock"
import Workspaces from "./Workspaces"
import Network from "./Network"
import Audio from "./Audio"
import Cpu from "./Cpu"
import Ram from "./Ram"
import Temp from "./Temp"
import Tray from "./Tray"
import Battery from "./Battery"
import UserHost from "./UserHost"
import Separator from "./Separator"
import NotificationsButton from "./notifications/NotificationsButton"

export default function Bar(gdkmonitor: Gdk.Monitor) {
  const { TOP, LEFT, RIGHT } = Astal.WindowAnchor
  const geometry = gdkmonitor.get_geometry()
  const barName = `bar-${geometry.x}-${geometry.y}`

  return (
    <window
      visible
      name={barName}
      class="Bar"
      gdkmonitor={gdkmonitor}
      exclusivity={Astal.Exclusivity.EXCLUSIVE}
      anchor={TOP | LEFT | RIGHT}
      application={app}
    >
      <centerbox class="bar-inner">
        <box $type="start" class="bar-section left" spacing={8}>
          <Workspaces gdkmonitor={gdkmonitor} />
          <Separator />
          <UserHost />
        </box>

        <box $type="center" class="bar-section center" spacing={8}>
          <Clock />
        </box>

        <box $type="end" class="bar-section right" spacing={8}>
          <Tray />
          <Separator />
          <Audio />
          <Cpu />
          <Ram />
          <Temp />
          <Battery />
          <Network />
          <Separator />
          <NotificationsButton />
        </box>
      </centerbox>
    </window>
  )
}