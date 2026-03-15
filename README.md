# Dotfiles

Arch Linux dotfiles for an i3-based desktop environment.

## System Stack

| Layer | Tool |
|-------|------|
| Window Manager | i3 + i3status-rust |
| Shell | zsh + Starship + Antigen |
| Terminal | urxvt, kitty |
| Editor | Vim |
| Launcher | Rofi |
| File Manager | Ranger, Yazi |
| Audio | PipeWire + EasyEffects + Jack |
| Compositor | — (i3 is a tiling WM, no compositor by default) |

---

## Repo Layout

```
dotfile/
├── home/               # Deployed to ~/
│   ├── .zshrc
│   ├── .bash_profile
│   ├── .vimrc
│   ├── .tmux.conf
│   ├── .xinitrc        # Multi-monitor setup + launches i3
│   ├── .xprofile       # X env vars (sourced by display manager)
│   └── .Xresources     # urxvt colors/font/transparency
│
├── .config/            # Deployed to ~/.config/
│   ├── i3/             # Modular i3 config (config.d/)
│   ├── i3status-rust/  # Status bar
│   ├── i3-resurrect/   # Session save/restore
│   ├── starship.toml   # Prompt config
│   ├── kitty/          # Kitty terminal
│   ├── rofi/           # App launcher (glue_pro_blue theme)
│   ├── ranger/         # File manager
│   ├── yazi/           # File manager (with flavors for themes)
│   ├── newsboat/       # RSS reader
│   ├── mpv/            # Media player (Vulkan/hwdec)
│   ├── easyeffects/    # Audio DSP
│   ├── patchbay/       # Jack/PipeWire routing
│   ├── keyboard/       # Via JSON layouts (DZ60RGB, Mode75H)
│   ├── git/            # Git global ignore
│   ├── systemd/        # systemd user services
│   └── htop/           # Htop config
│
├── background/
│   └── background/     # Wallpapers → deployed to /media/background/
│
├── scripts/
│   ├── install.sh          # Full fresh install (see below)
│   ├── pkglist.txt         # 112 explicit pacman packages
│   └── pkglist-aur.txt     # 8 AUR packages
│
├── antigen.zsh         # Zsh plugin manager binary
├── cp.sh               # Sync home → repo (run before committing)
└── CLAUDE.md           # Context file for Claude Code
```

---

## Scripts

### `scripts/install.sh` — Fresh Machine Setup

Run this once on a fresh Arch Linux install. **Do not run as root.**

```bash
bash scripts/install.sh
```

**What it does, in order:**

1. **System update** — `pacman -Syu`
2. **base-devel + git** — needed to build AUR packages
3. **Install yay** — AUR helper (cloned from AUR, built with makepkg)
4. **Install pacman packages** — reads `scripts/pkglist.txt`, skips any AUR packages automatically
5. **Install AUR packages** — reads `scripts/pkglist-aur.txt`, installs each with `yay`
6. **Deploy dotfiles:**
   - Copies `home/.*` → `~/` (backs up existing files as `.bak`)
   - Copies `.config/*` → `~/.config/` (backs up existing as `.bak`)
   - Copies `antigen.zsh` → `~/`
   - Copies wallpapers → `/media/background/`
7. **Git identity** — prompts for name/email if not already set
8. **Default shell** — sets zsh via `chsh`
9. **systemd user services** — enables `pipewire` and `pipewire-pulse`

**After install, do these manually:**

```bash
# Yazi themes
git clone https://github.com/yazi-rs/flavors ~/.config/yazi/flavors

# Node.js via nvm
nvm install --lts

# Tmux plugins
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
# then: open tmux → prefix + I

# Rust toolchain
rustup default stable

# Log out or reboot for shell/session changes
```

---

### `cp.sh` — Sync Dotfiles into Repo

Run this **before committing** to pull your live config into the repo.

```bash
bash cp.sh
```

**What it syncs:**

| Source | Destination in repo |
|--------|-------------------|
| `~/.config/i3/` | `.config/i3/` |
| `~/.config/i3status-rust/` | `.config/i3status-rust/` |
| `~/.config/i3-resurrect/` | `.config/i3-resurrect/` |
| `~/.config/rofi/` | `.config/rofi/` |
| `~/.config/newsboat/` (excl. cache.db) | `.config/newsboat/` |
| `~/.config/ranger/` | `.config/ranger/` |
| `~/.config/keyboard/` | `.config/keyboard/` |
| `~/.config/easyeffects/` | `.config/easyeffects/` |
| `~/.config/jack_mixer/` | `.config/jack_mixer/` |
| `~/.config/patchbay/` | `.config/patchbay/` |
| `~/.config/mpv/` | `.config/mpv/` |
| `~/.config/kitty/` | `.config/kitty/` |
| `~/.config/yazi/` | `.config/yazi/` |
| `~/.config/htop/` | `.config/htop/` |
| `~/.config/autostart/` | `.config/autostart/` |
| `~/.config/systemd/` | `.config/systemd/` |
| `~/.config/starship.toml` | `.config/starship.toml` |
| `~/.config/git/ignore` | `.config/git/ignore` |
| `~/.zshrc`, `~/.gitconfig`, `~/.xprofile`, `~/.bash_profile` | `home/` |
| `~/antigen.zsh` | `antigen.zsh` |

> **Note:** `.vimrc`, `.tmux.conf`, `.xinitrc`, and `.Xresources` are **not** synced by `cp.sh` — edit them directly in `home/` in the repo.

After syncing, review changes and commit:

```bash
git diff --stat
git add -p
git commit -m "chore: update dotfiles"
```

---

## Managing Packages

The package lists are the source of truth for what gets installed.

```bash
# Export currently installed explicit packages
pacman -Qqe > scripts/pkglist.txt

# Export AUR packages only
pacman -Qqem > scripts/pkglist-aur.txt
```

Then commit the updated lists so the next fresh install includes them.

---

## Key Config Notes

### i3 — `~/.config/i3/`
Config is split into `config.d/`:
- `bind.conf` — keybindings
- `startup.conf` — autostart apps
- `bar.conf` — i3status-rust bar setup
- `color.conf` — color scheme

Mod key is **Alt** (`Mod1`).

### Multi-Monitor — `~/.xinitrc`
Monitors set up as: `HDMI-0` (primary), `DVI-D-0` (right), `DP-0` (left).

### Zsh — `~/.zshrc`
- Plugin manager: Antigen (binary in repo root)
- Prompt: Starship
- Plugin list: `~/.config/antigenrc`

### Tmux — `~/.tmux.conf`
- Prefix: `Ctrl-a`
- Vim keys for pane navigation
- TPM for plugins + session restore via resurrect

### urxvt — `~/.Xresources`
Catppuccin-inspired color scheme with transparency. Apply changes with:
```bash
xrdb ~/.Xresources
```
