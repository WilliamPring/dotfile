#!/bin/bash
# Fresh Arch Linux workspace install script.
# Run as a regular user with sudo access (not as root).
set -euo pipefail

REPO="$(cd "$(dirname "$0")/.." && pwd)"

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; NC='\033[0m'
info()    { echo -e "${GREEN}[+]${NC} $*"; }
warn()    { echo -e "${YELLOW}[!]${NC} $*"; }
error()   { echo -e "${RED}[✗]${NC} $*"; exit 1; }

# ── Preflight ──────────────────────────────────────────────────────────────────
[ "$(id -u)" -eq 0 ] && error "Run as a regular user, not root."
[ -f /etc/arch-release ] || error "This script is for Arch Linux."
command -v pacman &>/dev/null || error "pacman not found."

info "Starting workspace install from: $REPO"
echo ""

# ── 1. System update ───────────────────────────────────────────────────────────
info "Updating system packages..."
sudo pacman -Syu --noconfirm

# ── 2. Base build tools ────────────────────────────────────────────────────────
info "Installing base-devel and git..."
sudo pacman -S --needed --noconfirm base-devel git

# ── 3. Install yay (AUR helper) ────────────────────────────────────────────────
if ! command -v yay &>/dev/null; then
  info "Installing yay..."
  tmpdir=$(mktemp -d)
  git clone https://aur.archlinux.org/yay-bin.git "$tmpdir/yay-bin"
  (cd "$tmpdir/yay-bin" && makepkg -si --noconfirm)
  rm -rf "$tmpdir"
else
  info "yay already installed, skipping."
fi

# ── 4. Install pacman packages ─────────────────────────────────────────────────
PKGLIST="$REPO/scripts/pkglist.txt"
AURLIST="$REPO/scripts/pkglist-aur.txt"

if [ -f "$PKGLIST" ]; then
  info "Installing pacman packages from pkglist.txt..."
  # Filter out AUR packages so pacman doesn't choke on them
  aur_pkgs=()
  [ -f "$AURLIST" ] && mapfile -t aur_pkgs < "$AURLIST"
  # Build a grep pattern to exclude AUR packages
  aur_pattern=$(printf '%s\n' "${aur_pkgs[@]}" | paste -sd '|')
  if [ -n "$aur_pattern" ]; then
    grep -vE "^($aur_pattern)$" "$PKGLIST" | sudo pacman -S --needed --noconfirm -
  else
    sudo pacman -S --needed --noconfirm - < "$PKGLIST"
  fi
else
  warn "pkglist.txt not found, skipping pacman packages."
fi

# ── 5. Install AUR packages ────────────────────────────────────────────────────
if [ -f "$AURLIST" ]; then
  info "Installing AUR packages from pkglist-aur.txt..."
  # Skip debug/dev variants that aren't needed on a fresh install
  SKIP_AUR=(yay-bin-debug)
  while IFS= read -r pkg; do
    skip=false
    for s in "${SKIP_AUR[@]}"; do [[ "$pkg" == "$s" ]] && skip=true; done
    if ! $skip; then
      yay -S --needed --noconfirm "$pkg" || warn "AUR package '$pkg' failed, skipping."
    fi
  done < "$AURLIST"
else
  warn "pkglist-aur.txt not found, skipping AUR packages."
fi

# ── 6. Install dotfiles ────────────────────────────────────────────────────────
info "Installing dotfiles..."

# Home dotfiles
for f in "$REPO"/home/.*; do
  fname="$(basename "$f")"
  [[ "$fname" == "." || "$fname" == ".." ]] && continue
  if [ -e "$HOME/$fname" ] && [ ! -L "$HOME/$fname" ]; then
    warn "Backing up existing ~/$fname → ~/$fname.bak"
    mv "$HOME/$fname" "$HOME/$fname.bak"
  fi
  cp "$f" "$HOME/$fname"
  info "  ~/$fname"
done

# .config directories and files
mkdir -p "$HOME/.config"
for item in "$REPO"/.config/*; do
  iname="$(basename "$item")"
  dest="$HOME/.config/$iname"
  if [ -e "$dest" ] && [ ! -L "$dest" ]; then
    warn "Backing up existing ~/.config/$iname → ~/.config/$iname.bak"
    mv "$dest" "$dest.bak"
  fi
  cp -r "$item" "$dest"
  info "  ~/.config/$iname"
done

# antigen.zsh
if [ -f "$REPO/antigen.zsh" ]; then
  cp "$REPO/antigen.zsh" "$HOME/antigen.zsh"
  info "  ~/antigen.zsh"
fi

# Wallpapers
if [ -d "$REPO/background/background" ]; then
  sudo mkdir -p /media/background
  sudo cp "$REPO"/background/background/* /media/background/
  info "  /media/background/ (wallpapers)"
fi

# ── 7. Git identity ────────────────────────────────────────────────────────────
# .gitconfig is excluded from the repo (contains personal name/email)
if [ -z "$(git config --global user.name 2>/dev/null)" ]; then
  info "Setting up git identity..."
  read -rp "  Git name:  " git_name
  read -rp "  Git email: " git_email
  git config --global user.name "$git_name"
  git config --global user.email "$git_email"
  info "  Git identity set."
else
  info "Git identity already configured, skipping."
fi

# ── 9. Set zsh as default shell ────────────────────────────────────────────────
if [ "$SHELL" != "$(command -v zsh)" ]; then
  info "Setting zsh as default shell..."
  chsh -s "$(command -v zsh)"
fi

# ── 10. Enable systemd user services ──────────────────────────────────────────
info "Enabling systemd user services..."
systemctl --user enable --now pipewire pipewire-pulse 2>/dev/null || warn "pipewire services may need a relogin."

# ── 9. Post-install steps ──────────────────────────────────────────────────────
echo ""
info "Install complete. Manual steps remaining:"
echo "   1. Yazi flavors (themes):"
echo "        git clone https://github.com/yazi-rs/flavors ~/.config/yazi/flavors"
echo "   2. NVM - install Node.js:"
echo "        nvm install --lts"
echo "   3. Tmux plugin manager:"
echo "        git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm"
echo "        # then open tmux and press prefix + I to install plugins"
echo "   4. Rustup (if needed):"
echo "        rustup default stable"
echo "   5. Starship (if not installed via pacman):"
echo "        curl -sS https://starship.rs/install.sh | sh"
echo "   6. Log out and back in (or reboot) for shell/session changes to take effect."
echo ""
info "All done!"
