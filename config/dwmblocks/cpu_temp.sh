#!/usr/bin/env bash
# 🌡️ CPU temperature

# Usa 'sensors' del paquete lm_sensors
TEMP=$(sensors 2>/dev/null | awk '/Package id 0/ {gsub("+",""); print $4; exit}')
[ -z "$TEMP" ] && TEMP=$(cat /sys/class/thermal/thermal_zone*/temp 2>/dev/null | head -n1 | awk '{printf "%.0f°C", $1/1000}')
echo " $TEMP"
