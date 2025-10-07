#!/usr/bin/env bash
# Wi-Fi block — rápido, no bloquea y clickeable (Signal 11)

ICON_ON=""
ICON_OFF=""

case "$BLOCK_BUTTON" in
    1) kitty -e nmtui & ;;  # click izquierdo abre nmtui
esac

SSID=$(nmcli -t -f ACTIVE,SSID dev wifi | awk -F: '/^yes/ {print $2}')
if [ -n "$SSID" ]; then
    echo "$ICON_ON $SSID"
elif ip route | grep -q default; then
    echo "$ICON_ON Ethernet"
else
    echo "$ICON_OFF Offline"
fi

