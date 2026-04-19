#!/usr/bin/env sh

for bat in /sys/class/power_supply/BAT*; do
    [ -e "$bat" ] || continue

    cap="$(cat "$bat/capacity" 2>/dev/null)"
    status="$(cat "$bat/status" 2>/dev/null)"

    [ -n "$cap" ] || exit 0

    if [ "$status" = "Charging" ]; then
        icon="󰂄"
    elif [ "$status" = "Full" ] || [ "$cap" -eq 100 ]; then
        icon="󰁹"
    elif [ "$cap" -ge 80 ]; then
        icon="󰂂"
    elif [ "$cap" -ge 55 ]; then
        icon="󰁿"
    elif [ "$cap" -ge 19 ]; then
        icon="󰁼"
    else
        icon="󰁺"
    fi

    printf "%s %s%%" "$icon" "$cap"
    exit 0
done
