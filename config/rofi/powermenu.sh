#!/bin/bash

options="Apagar  \nReiniciar  \nSalir  \nBloquear  "

chosen=$(printf "%b" "$options" | rofi -dmenu -i -p "Power" \
    -matching prefix \
    -no-custom \
    -format i)

case "$chosen" in
0) systemctl poweroff ;;
1) systemctl reboot ;;
2) i3-msg exit ;;
3) i3lock-color ;;
esac
