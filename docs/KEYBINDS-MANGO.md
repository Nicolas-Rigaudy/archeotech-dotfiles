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
| `Super + M` | Exit MangoWC | Logout/quit compositor |
| `Super + F` | Toggle fullscreen | Current window |
| `Super + Shift + Space` | Toggle floating | Tile ↔ Float |
| `Super + T` | Toggle split | Change split direction |

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
| `Super + L` | Lock screen | Swaylock (MangoWC uses swaylock, not hyprlock) |
| `Super + K` | Show keybinds | Display this keybind reference |
| `Super + Shift + R` | Reload config | Reload MangoWC configuration |
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
# MangoWC automatically reloads on config changes, or use:
Super + Shift + R
```

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
- `pavucontrol` (volume control)
- `blueman-manager` (Bluetooth manager)
- `nm-connection-editor` (network manager)
- Picture-in-Picture windows

---

## Key Differences from Hyprland

1. **Tags vs Workspaces:** More flexible multi-monitor workflow
2. **Layout System:** Multiple layout algorithms vs single dwindle/master
3. **Scroller Layout:** Built-in horizontal scrolling (main feature!)
4. **Gap Controls:** Dynamic gap adjustment on the fly
5. **Lock Screen:** Uses swaylock instead of hyprlock

---

**Last Updated:** 2025-12-02
**For:** archeotech-dotfiles (MangoWC configuration)
