#!/bin/bash

# Configuración
NOTIFICATION_TIMEOUT=1000
NOTIFICATION_APP_NAME="System Controls"

# Función para mostrar notificaciones
show_notification() {
    local title="$1"
    local message="$2"
    local icon="$3"

    notify-send -t "$NOTIFICATION_TIMEOUT" -a "$NOTIFICATION_APP_NAME" -i "$icon" "$title" "$message"
}

# Función para volumen con wpctl
volume_notification() {
    local volume=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -oP '\d+\.\d+' | awk '{print int($1*100)}')
    local is_muted=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -q MUTED && echo "true" || echo "false")

    if [ "$is_muted" = "true" ]; then
        show_notification "Audio" "Muted 🔇" "audio-volume-muted"
    else
        if [ "$volume" -eq 0 ]; then
            show_notification "Audio" "0% 🔈" "audio-volume-low"
        elif [ "$volume" -lt 50 ]; then
            show_notification "Audio" "$volume% 🔉" "audio-volume-medium"
        else
            show_notification "Audio" "$volume% 🔊" "audio-volume-high"
        fi
    fi
}

# Función para mute con wpctl
mute_notification() {
    local is_muted=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -q MUTED && echo "true" || echo "false")

    if [ "$is_muted" = "true" ]; then
        show_notification "Audio" "Muted 🔇" "audio-volume-muted"
    else
        show_notification "Audio" "Unmuted 🔊" "audio-volume-high"
    fi
}

# Función para brillo (igual que antes)
brightness_notification() {
    local brightness=$(brightnessctl g)
    local max_brightness=$(brightnessctl m)
    local percentage=$((brightness * 100 / max_brightness))

    if [ "$percentage" -eq 0 ]; then
        show_notification "Brightness" "0% " "display-brightness-off"
    elif [ "$percentage" -lt 60 ]; then
        show_notification "Brightness" "$percentage% 󰃞" "display-brightness-low"
    else
        show_notification "Brightness" "$percentage% 󰃠" "display-brightness-high"
    fi
}

# Manejo de argumentos
case "${1:-}" in
"volume")
    volume_notification
    ;;
"brightness")
    brightness_notification
    ;;
"mute")
    mute_notification
    ;;
*)
    echo "Usage: $0 {volume|brightness|mute}"
    exit 1
    ;;
esac
