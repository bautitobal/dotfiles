#!/usr/bin/env bash
# ==========================================
# link-dotfiles.sh
# Crea symlinks de config/ → ~/.config, scripts/ → ~/scripts y home/* → ~
# - Detecta ruta del repo por la ubicación del script
# - Si el destino ya existe (archivo/carpeta), hace backup y lo reemplaza por symlink
# ==========================================

set -e

# Ruta absoluta del repo (directorio del script)
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Crear destinos sólo si no existen
[ -d "$HOME/.config" ] || { echo "📁 Creando ~/.config ..."; mkdir -p "$HOME/.config"; }
[ -d "$HOME/scripts" ] || { echo "📁 Creando ~/scripts ..."; mkdir -p "$HOME/scripts"; }

# Carpeta raíz de backups con timestamp
BACKUP_ROOT="$HOME/.dotfiles_backup/$(date +%Y%m%d-%H%M%S)"

# ---- helper: link seguro con backup si hace falta ----
safe_link() {
  local src="$1"
  local dest="$2"

  # Asegurá carpeta padre del destino
  mkdir -p "$(dirname "$dest")"

  if [ -L "$dest" ]; then
    # Si ya es symlink, lo reemplazamos
    rm -f "$dest"
  elif [ -e "$dest" ]; then
    # Si existe (archivo o carpeta real), movemos a backup y luego lo reemplazamos
    local rel="${dest#$HOME/}"  # path relativo al $HOME
    local backup_path="$BACKUP_ROOT/$rel"
    echo "🗂️  Backup de destino existente → $backup_path"
    mkdir -p "$(dirname "$backup_path")"
    mv "$dest" "$backup_path"
  fi

  ln -s "$src" "$dest"
  echo "🔗 $dest → $src"
}

# ~/.config
shopt -s nullglob
for dir in "$DOTFILES_DIR"/config/*; do
  [ -d "$dir" ] || continue
  name="$(basename "$dir")"
  safe_link "$dir" "$HOME/.config/$name"
done

# ~/scripts
if [ -d "$DOTFILES_DIR/scripts" ]; then
  safe_link "$DOTFILES_DIR/scripts" "$HOME/scripts"
fi

# ~ (home)
shopt -s dotglob nullglob
if [ -d "$DOTFILES_DIR/home" ]; then
  for item in "$DOTFILES_DIR"/home/*; do
    name="$(basename "$item")"
    [[ "$name" == "." || "$name" == ".." ]] && continue
    safe_link "$item" "$HOME/$name"
  done
fi

echo "✅ Listo. Symlinks creados (con backups cuando correspondía)."
echo "📦 Backups (si hubo) en: $BACKUP_ROOT"
