import { createBinding } from "ags"
import { execAsync } from "ags/process"
import AstalNetwork from "gi://AstalNetwork"

const network = AstalNetwork.get_default()

function getNetworkClass(): string {
  const ssid = network.wifi?.ssid
  const strength = network.wifi?.strength
  const wiredState = network.wired?.state

  if (ssid && ssid.length > 0) {
    if (typeof strength === "number" && strength < 35) {
      return "Network weak"
    }
    return "Network wifi"
  }

  if (wiredState && wiredState > 0) {
    return "Network ethernet"
  }

  return "Network offline"
}

export default function Network() {
  const state = createBinding(network, "state")

  const label = state.as(() => {
    const ssid = network.wifi?.ssid
    const strength = network.wifi?.strength
    const wiredState = network.wired?.state

    if (ssid && ssid.length > 0) {
      const pct = typeof strength === "number" ? ` ${Math.round(strength)}%` : ""
      return `󰖩 ${ssid}${pct}`
    }

    if (wiredState && wiredState > 0) {
      return "󰈀 Ethernet"
    }

    return "󰖪 Offline"
  })

  const tip = state.as(() => {
    const ssid = network.wifi?.ssid
    const strength = network.wifi?.strength
    const wiredState = network.wired?.state

    if (ssid && ssid.length > 0) {
      const pct = typeof strength === "number" ? `${Math.round(strength)}%` : "unknown"
      return `Wi-Fi: ${ssid}\nSignal: ${pct}`
    }

    if (wiredState && wiredState > 0) {
      return "Ethernet connected"
    }

    return "Offline"
  })

  const klass = state.as(() => getNetworkClass())

  return (
    <button
      class={klass}
      tooltipText={tip}
      onClicked={() => execAsync(["kitty", "-e", "nmtui"]).catch(console.error)}
    >
      <label label={label} />
    </button>
  )
}