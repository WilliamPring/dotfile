# Dotfiles Repo

Arch Linux dotfiles for an i3-based desktop.

## Layout

```
home/               → deploys to ~/  (.zshrc, .vimrc, .tmux.conf, .xinitrc, .xprofile, .Xresources, .bash_profile)
.config/            → deploys to ~/.config/
background/         → wallpapers deployed to /media/background/
antigen.zsh         → zsh plugin manager binary
cp.sh               → syncs home → repo (run before committing)
scripts/install.sh  → full fresh Arch install (pacman + AUR)
scripts/pkglist.txt       → 112 explicit pacman packages
scripts/pkglist-aur.txt   → 8 AUR packages
```

## Key Config Files

| File | Purpose |
|------|---------|
| `home/.zshrc` | Zsh (Starship prompt, Antigen plugins, aliases) |
| `home/.vimrc` | Vim (4-space indent, mouse, line numbers) |
| `home/.tmux.conf` | Tmux (prefix=Ctrl-a, vim keys, TPM, session restore) |
| `home/.xinitrc` | Multi-monitor setup, launches i3 |
| `home/.xprofile` | X env vars, executed by display manager |
| `home/.Xresources` | urxvt config (Catppuccin-ish colors, transparency) |
| `.config/i3/` | Modular i3 config via `config.d/` (bind, startup, bar, color) |
| `.config/i3status-rust/` | i3 status bar |
| `.config/starship.toml` | Starship prompt |
| `.config/kitty/` | Kitty terminal |
| `.config/mpv/` | mpv (Vulkan/hwdec) |
| `.config/rofi/` | App launcher (glue_pro_blue theme) |
| `.config/ranger/` | Ranger file manager |
| `.config/yazi/` | Yazi file manager |
| `.config/newsboat/` | RSS reader |
| `.config/easyeffects/` | Audio effects (PipeWire) |
| `.config/patchbay/` | Jack/PipeWire patchbay |
| `.config/keyboard/` | DZ60RGB and Mode75H Via JSON layouts |
| `.config/git/` | Git config |
| `.config/systemd/` | systemd user services |
| `.config/i3-resurrect/` | i3 session restore |

## System Stack

- **WM**: i3 + i3status-rust
- **Shell**: zsh + Starship + Antigen
- **Terminal**: urxvt (rxvt-unicode), kitty
- **Editor**: Vim
- **Audio**: PipeWire + EasyEffects + Jack
- **Distro**: Arch Linux (pacman + yay for AUR)
- **Security**: Mullvad VPN, Bitwarden, KeePassXC
- **Virt**: libvirt/QEMU + virt-manager

## User Preferences

- Vim-style keybindings everywhere (i3, tmux, shell)
- i3 Mod key = Alt
- Multi-monitor: HDMI-0 primary, DVI-D-0 right, DP-0 left

## Workflow

1. Edit dotfiles in `~/.config/` or `~/`
2. Run `cp.sh` to sync changes into this repo
3. Commit and push
4. On a new machine: run `scripts/install.sh`, then manually copy files from repo

> There is no automated restore script — deployments are done manually.
