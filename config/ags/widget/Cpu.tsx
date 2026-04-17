import { createPoll } from "ags/time"

function parseCpuValue(text: string): number | null {
  const match = text.match(/(\d+)%/)
  return match ? Number(match[1]) : null
}

function cpuClass(text: string): string {
  const value = parseCpuValue(text)
  if (value === null) return "Cpu"
  if (value >= 85) return "Cpu critical"
  if (value >= 60) return "Cpu warn"
  return "Cpu normal"
}

export default function Cpu() {
  const cpu = createPoll(
    " --%",
    2000,
    `sh -c "top -bn1 | awk '/^%Cpu/ {gsub(\\"id,\\", \\"\\"); printf \\" %d%%\\", 100 - $8}'"`
  )

  const cpuTip = createPoll(
    "CPU",
    4000,
    `sh -c "top -bn1 | awk '/^%Cpu/ {printf \\"CPU usage: %.1f%%\\", 100 - $8}'"`
  )

  return (
    <button
      class={cpu((text) => cpuClass(text))}
      tooltipText={cpuTip}
    >
      <label label={cpu} />
    </button>
  )
}