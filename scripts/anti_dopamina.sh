#!/usr/bin/env bash

activities=(
    "Mirar una pared durante 5 minutos|5"
    "Sentarte sin celular ni música por 10 minutos|10"
    "Ordenar un cajón lentamente|10"
    "Leer 10 páginas de un libro en papel|15"
    "Escribir 1 página en tu journal|15"
    "Caminar 15 minutos sin auriculares|15"
    "Tomar mate o agua mirando por la ventana|10"
    "Resolver un sudoku o crucigrama|15"
    "Contar respiraciones durante 5 minutos|5"
    "Hacer una limpieza simple del escritorio|10"
    "Estirarte en silencio por 10 minutos|10"
    "Revisar y ordenar archivos viejos|15"
    "Copiar a mano una cita o reflexión|10"
    "No hacer nada durante 7 minutos|7"
    "Mirar el techo y pensar sin estímulos|7"
    "Mirar hacia una pared sin hacer nada|10"
)

count=${#activities[@]}
index=$((RANDOM % count))

selected="${activities[$index]}"
activity="${selected%%|*}"
minutes="${selected##*|}"

echo "Actividad anti-dopamina del momento:"
echo "→ $activity"
echo
echo "Tiempo sugerido: $minutes minutos"
