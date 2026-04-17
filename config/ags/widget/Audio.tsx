import Gtk from "gi://Gtk?version=4.0"
import Gdk from "gi://Gdk?version=4.0"
import { createState } from "ags"
import { execAsync } from "ags/process"
import AstalWp from "gi://AstalWp"

const wp = AstalWp.get_default()

function percent(v: number) {
  return Math.round(Number(v) * 100)
}

function speakerIcon(muted: boolean, p: number) {
  if (muted) return "󰖁"
  if (p <= 0) return "󰕿"
  if (p < 50) return "󰖀"
  return "󰕾"
}

function micIcon(muted: boolean) {
  return muted ? "󰍭" : "󰍬"
}

function addScrollVolume(
  widget: Gtk.Widget,
  target: "@DEFAULT_AUDIO_SINK@" | "@DEFAULT_AUDIO_SOURCE@"
) {
  const controller = Gtk.EventControllerScroll.new(
    Gtk.EventControllerScrollFlags.VERTICAL
  )

  controller.connect("scroll", (_controller, _dx, dy) => {
    if (dy < 0) {
      execAsync(["wpctl", "set-volume", target, "5%+"]).catch(console.error)
      return true
    }

    if (dy > 0) {
      execAsync(["wpctl", "set-volume", target, "5%-"]).catch(console.error)
      return true
    }

    return false
  })

  widget.add_controller(controller)
}

function addMiddleClickMute(
  widget: Gtk.Widget,
  target: "@DEFAULT_AUDIO_SINK@" | "@DEFAULT_AUDIO_SOURCE@"
) {
  const gesture = Gtk.GestureClick.new()
  gesture.set_button(Gdk.BUTTON_MIDDLE)

  gesture.connect("pressed", () => {
    execAsync(["wpctl", "set-mute", target, "toggle"]).catch(console.error)
  })

  widget.add_controller(gesture)
}

export default function Audio() {
  const speaker = wp?.defaultSpeaker
  const mic = wp?.defaultMicrophone

  if (!speaker || !mic) {
    return (
      <box class="Audio" spacing={6}>
        <button class="AudioItem speaker normal">
          <label label="󰕾 --%" />
        </button>
        <button class="AudioItem mic normal">
          <label label="󰍬 --%" />
        </button>
      </box>
    )
  }

  const [speakerLabel, setSpeakerLabel] = createState("󰕾 --%")
  const [micLabel, setMicLabel] = createState("󰍬 --%")

  const [speakerTip, setSpeakerTip] = createState("Speaker: Unknown")
  const [micTip, setMicTip] = createState("Mic: Unknown")

  const [speakerClass, setSpeakerClass] = createState("AudioItem speaker normal")
  const [micClass, setMicClass] = createState("AudioItem mic normal")

  const syncSpeaker = () => {
    const p = percent(speaker.volume)
    const muted = !!speaker.mute
    setSpeakerLabel(`${speakerIcon(muted, p)} ${p}%`)
    setSpeakerTip(`Speaker: ${speaker.description ?? "Unknown"}`)
    setSpeakerClass(`AudioItem speaker ${muted ? "muted" : "normal"}`)
  }

  const syncMic = () => {
    const p = percent(mic.volume)
    const muted = !!mic.mute
    setMicLabel(`${micIcon(muted)} ${p}%`)
    setMicTip(`Mic: ${mic.description ?? "Unknown"}`)
    setMicClass(`AudioItem mic ${muted ? "muted" : "normal"}`)
  }

  const openPavu = () => execAsync(["pavucontrol"]).catch(console.error)

  return (
    <box
      class="Audio"
      spacing={6}
      $={(self) => {
        syncSpeaker()
        syncMic()

        const ids = [
          speaker.connect("notify::volume", syncSpeaker),
          speaker.connect("notify::mute", syncSpeaker),
          speaker.connect("notify::description", syncSpeaker),

          mic.connect("notify::volume", syncMic),
          mic.connect("notify::mute", syncMic),
          mic.connect("notify::description", syncMic),
        ]

        self.connect("destroy", () => {
          try {
            speaker.disconnect(ids[0])
            speaker.disconnect(ids[1])
            speaker.disconnect(ids[2])

            mic.disconnect(ids[3])
            mic.disconnect(ids[4])
            mic.disconnect(ids[5])
          } catch (err) {
            console.error(err)
          }
        })
      }}
    >
      <button
        class={speakerClass}
        tooltipText={speakerTip}
        onClicked={openPavu}
        $={(self) => {
          addScrollVolume(self, "@DEFAULT_AUDIO_SINK@")
          addMiddleClickMute(self, "@DEFAULT_AUDIO_SINK@")
        }}
      >
        <label label={speakerLabel} />
      </button>

      <button
        class={micClass}
        tooltipText={micTip}
        onClicked={openPavu}
        $={(self) => {
          addScrollVolume(self, "@DEFAULT_AUDIO_SOURCE@")
          addMiddleClickMute(self, "@DEFAULT_AUDIO_SOURCE@")
        }}
      >
        <label label={micLabel} />
      </button>
    </box>
  )
}