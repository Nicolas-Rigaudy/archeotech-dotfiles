# Keybindings Reference

Complete reference for all keybindings in the Arch + Hyprland setup.

> **Note:** This configuration uses `resolve_binds_by_sym = true`, which means keybindings follow the key symbols rather than positions. For example, `Super + Q` will always be the Q key regardless of keyboard layout (AZERTY/QWERTY).

---

## Table of Contents

- [Application Launchers](#application-launchers)
- [Window Management](#window-management)
- [Workspace Navigation](#workspace-navigation)
- [Screenshots & Media](#screenshots--media)
- [System Controls](#system-controls)
- [Mouse Bindings](#mouse-bindings)

---

## Application Launchers

| Keybind | Action | Notes |
|---------|--------|-------|
| `Super + Q` | Open terminal (kitty) | Primary terminal |
| `Super + R` | Open app launcher (rofi) | Search all installed apps |
| `Super + B` | Open browser (zen-browser) | Firefox-based privacy browser |
| `Super + E` | Open editor (VSCode) | Code editor |
| `Super + N` | Open notes (Obsidian) | Markdown notes |
| `Super + D` | Open file manager (thunar) | GUI file browser |

---

## Window Management

| Keybind | Action | Notes |
|---------|--------|-------|
| `Super + C` | Close active window | Kill focused window |
| `Super + M` | Exit Hyprland | Logout menu |
| `Super + F` | Toggle fullscreen | Current window |
| `Super + Shift + Space` | Toggle floating | Tile ” Float |
| `Super + T` | Toggle split | Dwindle layout direction |

### Focus Movement

| Keybind | Action | Notes |
|---------|--------|-------|
| `Super + Arrow Keys` | Move focus | Between windows |

### Window Movement

| Keybind | Action | Notes |
|---------|--------|-------|
| `Super + Shift + Arrows` | Move window | In current workspace |

### Window Resizing

| Keybind | Action | Notes |
|---------|--------|-------|
| `Super + Ctrl + Arrows` | Resize window | ±20px increments |

---

## Workspace Navigation

| Keybind | Action | Notes |
|---------|--------|-------|
| `Super + [1-9]` | Switch to workspace N | Direct workspace switch |
| `Super + Shift + [1-9]` | Move window to workspace N | Send window to workspace |
| `Super + Tab` | Next workspace | Cycles through workspaces |
| `Super + Shift + Tab` | Previous workspace | Reverse cycle |
| `Super + Mouse Scroll` | Scroll through workspaces | While holding Super |

### Workspace Assignment

Workspaces are assigned per monitor in the following configuration:
- **Workspaces 1-3:** Laptop screen (eDP-1)
- **Workspaces 4-6:** External monitor 1 (HDMI-A-1)
- **Workspaces 7-9:** External monitor 2 (DP-3, portrait)

---

## Screenshots & Media

### Screenshots

| Keybind | Action | Notes |
|---------|--------|-------|
| `Super + S` | Screenshot region | Select area, save + clipboard |
| `Super + P` | Screenshot fullscreen | Save + clipboard |
| `Print` | Screenshot fullscreen | Alternative (laptop key) |
| `Super + Print` | Screenshot region | Alternative (laptop key) |

Screenshots are saved to `~/Pictures/Screenshots/` with timestamp format: `YYYYMMDD_HHMMSS.png`

### Clipboard

| Keybind | Action | Notes |
|---------|--------|-------|
| `Super + V` | Clipboard history | Rofi selector for clipboard manager |

---

## System Controls

### Screen & Session

| Keybind | Action | Notes |
|---------|--------|-------|
| `Super + L` | Lock screen | Hyprlock with configured wallpaper |
| `Super + K` | Show keybinds | Display this keybind reference |
| `Alt + Shift` | Toggle keyboard layout | US ” FR (QWERTY ” AZERTY) |

### Audio Controls

| Keybind | Action | Notes |
|---------|--------|-------|
| `XF86AudioRaiseVolume` | Volume up | +5% increment |
| `XF86AudioLowerVolume` | Volume down | -5% decrement |
| `XF86AudioMute` | Toggle mute | Audio output |
| `XF86AudioMicMute` | Toggle mic mute | Microphone input |

### Brightness

| Keybind | Action | Notes |
|---------|--------|-------|
| `XF86MonBrightnessUp` | Brightness up | +5% increment |
| `XF86MonBrightnessDown` | Brightness down | -5% decrement |

### Media Controls

| Keybind | Action | Notes |
|---------|--------|-------|
| `XF86AudioPlay` | Play/Pause | Media playback toggle |
| `XF86AudioNext` | Next track | Skip forward |
| `XF86AudioPrev` | Previous track | Skip backward |

---

## Mouse Bindings

| Keybind | Action | Notes |
|---------|--------|-------|
| `Super + Left Click + Drag` | Move window | Drag to reposition floating window |
| `Super + Right Click + Drag` | Resize window | Drag to resize floating window |
| `Super + Mouse Scroll` | Scroll workspaces | Cycle through workspaces |

---

## Configuration Location

All keybindings are configured in:
```
~/.config/hypr/hyprland.conf
```

To reload configuration after changes:
```bash
hyprctl reload
```

To check for configuration errors:
```bash
hyprctl reload 2>&1 | grep -i error
```

---

## Custom Keybind Philosophy

This configuration uses **layout-aware bindings** (`resolve_binds_by_sym = true`):
- Keybindings follow key symbols rather than physical positions
- `Super + Q` will always trigger on the Q key, regardless of layout
- More intuitive when switching between AZERTY and QWERTY keyboards
- Easier to remember: "Q for terminal" vs "remember top-left position"

---

**Last Updated:** 2025-12-04
**For:** archeotech-dotfiles
