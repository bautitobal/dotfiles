#!/usr/bin/env bash
set -euo pipefail

QUOTES_FILE="${XDG_CONFIG_HOME:-$HOME/.config}/hypr/scripts/quotes.txt"

# Fallback si falta el archivo
if [[ ! -f "$QUOTES_FILE" ]]; then
  echo "Controla lo que depende de vos."
  exit 0
fi

grep -v '^[[:space:]]*$' "$QUOTES_FILE" | shuf -n 1
