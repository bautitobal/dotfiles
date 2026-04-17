import { createPoll } from "ags/time"

function parseTempValue(text: string): number | null {
  const match = text.match(/(\d+)/)
  return match ? Number(match[1]) : null
}

function tempClass(text: string): string {
  const value = parseTempValue(text)
  if (value === null) return "Temp"
  if (value >= 80) return "Temp critical"
  if (value >= 65) return "Temp warn"
  return "Temp normal"
}

export default function Temp() {
  const temp = createPoll(
    " --°C",
    3000,
    `sh -c 'for z in /sys/class/thermal/thermal_zone*/temp; do [ -r "$z" ] && v=$(cat "$z") && [ "$v" -gt 0 ] 2>/dev/null && printf " %d°C" $((v/1000)) && exit 0; done; echo " --°C"'`
  )

  const tempTip = createPoll(
    "Temperature",
    4000,
    `sh -c 'for z in /sys/class/thermal/thermal_zone*/temp; do [ -r "$z" ] && v=$(cat "$z") && [ "$v" -gt 0 ] 2>/dev/null && printf "Temperature: %d°C" $((v/1000)) && exit 0; done; echo "Temperature: unavailable"'`
  )

  return (
    <button
      class={temp((text) => tempClass(text))}
      tooltipText={tempTip}
    >
      <label label={temp} />
    </button>
  )
}