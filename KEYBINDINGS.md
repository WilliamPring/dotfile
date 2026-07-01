# Keybindings Reference

**Legend:** `Mod` = Alt | `Super` = Windows key | `Prefix` = Ctrl-a (tmux)

---

## i3 (Window Manager)

### Focus & Movement
| Key | Action |
|-----|--------|
| `Mod+h/j/k/l` | Focus left/down/up/right |
| `Mod+Arrow` | Focus (arrow keys) |
| `Mod+Shift+h/j/k/l` | Move window left/down/up/right |
| `Mod+Shift+Arrow` | Move window (arrow keys) |

### Workspaces
| Key | Action |
|-----|--------|
| `Mod+1–0` | Switch to workspace 1–10 |
| `Mod+Shift+1–0` | Move window to workspace 1–10 |
| `Super+Mod+j` | Next workspace |
| `Super+Mod+;` | Previous workspace |

### Layout
| Key | Action |
|-----|--------|
| `Mod+\` or `Mod+\|` | Split horizontal |
| `Mod+-` | Split vertical |
| `Mod+s` | Stacking layout |
| `Mod+w` | Tabbed layout |
| `Mod+e` | Toggle split |
| `Mod+x` | Toggle all layouts |
| `Mod+Shift+Space` | Toggle floating |
| `Mod+a` | Focus parent container |
| `Mod+r` | Enter resize mode |

### Resize Mode (after `Mod+r`)
| Key | Action |
|-----|--------|
| `h/l` | Shrink/grow width |
| `j/k` | Grow/shrink height |
| `Arrow keys` | Same as above |
| `Enter` / `Escape` / `Mod+r` | Exit resize mode |

### Apps & System
| Key | Action |
|-----|--------|
| `Mod+d` | Rofi app launcher |
| `Mod+Shift+d` | dmenu |
| `Mod+g` | Rofi window switcher |
| `Mod+Shift+q` / `Alt+F4` | Kill window |
| `Mod+m` | Toggle mute |
| `Mod+Shift+p` | Screenshot (gnome-screenshot) |
| `Mod+b` | Bitwarden → workspace 3 |
| `Super+Mod+f` | Firefox |
| `Super+Mod+m` | PCManFM → workspace 3 |
| `Mod+;` | Scratchpad show |
| `Mod+Ctrl+Shift+;` | Move to scratchpad |
| `Mod+Ctrl+Shift+l` | Lock screen (i3lock) |
| `Mod+BackSpace` | Dismiss notification (dunst) |
| `Mod+Shift+BackSpace` | Recall last notification |
| `Mod+Shift+b` | Toggle i3 bar |
| `Mod+Shift+c` | Reload i3 config |
| `Mod+Shift+r` | Restart i3 |
| `Mod+Shift+e` | Exit i3 |

---

## tmux

**Prefix:** `Ctrl-a`

### Panes
| Key | Action |
|-----|--------|
| `Prefix+\|` | Split horizontal |
| `Prefix+-` | Split vertical |
| `Prefix+h/j/k/l` | Move between panes |
| `Prefix+H/J/K/L` | Resize pane (repeatable) |
| `Prefix+S` | Sync panes toggle |

### Windows
| Key | Action |
|-----|--------|
| `Prefix+Ctrl-h` | Previous window |
| `Prefix+Ctrl-l` | Next window |

### Copy Mode (vi)
| Key | Action |
|-----|--------|
| `Prefix+[` | Enter copy mode |
| `v` | Begin selection |
| `y` | Rectangle toggle |
| `Enter` | Copy selection to clipboard (xclip) |
| `Prefix+P` | Paste buffer |

---

## Vim

### Custom Mappings
| Key | Action |
|-----|--------|
| `Y` | Yank to end of line (like `D`/`C`) |
| `Ctrl-L` | Clear search highlight + redraw |
| `F11` | Toggle paste mode |

### Standard Vim (not mapped, but useful)
| Key | Action |
|-----|--------|
| `h/j/k/l` | Move left/down/up/right |
| `/` | Search forward |
| `n/N` | Next/previous match |
| `dd` | Delete line |
| `yy` | Yank line |
| `p` / `P` | Paste after/before |
| `u` | Undo |
| `Ctrl-r` | Redo |
| `gg` / `G` | Top / bottom of file |
| `:w` / `:q` / `:wq` | Save / quit / save+quit |

---

## Zsh (Shell)

### Custom Bindings
| Key | Action |
|-----|--------|
| `Ctrl-P` | Accept autosuggestion |

### Useful Aliases
| Alias | Command |
|-------|---------|
| `ll` | `ls -lath --color` |
| `fm` | `yazi` (file manager) |
| `ta` | `tmux attach -t` |
| `tn` | `tmux new -s` |
| `tl` | `tmux list-sessions` |
| `nb` | `newsboat` |
| `cbg` | Random wallpaper |
| `reload-shell` | `source ~/.zshrc` |
| `:q` | `exit` |
| `xl` | `xrdb -load ~/.Xresources` |

---

## Kitty (Terminal)

**kitty_mod** = `Ctrl+Shift`

### Clipboard
| Key | Action |
|-----|--------|
| `kitty_mod+c` | Copy to clipboard |
| `kitty_mod+v` | Paste from clipboard |
| `kitty_mod+s` / `Shift+Insert` | Paste from selection |

### Scrollback
| Key | Action |
|-----|--------|
| `kitty_mod+Up/k` | Scroll line up |
| `kitty_mod+Down/j` | Scroll line down |
| `kitty_mod+PageUp` | Scroll page up |
| `kitty_mod+PageDown` | Scroll page down |
| `kitty_mod+Home` | Scroll to top |
| `kitty_mod+End` | Scroll to bottom |
| `kitty_mod+h` | Browse scrollback in pager |
| `kitty_mod+/` | Search scrollback |

### Windows
| Key | Action |
|-----|--------|
| `kitty_mod+Enter` | New window |
| `kitty_mod+w` | Close window |
| `kitty_mod+]` / `[` | Next/previous window |
| `kitty_mod+r` | Resize window |
| `kitty_mod+1–9` | Focus window by number |

### Tabs
| Key | Action |
|-----|--------|
| `kitty_mod+Right` / `Ctrl+Tab` | Next tab |
| `kitty_mod+Left` / `Ctrl+Shift+Tab` | Previous tab |
| `kitty_mod+t` | New tab |
| `kitty_mod+q` | Close tab |
| `kitty_mod+.` / `,` | Move tab forward/backward |
| `kitty_mod+Alt+t` | Set tab title |

### Font Size
| Key | Action |
|-----|--------|
| `kitty_mod+=` / `+` | Increase font size |
| `kitty_mod+-` | Decrease font size |
| `kitty_mod+Backspace` | Reset font size |

### Misc
| Key | Action |
|-----|--------|
| `kitty_mod+F11` | Toggle fullscreen |
| `kitty_mod+F5` | Reload kitty.conf |
| `kitty_mod+u` | Unicode input |
| `kitty_mod+e` | Open URL with hints |
| `kitty_mod+F1` | Show kitty docs |
| `kitty_mod+F3` | Command palette |

---

## Yazi (File Manager)

Yazi uses default bindings (no custom keymap configured). Key defaults:

| Key | Action |
|-----|--------|
| `h/j/k/l` | Navigate |
| `Enter` | Open file/dir |
| `y` | Yank (copy) |
| `x` | Cut |
| `p` | Paste |
| `d` | Trash |
| `D` | Delete permanently |
| `r` | Rename |
| `a` | Create file/dir |
| `/` | Filter |
| `f` | Find |
| `s` | Search |
| `z` | Jump (zoxide) |
| `.` | Toggle hidden files |
| `q` | Quit |
