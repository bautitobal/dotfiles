#!/bin/bash
# Wayland Screenshot Script (grim + slurp + wl-copy)
# by @bautitobal
DIR="$HOME/Pictures/Screenshots"
mkdir -p "$DIR"

timestamp=$(date +%Y-%m-%d_%H-%M-%S)
filename="Screenshot_${timestamp}.png"
filepath="${DIR}/${filename}"

notify() {
    command -v notify-send >/dev/null && notify-send "$1" "$2"
}

# copy selected area to clipboard
copy_area() {
    grim -g "$(slurp)" - | wl-copy
    notify "📋 Screenshot" "Copied to clipboard"
}

# save selected area to file
save_area() {
    grim -g "$(slurp)" "$filepath"
    notify "📸 Screenshot saved" "$filepath"
}

save_monitor() {
    # try to get focused output geometry (Hyprland / Sway / MangoWC)
    if command -v hyprctl &>/dev/null; then
        geo=$(hyprctl monitors -j | jq -r '.[] | select(.focused==true) | "\(.x),\(.y) \(.width)x\(.height)"')
    elif command -v swaymsg &>/dev/null; then
        geo=$(swaymsg -t get_outputs | jq -r '.[] | select(.focused==true) | "\(.rect.x),\(.rect.y) \(.rect.width)x\(.rect.height)"')
    elif command -v mmsg &>/dev/null; then
        geo=$(mmsg -g -o | jq -r '.[] | select(.focused==true) | "\(.x),\(.y) \(.width)x\(.height)"')
    else
        geo=""
    fi

    # fallback to full screen if geometry not found
    if [ -z "$geo" ]; then
        grim "$filepath"
        notify "🖥️ Screenshot (fallback)" "Saved full screen → $filepath"
    else
        grim -g "$geo" "$filepath"
        notify "🖥️ Screenshot (monitor)" "$filepath"
    fi
}

# save all monitors
save_all() {
    grim "$filepath"
    notify "󰍺 Full Screenshot" "$filepath"
}

case "$1" in
    copy) copy_area ;;
    area) save_area ;;
    monitor) save_monitor ;;
    all) save_all ;;
    *)
        echo "Usage: $0 {copy|area|monitor|all}"
        exit 1
        ;;
esac
