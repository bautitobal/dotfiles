import GLib from "gi://GLib"

export default function UserHost() {
  const user = GLib.get_user_name()
  const host = GLib.get_host_name()

  return (
    <box class="UserHost" spacing={4}>
      <label class="userhost-main" label={`${user}@${host}`} />
      <label class="userhost-symbol" label="φ" />
    </box>
  )
}