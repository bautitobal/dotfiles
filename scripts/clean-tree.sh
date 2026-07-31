#!/usr/bin/env bash

set -euo pipefail

ROOT="${1:-.}"
OUTPUT="${2:-tree-clean.txt}"
DEPTH="${TREE_DEPTH:-4}"

IGNORE_PATTERN='
.git|
@girs|
girs|
node_modules|
__pycache__|
.pytest_cache|
.mypy_cache|
.cache|
.venv|
venv|
build|
dist|
target|
coverage|
tree.txt|
tree-clean.txt|
*.bak
'

IGNORE_PATTERN="$(echo "$IGNORE_PATTERN" | tr -d '\n ')"

if ! command -v tree >/dev/null 2>&1; then
    echo "Error: no está instalado tree."
    echo "En Arch/CachyOS: sudo pacman -S tree"
    exit 1
fi

if [[ ! -d "$ROOT" ]]; then
    echo "Error: el directorio '$ROOT' no existe."
    exit 1
fi

tree "$ROOT" \
    -a \
    --dirsfirst \
    --prune \
    -L "$DEPTH" \
    -I "$IGNORE_PATTERN" \
    | tee "$OUTPUT"

echo
echo "Árbol guardado en: $OUTPUT"
