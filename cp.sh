#!/bin/bash
# Sync dotfiles from ~ and ~/.config into this repo.
# Run this before committing to keep the repo up to date.
#
# Usage: ./cp.sh [--dry-run|-n]
#   --dry-run / -n   Print what would be copied without making changes.

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
  $DRY_RUN || mkdir -p "$1"
}

do_rm() {
  if $DRY_RUN; then
    echo "    [dry] rm $1"
  else
    rm -f "$1"
  fi
}

# --- ~/.config directories to sync ---
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

# --- Files to remove after syncing (never version these) ---
EXCLUDE=(
  newsboat/cache.db
)

# --- ~/.config single files ---
CONFIG_FILES=(
  starship.toml
  antigenrc
  audio-mapper.carxp
  will-linux.qpwgraph
  pavucontrol.ini
)

# --- ~/ dotfiles (non-sensitive) ---
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
echo "Syncing dotfiles → $REPO"
echo ""

# Sync .config directories
# (dest removed first to avoid cp -r nesting bug on repeated runs)
echo "[.config dirs]"
for dir in "${CONFIG_DIRS[@]}"; do
  src="$HOME/.config/$dir"
  dest="$CONF/$dir"
  if [ -d "$src" ]; then
    do_cp_r "$src" "$dest"
    echo "  $dir"
  fi
done

# Remove excluded files
for f in "${EXCLUDE[@]}"; do
  do_rm "$CONF/$f"
done

# Sync .config single files
echo ""
echo "[.config files]"
for f in "${CONFIG_FILES[@]}"; do
  src="$HOME/.config/$f"
  if [ -f "$src" ]; then
    do_cp "$src" "$CONF/$f"
    echo "  $f"
  fi
done

# git global ignore (lives in .config/git/, handled separately)
if [ -f "$HOME/.config/git/ignore" ]; then
  do_mkdir "$CONF/git"
  do_cp "$HOME/.config/git/ignore" "$CONF/git/ignore"
  echo "  git/ignore"
fi

# antigen.zsh (zsh plugin manager binary)
if [ -f "$HOME/antigen.zsh" ]; then
  do_cp "$HOME/antigen.zsh" "$REPO/antigen.zsh"
  echo "  (root) antigen.zsh"
fi

# Sync home dotfiles
echo ""
echo "[home files]"
do_mkdir "$HOME_DIR"
for f in "${HOME_FILES[@]}"; do
  src="$HOME/$f"
  if [ -f "$src" ]; then
    do_cp "$src" "$HOME_DIR/$f"
    echo "  $f"
  fi
done

# Warn about ~/.config dirs that exist on disk but aren't tracked in CONFIG_DIRS
echo ""
echo "[untracked ~/.config dirs]"
found_untracked=false
while IFS= read -r -d '' dir; do
  name="$(basename "$dir")"
  tracked=false
  for t in "${CONFIG_DIRS[@]}"; do
    [ "$t" = "$name" ] && tracked=true && break
  done
  if ! $tracked; then
    echo "  WARNING: ~/.config/$name is not tracked — add it to CONFIG_DIRS if needed"
    found_untracked=true
  fi
done < <(find "$HOME/.config" -mindepth 1 -maxdepth 1 -type d -print0 | sort -z)
$found_untracked || echo "  (none)"

echo ""
if $DRY_RUN; then
  echo "Dry run complete. No files were changed."
else
  echo "Done."
  echo ""
  git -C "$REPO" diff --stat
fi
