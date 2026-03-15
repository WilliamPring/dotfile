#!/bin/bash
# Deploy dotfiles from this repo to ~ and ~/.config/.
# The inverse of cp.sh — use this on a fresh machine after cloning.
#
# Usage: ./deploy.sh [--dry-run|-n]
#   --dry-run / -n   Print what would be copied without making changes.
#
# Note: existing files at the destination are overwritten without prompt.
# Run with --dry-run first to review what will change.

set -euo pipefail

DRY_RUN=false
for arg in "$@"; do
  case "$arg" in
    --dry-run|-n) DRY_RUN=true ;;
    *) echo "Unknown argument: $arg" >&2; exit 1 ;;
  esac
done

REPO="$(cd "$(dirname "$0")" && pwd)"
CONF="$REPO/.config"
HOME_DIR="$REPO/home"

# --- Helpers (dry-run aware) ---
do_cp() {
  local src="$1" dest="$2"
  if $DRY_RUN; then
    echo "    [dry] cp $src → $dest"
  else
    cp "$src" "$dest"
  fi
}

do_cp_r() {
  local src="$1" dest="$2"
  if $DRY_RUN; then
    echo "    [dry] cp -r $src/ → $dest/"
  else
    rm -rf "$dest"
    cp -r "$src" "$dest"
  fi
}

do_mkdir() {
  if $DRY_RUN; then
    echo "    [dry] mkdir -p $1"
  else
    mkdir -p "$1"
  fi
}

# --- Must stay in sync with cp.sh ---
CONFIG_DIRS=(
  i3
  i3status-rust
  i3-resurrect
  rofi
  newsboat
  ranger
  keyboard
  easyeffects
  jack_mixer
  patchbay
  mpv
  kitty
  yazi
  htop
  autostart
  systemd
)

CONFIG_FILES=(
  starship.toml
  antigenrc
  audio-mapper.carxp
  will-linux.qpwgraph
  pavucontrol.ini
)

HOME_FILES=(
  .zshrc
  .vimrc
  .tmux.conf
  .xinitrc
  .xprofile
  .Xresources
  .bash_profile
  .gitconfig
)

$DRY_RUN && echo "=== DRY RUN — no files will be changed ==="
echo "Deploying dotfiles from $REPO → ~"
echo ""

# Deploy .config directories
echo "[.config dirs]"
do_mkdir "$HOME/.config"
for dir in "${CONFIG_DIRS[@]}"; do
  src="$CONF/$dir"
  dest="$HOME/.config/$dir"
  if [ -d "$src" ]; then
    do_cp_r "$src" "$dest"
    echo "  $dir"
  fi
done

# Deploy .config single files
echo ""
echo "[.config files]"
for f in "${CONFIG_FILES[@]}"; do
  src="$CONF/$f"
  if [ -f "$src" ]; then
    do_cp "$src" "$HOME/.config/$f"
    echo "  $f"
  fi
done

# git global ignore
if [ -f "$CONF/git/ignore" ]; then
  do_mkdir "$HOME/.config/git"
  do_cp "$CONF/git/ignore" "$HOME/.config/git/ignore"
  echo "  git/ignore"
fi

# antigen.zsh
if [ -f "$REPO/antigen.zsh" ]; then
  do_cp "$REPO/antigen.zsh" "$HOME/antigen.zsh"
  echo "  (root) antigen.zsh"
fi

# Deploy home dotfiles
echo ""
echo "[home files]"
for f in "${HOME_FILES[@]}"; do
  src="$HOME_DIR/$f"
  if [ -f "$src" ]; then
    do_cp "$src" "$HOME/$f"
    echo "  $f"
  fi
done

echo ""
if $DRY_RUN; then
  echo "Dry run complete. No files were changed."
else
  echo "Done. You may need to reload your shell: source ~/.zshrc"
fi
