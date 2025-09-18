#!/bin/bash

# Mensajes posibles
messages=(
    "¿Estás trabajando en lo que importa ahora mismo?"
    "¿Esto te acerca a tu meta?"
    "Apagá el piloto automático"
    "Pequeños pasos -> grandes resultados"
    "Menos dispersión, más acción"
    "Concéntrate: ¿estás en tu modo productivo o disperso?"
    "¿Te estás acercando a la meta?"
    "Recuerda: enfoque = progreso"
    "El momento de actuar es ahora"
    "No pierdas de vista el objetivo"
    "Cada minuto cuenta"
    "Estás en control de tu atención"
)

while true; do
    msg=${messages[$RANDOM %
${#messages[@]}]}
    # Muestra la notificacion
    notify-send -u critical -t 8000 "⏳ Recordatorio de enfoque" "$msg"
    sleep 3600
done
