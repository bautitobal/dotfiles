#!/usr/bin/env sh

out="$(wpctl get-volume @DEFAULT_AUDIO_SINK@ 2>/dev/null)" || exit 1

case "$out" in
*MUTED*)
    printf "󰝟 stumm"
    ;;
*)
    vol="$(printf "%s\n" "$out" | awk '/Volume:/ {printf "%d", $2 * 100}')"
    [ -n "$vol" ] || vol="0"
    printf "󰕾 %s%%" "$vol"
    ;;
esac
