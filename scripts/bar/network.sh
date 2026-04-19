#!/usr/bin/env sh

dev="$(ip -o route show default 2>/dev/null | awk 'NR==1 {print $5}')"

if [ -z "$dev" ]; then
    printf "󰖪 Offline"
    exit 0
fi

if [ -d "/sys/class/net/$dev/wireless" ]; then
    ssid="$(iw dev "$dev" link 2>/dev/null | sed -n 's/^\tSSID: //p')"
    if [ -n "$ssid" ]; then
        printf "󰖩 %s" "$ssid"
    else
        printf "󰖪 Offline"
    fi
else
    carrier="$(cat "/sys/class/net/$dev/carrier" 2>/dev/null)"
    if [ "$carrier" = "1" ]; then
        printf "󰈀 Ethernet"
    else
        printf "󰖪 Offline"
    fi
fi
