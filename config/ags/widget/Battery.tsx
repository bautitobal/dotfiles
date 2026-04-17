import { createState } from "ags"
import AstalBattery from "gi://AstalBattery"

const battery = AstalBattery.get_default()

function getProp<T>(obj: any, names: string[], fallback: T): T {
  for (const name of names) {
    try {
      const value = obj?.[name]
      if (value !== undefined && value !== null) {
        return value as T
      }
    } catch {
      // ignore missing GI properties
    }
  }
  return fallback
}

function hasBattery(): boolean {
  const isPresent = getProp<boolean>(battery, ["isPresent", "is_present", "is-present"], true)
  const percentage = getProp<number>(battery, ["percentage", "percent"], NaN)

  // si la API expone "isPresent", lo respetamos
  if (typeof isPresent === "boolean" && !isPresent) {
    return false
  }

  // fallback razonable: si no hay porcentaje válido, ocultamos
  return Number.isFinite(Number(percentage))
}

function getPercentage(): number {
  const value = getProp<number>(battery, ["percentage", "percent"], 0)
  return Math.round(Number(value) * 100)
}

function getCharging(): boolean {
  return getProp<boolean>(battery, ["charging"], false)
}

function getCharged(): boolean {
  return getProp<boolean>(battery, ["charged"], false)
}

function getIcon(): string {
  return getProp<string>(battery, ["iconName", "icon_name", "icon-name"], "󰁹")
}

function getClassName(): string {
  const p = getPercentage()

  if (!hasBattery()) return "Battery hidden"
  if (getCharging()) return "Battery charging"
  if (getCharged() || p >= 95) return "Battery full"
  if (p <= 15) return "Battery critical"
  if (p <= 35) return "Battery low"
  return "Battery normal"
}

function getTooltip(): string {
  const p = getPercentage()

  if (getCharging()) return `Battery: ${p}% (charging)`
  if (getCharged()) return `Battery: ${p}% (full)`
  return `Battery: ${p}%`
}

function getLabel(): string {
  return `${getIcon()} ${getPercentage()}%`
}

export default function Battery() {
  const [visible, setVisible] = createState(false)
  const [klass, setKlass] = createState("Battery hidden")
  const [label, setLabel] = createState("󰁹 --%")
  const [tip, setTip] = createState("Battery")

  const sync = () => {
    const present = hasBattery()
    setVisible(present)

    if (!present) {
      setKlass("Battery hidden")
      setLabel("󰁹 --%")
      setTip("No battery")
      return
    }

    setKlass(getClassName())
    setLabel(getLabel())
    setTip(getTooltip())
  }

  return (
    <button
      visible={visible}
      class={klass}
      tooltipText={tip}
      $={(self) => {
        sync()

        const ids: number[] = []

        for (const signal of [
          "notify::percentage",
          "notify::percent",
          "notify::charging",
          "notify::charged",
          "notify::icon-name",
          "notify::icon_name",
          "notify::iconName",
          "notify::is-present",
          "notify::is_present",
          "notify::isPresent",
        ]) {
          try {
            ids.push(battery.connect(signal, sync))
          } catch {
            // algunas props/señales no existen según la build
          }
        }

        self.connect("destroy", () => {
          for (const id of ids) {
            try {
              battery.disconnect(id)
            } catch (err) {
              console.error(err)
            }
          }
        })
      }}
    >
      <label label={label} />
    </button>
  )
}