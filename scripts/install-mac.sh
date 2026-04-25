#!/bin/bash
# macOS terminal/work environment install script.
# Installs Homebrew packages and deploys terminal-compatible dotfiles only.
# Does NOT install i3, PipeWire, rofi, systemd, or any Linux-specific config.
set -euo pipefail

REPO="$(cd "$(dirname "$0")/.." && pwd)"

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; NC='\033[0m'
info()  { echo -e "${GREEN}[+]${NC} $*"; }
warn()  { echo -e "${YELLOW}[!]${NC} $*"; }
error() { echo -e "${RED}[✗]${NC} $*"; exit 1; }

# ── Preflight ──────────────────────────────────────────────────────────────────
[[ "$(uname)" == "Darwin" ]] || error "This script is for macOS only."
[ "$(id -u)" -eq 0 ] && error "Run as a regular user, not root."

info "Starting macOS terminal install from: $REPO"
echo ""

# ── 1. Homebrew ────────────────────────────────────────────────────────────────
if ! command -v brew &>/dev/null; then
  info "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  # Add brew to PATH for the rest of this script (Apple Silicon path)
  if [[ -f /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi
else
  info "Homebrew already installed, updating..."
  brew update
fi

# ── 2. CLI tools ───────────────────────────────────────────────────────────────
info "Installing CLI packages..."
brew install \
  fd \
  fastfetch \
  fzf \
  git \
  htop \
  imagemagick \
  jq \
  newsboat \
  poppler \
  ranger \
  resvg \
  starship \
  tmux \
  vim \
  wget \
  yazi \
  zoxide

# ── 3. NVM ────────────────────────────────────────────────────────────────────
if ! command -v nvm &>/dev/null; then
  info "Installing nvm via Homebrew..."
  brew install nvm
  mkdir -p "$HOME/.nvm"
fi

# ── 4. Rust via rustup ────────────────────────────────────────────────────────
if ! command -v rustup &>/dev/null; then
  info "Installing rustup..."
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
fi

# ── 5. GUI apps (casks) ───────────────────────────────────────────────────────
info "Installing cask apps..."
brew install --cask kitty

# ── 6. Deploy terminal-compatible dotfiles ────────────────────────────────────
info "Deploying home dotfiles..."

# Home files — only the terminal-relevant ones
HOME_FILES=(.zshrc .vimrc .tmux.conf)
for fname in "${HOME_FILES[@]}"; do
  src="$REPO/home/$fname"
  dest="$HOME/$fname"
  [ -f "$src" ] || { warn "  $src not found, skipping."; continue; }
  if [ -e "$dest" ] && [ ! -L "$dest" ]; then
    warn "  Backing up ~/$fname → ~/$fname.bak"
    mv "$dest" "$dest.bak"
  fi
  cp "$src" "$dest"
  info "  ~/$fname"
done

info "Deploying .config entries..."

# .config dirs/files — skip Linux-only entries
SKIP_CONFIG=(i3 i3status-rust i3-resurrect rofi easyeffects patchbay jack_mixer systemd autostart mpv)

mkdir -p "$HOME/.config"
for item in "$REPO"/.config/*; do
  iname="$(basename "$item")"
  skip=false
  for s in "${SKIP_CONFIG[@]}"; do [[ "$iname" == "$s" ]] && skip=true; done
  if $skip; then
    info "  ~/.config/$iname (skipped — Linux only)"
    continue
  fi
  dest="$HOME/.config/$iname"
  if [ -e "$dest" ] && [ ! -L "$dest" ]; then
    warn "  Backing up ~/.config/$iname → ~/.config/$iname.bak"
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

# ── 7. Git identity ────────────────────────────────────────────────────────────
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

# ── 8. Set zsh as default shell ────────────────────────────────────────────────
if [ "$SHELL" != "$(command -v zsh)" ]; then
  info "Setting zsh as default shell..."
  chsh -s "$(command -v zsh)"
fi

# ── 9. Post-install steps ──────────────────────────────────────────────────────
echo ""
info "Install complete. Manual steps remaining:"
echo "   1. Reload shell for Homebrew PATH (Apple Silicon):"
echo "        echo 'eval \"\$(/opt/homebrew/bin/brew shellenv)\"' >> ~/.zprofile"
echo "        source ~/.zprofile"
echo "   2. NVM — add to ~/.zshrc if not already present:"
echo "        export NVM_DIR=\"\$HOME/.nvm\""
echo "        [ -s \"\$(brew --prefix nvm)/nvm.sh\" ] && source \"\$(brew --prefix nvm)/nvm.sh\""
echo "        nvm install --lts"
echo "   3. Tmux plugin manager:"
echo "        git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm"
echo "        # open tmux and press prefix + I (Ctrl-a then I) to install plugins"
echo "   4. Rustup default toolchain:"
echo "        rustup default stable"
echo "   5. Yazi flavors (themes):"
echo "        git clone https://github.com/yazi-rs/flavors ~/.config/yazi/flavors"
echo "   6. tmux clipboard: .tmux.conf uses xclip (Linux). On Mac, tmux-yank"
echo "        (installed via TPM) handles clipboard automatically — no action needed."
echo ""
info "All done!"
