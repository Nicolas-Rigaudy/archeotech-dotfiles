# Session Summary: Wallpaper System with Arch Logo Overlay

**Date:** 2026-02-19
**Duration:** ~2 hours (multi-session with context compaction)
**Status:** ✅ Complete

---

## Goals

1. Build a wallpaper switcher with a nice UI
2. Add a centered, large, semi-transparent Arch logo overlay that adapts its color to the wallpaper
3. Toggle logo on/off via keybind and via the picker
4. Replace waypaper (fullscreen, ugly) with a floating rofi thumbnail grid

---

## What Was Accomplished

### wallpaper-set.sh — Core wallpaper script

Created `scripts/wallpaper-set.sh`, symlinked to `~/.local/bin/wallpaper-set.sh`.

**Features:**
- `wallpaper-set.sh <image>` — set wallpaper (applies logo if enabled)
- `wallpaper-set.sh --toggle-logo` — toggle Arch logo on/off, reapply current wallpaper
- `wallpaper-set.sh --restore` — re-apply last wallpaper (used at startup)
- `wallpaper-set.sh --status` — print current wallpaper and logo state

**Logo system:**
- Color extracted from wallpaper via ImageMagick histogram (16 colors, skip brightness <40 or >210, fallback `#1793d1`)
- Arch crystal logo SVG recolored with `sed` (ARCH_COLOR/ARCH_OPACITY placeholders)
- SVG rendered to PNG via `rsvg-convert` (preserves transparency — ImageMagick produces white bg)
- Logo composited centered on wallpaper via `magick composite`
- Logo size: 40% of wallpaper height; opacity: 60%

**Cache system (all in `~/.cache/wallpaper/`):**
- `last-wallpaper` — always the original image path (never composed.png)
- `last-color` + `last-color-for` — extracted color, keyed separately from last-wallpaper
- `composed.png` + `composed-for` — cached composite (skip recomposite if same wallpaper)
- `logo-enabled` — existence = logo is ON
- `thumbs/` — 300px thumbnail cache for rofi picker

### scripts/assets/arch-logo.svg

Adapted official Arch Linux crystal icon for dynamic coloring:
- `ARCH_COLOR` placeholder → replaced with extracted wallpaper color at runtime
- `ARCH_OPACITY` placeholder → replaced with opacity decimal (0.0–1.0)
- Three layers: main shape, right-edge glint (static white 16%), diagonal crystal sheen

### wallpaper-picker.sh — Rofi thumbnail picker

Created `scripts/wallpaper-picker.sh`, symlinked to `~/.local/bin/wallpaper-picker.sh`.

**Features:**
- 4-column grid with 200px thumbnail previews (rofi `--show-icons`)
- First entry: Arch logo toggle (shows `[ON]` / `[OFF]` state, uses arch-logo.svg as icon)
- Remaining entries: all wallpapers from `wallpapers/` dir, sorted by name
- Index-based selection (`rofi -format "i"`) to avoid fragile name matching
- Thumbnails generated via ImageMagick (300px square crop, cached per wallpaper)

### scripts/assets/wallpaper-picker.rasi

Rofi theme: Catppuccin Macchiato glass aesthetic.
- Window: 960×640px, `transparency: "real"`, 16px border-radius, 1px blue accent border
- Grid: 4 columns, 3 lines, 200px icons, 8px spacing
- Text hidden: `text-color: rgba(205,214,244,0)` + `font: "... 1"` (1pt = invisible)
- Selected element: 2px accent border highlight

### MangoWC config updates

- **Startup:** `exec-once=sh -c "swww-daemon & sleep 1; wallpaper-set.sh --restore || wallpaper-set.sh ~/Projects/archeotech-dotfiles/wallpapers/arasaka.png"`
- **Keybinds:**
  - `Super+W` → `spawn_shell ~/.local/bin/wallpaper-picker.sh`
  - `Super+Shift+W` → `spawn_shell ~/.local/bin/wallpaper-set.sh --toggle-logo`
- **Window rules added:** waypaper (900×600 float), bitwarden, file dialogs, calculator, browser popup panels

### waypaper config

- `backend = custom` (was `swww` — critical change so wallpaper-set.sh is called for all wallpaper changes)
- `custom_command = ~/.local/bin/wallpaper-set.sh`
- Stored in `config/.config/waypaper/config.ini` (stow-linked)

---

## Key Bugs Fixed

| Bug | Root Cause | Fix |
|-----|-----------|-----|
| `SCRIPT_DIR` resolving to symlink dir | `dirname` on symlink path | `realpath "${BASH_SOURCE[0]}"` before dirname |
| `echo` in `composite_logo` returning in function value | stdout not redirected | `echo ... >&2` for status messages |
| Arch logo has white background | ImageMagick SVG renderer doesn't preserve transparency | Switch to `rsvg-convert` |
| Logo blurry (upscaled from 256px) | rsvg-convert rendered at native SVG size | Pass target size: `rsvg-convert -w $logo_px -h $logo_px` |
| Toggle always switches back to arasaka | waypaper backend=swww bypassed wallpaper-set.sh, LAST_WALL never updated | `backend = custom` in waypaper config |
| Double logo on toggle-on | Toggle used `swww query` which returned composed.png when logo was on | Toggle reads `LAST_WALL` (always original) not swww query |
| Color always extracted from arasaka | LAST_WALL written before color cache check — cache saw new path but used wrong color | Separate `LAST_COLOR_FOR` file written only after extraction |
| Keybind silently failed | MangoWC `spawn` runs without shell environment (no $HOME, no swww socket) | Changed to `spawn_shell` |
| Rofi theme parse errors | `border: 1px solid @accent` not valid rasi syntax | Split: `border: 1px;` + `border-color: @accent;` |
| `highlight: bold @accent` invalid | rasi shorthand doesn't allow @variable refs | Use literal color: `highlight: bold #89b4fa;` |

---

## Files Modified

| File | Change |
|------|--------|
| `scripts/wallpaper-set.sh` | **New** — core wallpaper management script |
| `scripts/wallpaper-picker.sh` | **New** — rofi thumbnail picker |
| `scripts/assets/arch-logo.svg` | **New** — Arch crystal icon with ARCH_COLOR/ARCH_OPACITY placeholders |
| `scripts/assets/wallpaper-picker.rasi` | **New** — Rofi theme (Catppuccin glass grid) |
| `config/.config/mango/config.conf` | Updated startup, added keybinds, added window rules |
| `config/.config/waypaper/config.ini` | **New** — backend=custom, custom_command=wallpaper-set.sh |
| `docs/KEYBINDS-MANGO.md` | Added Super+W (rofi picker), Super+Shift+W (logo toggle), updated window rules |
| `docs/PACKAGES.md` | Added waypaper, librsvg, imagemagick |
| `.claude/claude.md` | Updated status, file structure, common tasks, tables, footer |
| `.claude/DECISIONS.md` | Added 4 new decisions |

**Symlinks created (manual, outside stow):**
- `~/.local/bin/wallpaper-set.sh`
- `~/.local/bin/wallpaper-picker.sh`

---

## Known Outstanding Items

- MangoWC needs reload (`Super+Shift+R`) for new keybinds to activate after config change
- Wallpaper picker only picks from `wallpapers/` dir (no subfolders — matches waypaper config)
- Zen browser downloads panel fix was attempted (userChrome.css) but was ineffective — user moved the button to the top instead

---

## Architecture Notes

The wallpaper system is designed around a single source of truth:
- `~/.cache/wallpaper/last-wallpaper` always holds the **original** image path — never composed.png
- All toggle and restore operations read from this file
- swww is never queried for the current wallpaper (it returns composed.png when logo is on)
- The color and composite caches are independent of last-wallpaper to avoid stale reads
