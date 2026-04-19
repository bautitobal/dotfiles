#!/usr/bin/env sh

for z in /sys/class/thermal/thermal_zone*/temp; do
    [ -r "$z" ] || continue
    t="$(cat "$z" 2>/dev/null)"
    [ -n "$t" ] || continue
    printf " %d°C" "$((t / 1000))"
    exit 0
done
