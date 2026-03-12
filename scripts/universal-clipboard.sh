#!/bin/bash
# Universal Clipboard — Wayland (wl-clipboard + wtype + cliphist + rofi)
# by @bautitobal

set -euo pipefail

have() { command -v "$1" >/dev/null 2>&1; }
notify() { have notify-send && notify-send "$@"; }

for dep in wl-copy wl-paste wtype; do
  if ! have "$dep"; then
    notify "Clipboard Error" "Missing dependency: $dep"
    exit 1
  fi
done

copy_primary_to_clipboard() {
  if wl-paste -p -n >/dev/null 2>&1; then
    wl-paste -p | wl-copy
    notify "📋 Copied" "Primary → Clipboard"
    exit 0
  fi
  notify "ℹ️ Nothing selected" "No primary selection to copy"
}

paste_clipboard_with_wtype() {
  text="$(wl-paste -n 2>/dev/null || true)"
  if [ -z "$text" ]; then
    text="$(wl-paste -pn 2>/dev/null || true)"
  fi

  if [ -z "$text" ]; then
    notify "⚠️ Paste failed" "Clipboard and Primary are empty"
    exit 1
  fi

  # quitar salto de línea final
  clean_text="$(printf "%s" "$text")"

  wtype -- "$clean_text"
}

menu_clipboard_rofi() {
  if ! have cliphist || ! have rofi; then
    notify "Clipboard Menu" "Install cliphist and rofi to use the menu"
    exit 1
  fi

  choice="$(cliphist list | rofi -dmenu -p '📋 Clipboard:')"
  [ -z "${choice:-}" ] && exit 0

  cliphist decode <<<"$choice" | wl-copy

  text="$(wl-paste -n 2>/dev/null || true)"
  [ -z "$text" ] && text="$(wl-paste -pn 2>/dev/null || true)"

  # quitar salto de línea final
  clean_text="$(printf "%s" "$text")"

  wtype -- "$clean_text"
}

case "${1:-}" in
  copy)   copy_primary_to_clipboard ;;
  paste)  paste_clipboard_with_wtype ;;
  menu)   menu_clipboard_rofi ;;
  *) echo "Usage: $0 {copy|paste|menu}"; exit 1 ;;
esac

