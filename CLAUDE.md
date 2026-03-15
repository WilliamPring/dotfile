# Dotfiles Repo

Arch Linux dotfiles for an i3-based desktop.

## Layout

```
home/               → deploys to ~/  (.zshrc, .vimrc, .tmux.conf, .xinitrc, .xprofile, .Xresources, .bash_profile, .gitconfig)
.config/            → deploys to ~/.config/
background/         → wallpapers deployed to /media/background/
antigen.zsh         → zsh plugin manager binary
cp.sh               → capture: syncs ~ and ~/.config into this repo (run before committing)
deploy.sh           → restore: deploys repo files back to ~ and ~/.config (use on fresh machine)
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

## Scripts

### `cp.sh` — capture dotfiles into repo

Copies live dotfiles from `~` and `~/.config/` into the repo. Run before committing.

```bash
./cp.sh              # sync everything
./cp.sh --dry-run    # preview changes without touching any files
./cp.sh -n           # shorthand for --dry-run
```

- Syncs all entries in `CONFIG_DIRS`, `CONFIG_FILES`, and `HOME_FILES`
- Removes excluded files (e.g. `newsboat/cache.db`) after syncing
- Warns about any `~/.config/` directories that exist on disk but aren't tracked in `CONFIG_DIRS`
- Runs `git diff --stat` automatically when done

To add a new config directory: add its name to `CONFIG_DIRS` in `cp.sh` **and** `deploy.sh`.

### `deploy.sh` — restore dotfiles from repo

The inverse of `cp.sh`. Copies files from the repo back to `~` and `~/.config/`. Use on a fresh machine after cloning.

```bash
./deploy.sh              # deploy everything (overwrites existing files)
./deploy.sh --dry-run    # preview what would be written
./deploy.sh -n           # shorthand for --dry-run
```

> Existing files at the destination are overwritten without prompting. Always run `--dry-run` first on a machine with existing config.

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

### Updating dotfiles

1. Edit dotfiles in `~/.config/` or `~/`
2. Run `./cp.sh --dry-run` to preview changes
3. Run `./cp.sh` to sync into repo
4. Commit and push

### Fresh machine setup

1. Run `scripts/install.sh` (installs pacman + AUR packages)
2. Clone this repo
3. Run `./deploy.sh --dry-run` to review
4. Run `./deploy.sh` to deploy all dotfiles
5. `source ~/.zshrc` to reload shell
