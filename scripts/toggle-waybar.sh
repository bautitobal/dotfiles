#!/bin/bash

# Asegurar que Mako está corriendo
pgrep -x mako || mako &

if pgrep -x waybar > /dev/null; then
    notify-send -a "Waybar" "🚫 Waybar disabled" -t 100
    sleep 0.2  # Pequeña pausa para asegurar la notificación
    pkill waybar
else
    waybar &
    notify-send -a "Waybar" "✅ Waybar enabled" -i "waybar"
fi
