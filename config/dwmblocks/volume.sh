#!/usr/bin/env bash
# Usar con Signal 10

get_vol() {
    vol=$(wpctl get-volume @DEFAULT_AUDIO_SINK@)
    muted=$(echo "$vol" | grep -o MUTED)
    level=$(echo "$vol" | awk '{print int($2*100)}')
    if [ "$muted" ]; then
        echo "󰸈 Mute"
    else
        if [ "$level" -gt 70 ]; then
            echo " $level%"
        elif [ "$level" -gt 30 ]; then
            echo " $level%"
        else
            echo " $level%"
        fi
    fi
}

case "$BLOCK_BUTTON" in
    1) wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle ;;  # click izquierdo → mute/unmute
    4) wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+ ;;   # scroll up
    5) wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%- ;;   # scroll down
esac

get_vol
pkill -RTMIN+10 dwmblocks

