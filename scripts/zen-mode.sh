#!/bin/bash

# Configuración
ZEN_MODE_FILE="/tmp/hypr_zen_mode"

toggle_zen() {
    # Leer estado actual (por defecto: 0 = modo normal)
    current_mode=0
    if [ -f "$ZEN_MODE_FILE" ]; then
        current_mode=$(cat "$ZEN_MODE_FILE")
    fi

    if [ "$current_mode" -eq 1 ]; then
        # Desactivar Zen Mode (cambiar a 0)
        waybar &
        mako &
        notify-send -a "Zen Mode" "🚀 Normal Mode Restored" -t 3000
        echo "0" > "$ZEN_MODE_FILE"
    else
        # Activar Zen Mode (cambiar a 1)
        pkill -x waybar
        pkill -x mako
        pkill -x mpv
        notify-send -a "Zen Mode" "🌿 Zen Mode Activated" -t 3000
        sleep 0.4
        ~/dotfiles/scripts/pomodoro.py

        echo "1" > "$ZEN_MODE_FILE"
    fi
}

toggle_zen