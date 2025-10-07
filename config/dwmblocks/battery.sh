#!/usr/bin/env bash
BATINFO=$(upower -i /org/freedesktop/UPower/devices/battery_BAT1)
CAP=$(echo "$BATINFO" | awk '/percentage:/ {print $2}' | tr -d '%')
STATUS=$(echo "$BATINFO" | awk -F': +' '/state:/ {print $2}')
case $STATUS in
  charging) icon="";;
  discharging) icon="";;
  full) icon="";;
  *) icon="";;
esac
    echo "$icon $CAP%"
