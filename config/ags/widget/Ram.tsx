import { createPoll } from "ags/time"

export default function Ram() {
  const ram = createPoll(
    "  --.-G",
    2000,
    `sh -c "free -b | awk '/Mem:/ {printf \\"  %.1fG\\", $3 / 1024 / 1024 / 1024}'"`
  )

  const ramTip = createPoll(
    "RAM",
    4000,
    `sh -c "free -h | awk '/Mem:/ {printf \\"  RAM used: %s / %s\\ | Percent: %d\%\\", $3, $2, ($3/$2)*100}'"`
  )

  return (
    <button class="Ram" tooltipText={ramTip}>
      <label label={ram} />
    </button>
  )
}