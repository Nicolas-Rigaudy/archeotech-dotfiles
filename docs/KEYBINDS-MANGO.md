# Keybindings Reference - MangoWC

Complete reference for all keybindings in the MangoWC compositor setup.

> **Note:** This configuration uses the same keyboard layout switching as Hyprland. MangoWC uses **tags** (like dwm) instead of workspaces - windows can belong to multiple tags simultaneously.

---

## Table of Contents

- [Application Launchers](#application-launchers)
- [Window Management](#window-management)
- [Tag Navigation](#tag-navigation)
- [Layout System](#layout-system)
- [Monitor Management](#monitor-management)
- [Screenshots & Media](#screenshots--media)
- [Wallpaper & Logo System](#wallpaper--logo-system)
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
| `Super + G` | Open Lazygit | Git TUI with Catppuccin theme |
| `Super + Shift + N` | Open Navi | Interactive command cheatsheets |
| `Super + ,` | Open control center (Quickshell) | Display, audio, network, power, wallpaper, bluetooth, disk |
| `Super + Ctrl + P` | Open project jump (rofi) | Lists git repos in ~/Projects (personal) and ~/Documents/repos (work), opens VSCode + kitty |
| `Super + W` | Open wallpaper picker (Quickshell panel) | Bottom-strip panel — horizontal thumbnail carousel + 4 logo tiles + palette icon shortcut to theme picker |
| `Super + Shift + W` | Toggle logo overlay | Cycles last active logo on/off on current wallpaper |

---

## Window Management

| Keybind | Action | Notes |
|---------|--------|-------|
| `Super + C` | Close active window | Kill focused window |
| `Super + M` | Exit MangoWC | Logout/quit compositor |
| `Super + F` | Toggle fullscreen | Current window |
| `Super + Shift + Space` | Toggle floating / snap back to tile | Float ↔ Tile — use this to re-tile a window you moved with the mouse |
| `Super + T` | Toggle split | Change split direction |

### Scratchpad

| Keybind | Action | Notes |
|---------|--------|-------|
| `Super + `` ` | Toggle scratchpad terminal | Shows/hides a floating kitty — auto-spawned on first press |

The scratchpad terminal persists across tag switches. Size is 75% width × 85% height, centered on screen.

### Focus Movement

| Keybind | Action | Notes |
|---------|--------|-------|
| `Super + Arrow Keys` | Move focus | Between windows |

### Window Movement/Swapping

| Keybind | Action | Notes |
|---------|--------|-------|
| `Super + Shift + Arrows` | Swap window | Exchange with adjacent window |

### Window Resizing

| Keybind | Action | Notes |
|---------|--------|-------|
| `Super + Ctrl + Arrows` | Resize window | ±20px increments |

---

## Tag Navigation

> **Tags vs Workspaces:** Tags in MangoWC work like dwm - windows can be visible on multiple tags at once. This is more flexible than traditional workspaces.

| Keybind | Action | Notes |
|---------|--------|-------|
| `Super + [1-9]` | Switch to tag N | View specific tag |
| `Super + Shift + [1-9]` | Move window to tag N | Assign window to tag |
| `Super + Tab` | Next tag | Cycle forward through tags |
| `Super + Shift + Tab` | Previous tag | Cycle backward through tags |

### Tag Assignment

Tags are flexible and can be used across all monitors. Empty tags are automatically hidden in waybar.

---

## Layout System

MangoWC supports multiple layout algorithms. This is one of its key features!

### Layout Switching

| Keybind | Action | Notes |
|---------|--------|-------|
| `Super + Space` | Scroller layout | **Horizontal scrolling windows** (like Niri!) |
| `Super + Alt + Space` | Tile layout | Master-stack (like Hyprland master) |
| `Super + Alt + G` | Grid layout | Auto-tiling grid (closest to dwindle) |
| `Super + Alt + M` | Monocle layout | One window fullscreen |
| `Super + Alt + V` | Vertical scroller | Vertical scrolling windows |
| `Super + Alt + D` | Deck layout | Master with stacked secondary |
| `Super + Alt + S` | Spiral layout | Spiral tiling pattern |

### Gap Controls

| Keybind | Action | Notes |
|---------|--------|-------|
| `Super + =` | Increase gaps | +5px increment |
| `Super + -` | Decrease gaps | -5px decrement |
| `Super + 0` | Toggle gaps | On/off switch |

---

## Monitor Management

### Monitor Focus

| Keybind | Action | Notes |
|---------|--------|-------|
| `Super + Ctrl + ,` | Focus monitor left | Switch active monitor |
| `Super + Ctrl + .` | Focus monitor right | Switch active monitor |

### Moving Windows Between Monitors

| Keybind | Action | Notes |
|---------|--------|-------|
| `Super + Ctrl + Shift + Left` | Move window to left monitor | Don't keep tag |
| `Super + Ctrl + Shift + Right` | Move window to right monitor | Don't keep tag |
| `Super + Ctrl + Shift + Up` | Move window to upper monitor | Don't keep tag |
| `Super + Ctrl + Shift + Down` | Move window to lower monitor | Don't keep tag |

---

## Screenshots & Media

### Screenshots

| Keybind | Action | Notes |
|---------|--------|-------|
| `Super + S` | Screenshot region | Select area, save + clipboard |
| `Super + P` | Screenshot fullscreen | Save + clipboard |
| `Print` | Screenshot fullscreen | Alternative (laptop key) |
| `Super + Shift + C` | Color picker | Pick color from screen, copies hex to clipboard |

Screenshots are saved to `~/Pictures/Screenshots/` with timestamp format: `YYYYMMDD_HHMMSS.png`

### Clipboard

| Keybind | Action | Notes |
|---------|--------|-------|
| `Super + V` | Clipboard history | Rofi selector for clipboard manager |

---

## Wallpaper & Logo System

| Keybind | Action | Notes |
|---------|--------|-------|
| `Super + W` | Open wallpaper picker | Rofi thumbnail grid — logos on row 1, wallpapers below |
| `Super + Shift + W` | Toggle logo overlay | Cycles last active logo on/off; no logo → restores last used |

### Logo overlay commands (via `wallpaper-set.sh`)
```bash
# Activate a specific logo (arch | rebel | imperial)
wallpaper-set.sh --toggle-logo arch
wallpaper-set.sh --toggle-logo rebel
wallpaper-set.sh --toggle-logo imperial

# Toggle last active logo on/off
wallpaper-set.sh --toggle-logo

# Check current state
wallpaper-set.sh --status
```

Logo color is auto-extracted from the wallpaper (dark wallpaper → bright logo, light wallpaper → dark logo).
Portrait monitors (e.g. DP-3) get their own correctly-sized composite automatically.

---

## System Controls

### Screen & Session

| Keybind | Action | Notes |
|---------|--------|-------|
| `Super + L` | Lock screen | swaylock-launch.sh — shows current wallpaper as background |
| `Super + M` | Logout (quit compositor) | mmsg -q — exits MangoWC cleanly, returns to SDDM |
| Waybar power button | Power menu | wlogout — Catppuccin themed, icon-only buttons, full overlay |
| `Super + K` | Show keybinds | Display this keybind reference |
| `Super + ;` | Toggle notification panel | Open/close swaync notification center |
| `Super + ,` | Open control center | Quickshell panel — display, audio, network, power, etc. |
| `Super + Shift + R` | Reload config | Runs `mango-reload.sh` — reloads config then re-applies monitor layout via wlr-randr |
| `Alt + Shift` | Toggle keyboard layout | US ↔ FR (QWERTY ↔ AZERTY) |

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
| `Super + Left Click + Drag` | Move window | Drag to reposition window |
| `Super + Right Click + Drag` | Resize window | Drag to resize window |

---

## Configuration Location

All keybindings are configured in:
```
~/.config/mango/config.conf
```

To reload configuration after changes:
```bash
# Use the keybind (safe — re-applies monitor layout automatically):
Super + Shift + R

# Or run the script directly:
~/.local/bin/mango-reload.sh
```

> **Note:** Plain `reload_config` resets monitor positions/rotation. `mango-reload.sh` runs the reload then immediately re-applies the correct layout via `wlr-randr`.

---

## Layout Descriptions

### Scroller (Default)
- **What it does:** Windows scroll horizontally (like Niri!)
- **Best for:** Wide monitors, browsing multiple windows side-by-side
- **Default proportion:** 90% of screen width per window

### Tile (Master-Stack)
- **What it does:** One main window, others stacked on the side
- **Best for:** Coding with one main editor and auxiliary windows
- **Master width:** 55% (configurable)

### Grid
- **What it does:** Auto-tiling in a grid pattern
- **Best for:** Many small windows of equal importance
- **Closest to:** Hyprland's dwindle layout

### Monocle
- **What it does:** One window fullscreen, others hidden
- **Best for:** Focus on single task
- **Toggle through:** Cycle windows with focus keys

### Vertical Scroller
- **What it does:** Windows scroll vertically
- **Best for:** Portrait monitors, document review

### Deck
- **What it does:** Master window with stacked secondaries
- **Best for:** One main app with quick access to others

### Spiral
- **What it does:** Windows arranged in spiral pattern
- **Best for:** Visual variety, many windows

---

## Window Rules

Certain windows automatically float:
- `pavucontrol` (volume control) — 800×600
- `blueman-manager` (Bluetooth manager)
- `nm-connection-editor` (network manager)
- `bitwarden` (password manager) — 900×600
- `waypaper` (wallpaper picker) — 900×600
- `org.gnome.Calculator` (calculator)
- File dialog windows (`xdg-portal`, `gtk-file-chooser`) — 800×600
- Browser extension sub-windows (popup panels) — `ignore_maximize:1`
- Picture-in-Picture windows

Monitor assignments (work setup — rules silently ignored when monitors absent):
- `code` (VSCode) → HDMI-A-1 (middle landscape monitor)
- `kitty` → DP-3 (portrait monitor), scratchpad terminal excluded

---

## Key Differences from Hyprland

1. **Tags vs Workspaces:** More flexible multi-monitor workflow
2. **Layout System:** Multiple layout algorithms vs single dwindle/master
3. **Scroller Layout:** Built-in horizontal scrolling (main feature!)
4. **Gap Controls:** Dynamic gap adjustment on the fly
5. **Lock Screen:** Uses swaylock instead of hyprlock

---

**Last Updated:** 2026-04-22
**For:** archeotech-dotfiles (MangoWC configuration)
