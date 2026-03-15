#!/bin/bash
# Sync dotfiles from ~ and ~/.config into this repo.
# Run this before committing to keep the repo up to date.
set -euo pipefail

REPO="$(cd "$(dirname "$0")" && pwd)"
CONF="$REPO/.config"
HOME_DIR="$REPO/home"

# --- ~/.config directories ---
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

# --- ~/.config single files ---
CONFIG_FILES=(
  starship.toml
  antigenrc
  audio-mapper.carxp
  will-linux.qpwgraph
  pavucontrol.ini
)

# --- ~/  files (non-sensitive) ---
HOME_FILES=(
  .zshrc
  .gitconfig
  .xprofile
  .bash_profile
)

echo "Syncing dotfiles → $REPO"

# Sync .config directories (remove dest first to avoid nesting bug with cp -r)
for dir in "${CONFIG_DIRS[@]}"; do
  src="$HOME/.config/$dir"
  dest="$CONF/$dir"
  if [ -d "$src" ]; then
    rm -rf "$dest"
    cp -r "$src" "$dest"
    echo "  [.config] $dir"
  fi
done

# Remove files that must not be versioned
rm -f "$CONF/newsboat/cache.db"

# Sync .config single files
for f in "${CONFIG_FILES[@]}"; do
  src="$HOME/.config/$f"
  if [ -f "$src" ]; then
    cp "$src" "$CONF/$f"
    echo "  [.config] $f"
  fi
done

# git global ignore (not the gitconfig itself - that's in home/)
if [ -f "$HOME/.config/git/ignore" ]; then
  mkdir -p "$CONF/git"
  cp "$HOME/.config/git/ignore" "$CONF/git/ignore"
  echo "  [.config] git/ignore"
fi

# antigen.zsh (zsh plugin manager)
if [ -f "$HOME/antigen.zsh" ]; then
  cp "$HOME/antigen.zsh" "$REPO/antigen.zsh"
  echo "  [root] antigen.zsh"
fi

# Sync home dotfiles
mkdir -p "$HOME_DIR"
for f in "${HOME_FILES[@]}"; do
  src="$HOME/$f"
  if [ -f "$src" ]; then
    cp "$src" "$HOME_DIR/$f"
    echo "  [home] $f"
  fi
done

echo ""
echo "Done. Review with: git -C \"$REPO\" diff --stat"
