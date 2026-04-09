# Roadmap & Ideas

Everything worth building, customizing, or investigating — from deep workflow automation to visual flair. This is a living document.

**Last Updated:** 2026-04-09

---

## Table of Contents

- [Theme System Architecture](#theme-system-architecture)
- [Window Manager Deep Config](#window-manager-deep-config)
- [Custom Workflow Scripts](#custom-workflow-scripts)
- [App Launcher Evolution](#app-launcher-evolution)
- [Waybar Deep Customization](#waybar-deep-customization)
- [Productivity Tools](#productivity-tools)
- [Visual Flair & Animations](#visual-flair--animations)
- [AWS & Cloud Workflow](#aws--cloud-workflow)
- [Terminal & Editor Deep Config](#terminal--editor-deep-config)
- [Browser Customization](#browser-customization)
- [Email & Communication](#email--communication)
- [Note Taking & Knowledge Base](#note-taking--knowledge-base)
- [Reading & Books](#reading--books)
- [OS-Level Controls & Settings](#os-level-controls--settings)
- [Music & Media](#music--media)
- [Screensaver & Lock Screen](#screensaver--lock-screen)
- [Tools to Evaluate](#tools-to-evaluate)
- [Completed / Shipped](#completed--shipped)

---

## Theme System Architecture

Full Catppuccin multi-variant theme switcher — not just colors, but coordinated system-wide theme changes.

### Variants to Support

| Variant | Status | Feel |
|---------|--------|------|
| **Macchiato** | Active (default) | Dark, warm — preferred |
| **Mocha** | Planned | Dark, deep/rich |
| **Frappe** | Maybe later | Dark, cooler |
| **Latte** | Optional | Light mode |
| **Dynamic (wallpaper-extracted)** | Future | Generated from current wallpaper — see below |
| **Non-Catppuccin** | Future | Gruvbox, Nord, Tokyo Night, etc. — same switcher infra |

### What Changes Per Theme

| Component | What Changes | Mechanism |
|-----------|-------------|-----------|
| Hyprland | Border colors, active window glow | `colors.conf` symlink |
| MangoWC | Border colors | `colors.conf` symlink or direct conf |
| Waybar | Background, text, module accent colors | `style.css` symlink |
| Rofi | Background, selection, text colors | `theme.rasi` symlink |
| Kitty | Terminal color palette | `colors.conf` symlink |
| Dunst/Swaync | Notification colors | config symlink |
| GTK apps | System theme | `gsettings` |
| Cursors | Cursor theme | `gsettings` |
| Wallpaper | Background image | `swww` transition |
| VSCode | Editor theme | settings sync (manual) |

### Planned Directory Structure

```
~/.config/themes/
├── catppuccin-macchiato/
│   ├── hyprland-colors.conf
│   ├── waybar-style.css
│   ├── rofi-theme.rasi
│   ├── kitty-colors.conf
│   ├── dunstrc
│   ├── swaync.css
│   └── wallpaper.png
└── catppuccin-mocha/
    └── (same structure)

~/.config/hypr/
├── colors.conf -> ../themes/catppuccin-macchiato/hyprland-colors.conf  (symlink)

~/.config/waybar/
├── style.css -> ../themes/catppuccin-macchiato/waybar-style.css  (symlink)
```

### Theme Switcher Script

```bash
#!/bin/bash
# scripts/theme-switch.sh
THEME_DIR="$HOME/.config/themes"
THEME_NAME="$1"  # e.g. "catppuccin-mocha"

# Update symlinks
ln -sf "$THEME_DIR/$THEME_NAME/hyprland-colors.conf" "$HOME/.config/hypr/colors.conf"
ln -sf "$THEME_DIR/$THEME_NAME/waybar-style.css"     "$HOME/.config/waybar/style.css"
ln -sf "$THEME_DIR/$THEME_NAME/rofi-theme.rasi"      "$HOME/.config/rofi/theme.rasi"
ln -sf "$THEME_DIR/$THEME_NAME/kitty-colors.conf"    "$HOME/.config/kitty/colors.conf"
ln -sf "$THEME_DIR/$THEME_NAME/dunstrc"              "$HOME/.config/dunst/dunstrc"
ln -sf "$THEME_DIR/$THEME_NAME/swaync.css"           "$HOME/.config/swaync/style.css"

# Reload components
hyprctl reload 2>/dev/null || true
pkill waybar && waybar &
pkill dunst && dunst &
swaync-client -rs 2>/dev/null || true
kill -USR1 $(pgrep kitty) 2>/dev/null || true

# Wallpaper with transition
swww img "$THEME_DIR/$THEME_NAME/wallpaper.png" \
  --transition-type fade --transition-duration 2

# GTK theme
gsettings set org.gnome.desktop.interface gtk-theme "Catppuccin-$THEME_NAME-Standard-Accent-Dark"
gsettings set org.gnome.desktop.interface cursor-theme "catppuccin-$THEME_NAME-dark-cursors"

# Save current theme
echo "$THEME_NAME" > "$HOME/.config/current-theme"

notify-send "Theme Changed" "Switched to $THEME_NAME"
```

### Dynamic Color Extraction (Wallpaper-Generated Themes)

We already extract dominant colors from wallpapers for the logo overlay system (`imagemagick` + `convert`). That same foundation can generate a full theme palette from any wallpaper.

**Approach:**
1. Pick a wallpaper → extract 8-16 dominant colors with imagemagick
2. Map them to semantic roles: background, surface, accent, text, urgent
3. Write those values into component configs (waybar CSS vars, kitty colors, rofi theme, etc.)
4. Apply the same reload flow as the static theme switcher

**Tools to look at:**
- `pywal` / `wal` — the classic; generates colorschemes from wallpapers and exports to 30+ app templates
- `matugen` — Material 3 palette generator (used by Caelestia-dots), more principled color relationships
- Our own imagemagick pipeline — we already have the extraction, could skip pywal entirely

**Why this is compelling:**
- Every wallpaper becomes its own theme automatically
- Wallpaper picker + theme switcher become one action
- The logo overlay already does contrast-aware color selection — extend that logic

**Inspiration:** Caelestia-dots uses `matugen` to derive the full palette from the wallpaper, then templates every component config from it.

### Theme Picker via Rofi

- Show all themes as a rofi menu with screenshot previews (same grid layout as wallpaper picker)
- Keybind: `Super + Shift + T`
- Long-term: wallpaper picker **is** the theme picker — selecting a wallpaper auto-applies the extracted palette

### Adding Flair to Themes

Beyond just colors — make each theme feel distinct:
- **Different wallpaper families** per variant (same feel, different image)
- **Different gap sizes** (Mocha = tighter, Macchiato = more airy)
- **Different border width/glow intensity** per theme
- **Per-workspace wallpapers** (see wishlist below)

### Catppuccin Macchiato Color Reference

| Color | Hex |
|-------|-----|
| Rosewater | `#f4dbd6` |
| Flamingo | `#f0c6c6` |
| Pink | `#f5bde6` |
| Mauve | `#c6a0f6` |
| Red | `#ed8796` |
| Maroon | `#ee99a0` |
| Peach | `#f5a97f` |
| Yellow | `#eed49f` |
| Green | `#a6da95` |
| Teal | `#8bd5ca` |
| Sky | `#91d7e3` |
| Sapphire | `#7dc4e4` |
| Blue | `#8aadf4` |
| Lavender | `#b7bdf8` |
| Base | `#24273a` |
| Mantle | `#1e2030` |
| Crust | `#181926` |

---

## Window Manager Deep Config

### MangoWC

- [ ] **Explore Hyprland plugins** — see if they can replicate MangoWC's scrolling layout, and evaluate whether to switch back or stay on MangoWC
- [ ] **Scratchpad terminal** — dropdown terminal on keybind (like Guake/YAKUAKE). Possible with MangoWC's special workspace/floating rules
- [ ] **Window rules** — pin specific apps to specific tags: VSCode → tag 2, browser → tag 3, terminal → tag 1
- [ ] **Floating window exceptions** — calculator, file pickers, pavucontrol already done; refine for all popup windows
- [ ] **Special layouts for dev workflow** — define named layout presets: "code mode" (editor 60% + terminal 40%), "research mode" (browser 50% + notes 50%)
- [ ] **Focus mode** — hide waybar, disable notifications (`swaync-client -d`), toggle with `Super + Shift + F`
- [ ] **Gaming mode** — disable compositor effects (blur/shadows), maybe switch compositor or disable animations for performance
- [ ] **Per-workspace wallpapers** — different swww image per tag switch via hook/script
- [ ] **Hex animation** on window open/close — look into MangoWC SceneFX or custom animation curves for hexagonal/geometric transitions (inspired by KDE/GNOME effect plugins)

### Multi-Monitor & Dock/Undock

- [ ] **Hotplug detection script** — auto-reconfigure monitor layout when docking/undocking
- [ ] **Monitor layout presets** — "laptop only", "home dock" (laptop + 2 external), "work dock" — switch via rofi
- [ ] **Tags follow monitors** — when undocking, windows on external monitor tags come back to laptop screen gracefully
- [ ] **Keybind:** `Super + Ctrl + ,/.` for monitor focus already done — extend with layout preset switcher

### Hyprland (Backup) Deep Config

- [ ] Port all MangoWC window rules to Hyprland
- [ ] Add animation curves for window transitions
- [ ] Investigate `hyprsome` or similar for better multi-monitor workspace management
- [ ] Keep in sync with MangoWC config changes

---

## Custom Workflow Scripts

### Context Menu / Quick Tools

A radial or rofi context menu with situationally useful tools — like a right-click desktop menu but keyboard-driven:

```
Super + X → rofi menu:
├── Color picker (wl-color-picker)
├── Screenshot region (grim + slurp)
├── Screenshot window
├── Record screen (wf-recorder toggle)
├── OCR text from screen (frog)
├── Quick calculator (rofi-calc)
└── Emoji picker
```

### Screenshot & Recording

- [ ] **Screenshot region** → clipboard: `Super + S` (done)
- [ ] **Screenshot full** → save: `Super + P` (done)
- [ ] **Annotate screenshot** — add `swappy` as post-screenshot annotation layer before copying
- [ ] **Screen recording toggle** — `Super + Shift + R` starts/stops `wf-recorder`, saves to `~/Videos/Recordings/`
- [ ] **Window screenshot** — snap just the active window (grim with `-g "$(hyprctl activewindow -j | jq -r '.at,.size' ...)"`)

### Project Workspace Switcher

Detect git repos in `~/Projects/` and let you jump to them via rofi:

```bash
# scripts/rofi/project-switcher.sh
find ~/Projects -maxdepth 2 -name ".git" -type d \
  | sed 's|/.git||' \
  | xargs -I{} basename {} \
  | rofi -dmenu -p "Project" \
  | xargs -I{} kitty --directory ~/Projects/{}
```

- Opens a kitty terminal in the selected project
- Could also open VSCode with the project: `code ~/Projects/{}`
- Keybind: `Super + Ctrl + T`

### VSCode Project Switcher

Launch VSCode with a recently used project via rofi:

```bash
# Use VSCode's internal recent projects list
# ~/.config/Code/User/globalStorage/storage.json
# Parse recentFolders → rofi → code <path>
```

- Keybind: `Super + P`

### SSH Quick Connect

```bash
# scripts/rofi/ssh-connect.sh
# Parse ~/.ssh/config for Host entries
grep "^Host " ~/.ssh/config | awk '{print $2}' \
  | rofi -dmenu -p "SSH" \
  | xargs -I{} kitty ssh {}
```

- Keybind: `Super + Ctrl + S`

### Monitor Layout Switcher

```bash
# scripts/monitor-layout.sh
# Presets: laptop, home, work, presentation
case "$1" in
  laptop)   # disable externals, laptop only ;;
  home)     # laptop + 2 external monitors ;;
  work)     # laptop + 1 external ;;
  present)  # mirror laptop to external ;;
esac
```

- Launch via rofi: `Super + Shift + M`

### Keyboard Layout Indicator & Switcher

- `Alt + Shift` already toggles QWERTY ↔ AZERTY
- [ ] Add waybar indicator showing current layout
- [ ] Look into `kanata` for more advanced layout/remapping (tap-hold Caps Lock, etc.)

### VPN Status & Control

- [ ] Waybar module showing VPN connected/disconnected + which profile
- [ ] Click to toggle VPN via rofi (list profiles → connect/disconnect)
- [ ] Script: `nmcli con show --active | grep vpn`

---

## App Launcher Evolution

### Rofi Deep Config

Currently using `rofi-wayland` for app launch and clipboard. Deep customization:

- [ ] **Rofi-calc** — `Super + =` launches calculator directly in rofi
- [ ] **Emoji picker** — `rofimoji` or `rofi-emoji` plugin
- [ ] **Custom theme** — full Catppuccin Macchiato rofi theme (background, selection, input colors)
- [ ] **Grid mode** for app launcher (icons + names, not just list)
- [ ] **Rofi as file picker** override (via xdg-desktop-portal)

### Walker vs Rofi

- [ ] **Evaluate Walker** — newer Wayland-native launcher, written in Go
  - Faster startup than rofi
  - Built-in plugins: apps, commands, files, websearch, calc
  - GTK4, better Wayland integration
  - Decision: test it for a week, compare with rofi for daily use

---

## Waybar Deep Customization

Goal: waybar is a live dashboard, not just a clock and workspace switcher.

### Modules to Build/Improve

| Module | Status | Notes |
|--------|--------|-------|
| Workspaces/Tags | Done | Shows active tag |
| Clock | Done | — |
| Battery | Done | With alert script |
| Network/WiFi | Done | nm-applet |
| Volume | Done | PipeWire |
| Bluetooth | Partial | Blueman |
| Brightness | Done | brightnessctl |
| CPU/RAM | Partial | Consider custom script vs btop |
| **Git branch** | To build | Show current branch for focused window's directory |
| **VPN status** | To build | Active VPN profile name + toggle on click |
| **AWS profile** | To build | Currently assumed profile via Granted |
| **Keyboard layout** | To build | Show QWERTY/AZERTY indicator |
| **Docker status** | To evaluate | Running containers count |
| **Swaync unread** | To add | Notification count badge → click to open panel |
| **Terraform workspace** | To evaluate | Show current `terraform workspace` |
| **Hyprpicker trigger** | To add | Click to launch color picker |

### Git Branch Module

```bash
#!/bin/bash
# scripts/waybar/git-branch.sh
# Find git repo for the focused window's working directory
FOCUS_PID=$(hyprctl activewindow -j | jq -r '.pid' 2>/dev/null)
if [ -n "$FOCUS_PID" ]; then
  CWD=$(readlink -f /proc/$FOCUS_PID/cwd 2>/dev/null)
  BRANCH=$(git -C "$CWD" rev-parse --abbrev-ref HEAD 2>/dev/null)
  if [ -n "$BRANCH" ]; then
    echo " $BRANCH"
    exit 0
  fi
fi
echo ""
```

### AWS Profile Module

```bash
#!/bin/bash
# scripts/waybar/aws-profile.sh
# Show active AWS profile from granted/env
PROFILE="${AWS_PROFILE:-${AWS_DEFAULT_PROFILE:-none}}"
echo " $PROFILE"
```

### Waybar Icons

- [ ] Audit all module icons — ensure Nerd Font icons show correctly
- [ ] Make every module clickable where it makes sense:
  - Battery → open btop
  - Network → open blueman / nm-connection-editor
  - Volume → open pavucontrol
  - Clock → open calendar app
  - Swaync → toggle notification panel
  - AWS → open rofi AWS profile switcher

### Quickshell

- [ ] Investigate **Quickshell** as a future waybar replacement (QML-based, more powerful)
- References: [end-4/dots-hyprland](https://github.com/end-4/dots-hyprland), [caelestia-dots/shell](https://github.com/caelestia-dots/shell)

---

## Productivity Tools

### Clipboard

- [x] `cliphist` + rofi: `Super + V`
- [ ] Image clipboard support (paste images from clipboard history)
- [ ] Pin clipboard entries (keep certain items permanently)

### Hyprshot / Hyprpicker

- [ ] **Hyprpicker** — Hyprland-native color picker (alternative to wl-color-picker)
  - Freezes the screen while picking (better UX)
  - Keybind: `Super + Shift + C`
- [ ] **Hyprshot** — Hyprland screenshot tool with more options than grim+slurp

### Drawing / Whiteboard

- [ ] **Excalidraw** — for quick diagrams and sketches. Run as a PWA in Zen Browser
  - Good for: architecture diagrams, braindumps, quick wireframes
  - App: `excalidraw.com` → install as PWA
- [ ] Could also try: **Rnote** (native Linux drawing app, stylus support)

### RSS Feeds

- [ ] Explore what RSS is and how to use it
- Tools to evaluate:
  - **Newsboat** — TUI RSS reader (terminal)
  - **Miniflux** — self-hosted RSS server with web UI
  - **Fraidycat** — simple, minimal feed tracker
- Use case: follow blog posts, Arch news, GitHub releases, tech articles without a social feed

### Quick Notes / Scratchpad

- [ ] **Obsidian quick capture** — keybind to open a daily note or inbox note instantly
- [ ] Integrate Claude into Obsidian for AI-assisted note taking (look into Obsidian Claude plugin)

### Rofi Settings Menu

A unified settings launcher for OS controls — instead of hunting for GUI panels:

```
Super + Shift + S → rofi settings:
├── Bluetooth (blueman)
├── WiFi (nm-connection-editor)
├── Audio (pavucontrol)
├── Display (wdisplays or custom script)
├── Power (wlogout)
├── Keyboard layout toggle
└── Screen lock
```

---

## AWS & Cloud Workflow

### Version Control Context

- **Personal projects:** GitHub (`github-cli` / `gh`)
- **Work projects:** GitLab (install `glab` — official GitLab CLI)
- Both need SSH keys configured (already done from Fedora migration)

Waybar git branch module should work for both since it reads from the local repo regardless of remote.

### AWS Console Launcher

```bash
# scripts/rofi/aws-launcher.sh
# List AWS profiles → open console in browser for selected
assume --list | rofi -dmenu -p "AWS Profile" \
  | xargs -I{} sh -c 'assume -c {}'
```

- Keybind: `Super + A`

### Terraform Commands

```bash
# scripts/rofi/terraform-menu.sh
echo -e "plan\napply\ndestroy\nworkspace list\nworkspace select\noutput\nstate list" \
  | rofi -dmenu -p "Terraform" \
  | xargs -I{} kitty --title "Terraform" sh -c "terraform {}"
```

- Keybind: `Super + Ctrl + P`

### AWS Profile Indicator

- Waybar module showing active AWS profile (see Waybar section)
- Click to open rofi profile switcher

### K8s Context Switcher

- [ ] `kubectl config get-contexts` → rofi → `kubectl config use-context`
- Keybind: `Super + Ctrl + K`

---

## Terminal & Editor Deep Config

### Kitty Deep Config

- [ ] **Tab management** — improve tab bar style, rename tabs per project
- [ ] **Split panes** — configure horizontal/vertical splits with Kitty's native splits
- [ ] **Window decoration** — borderless with MangoWC, styled border color matches Catppuccin
- [ ] **Image preview** — ensure yazi image preview works properly in kitty
- [ ] **Bird's-eye tab overview** — Ptyxis-inspired: script to list all kitty windows/tabs in rofi
- [ ] **Remote control** — use `kitty @` to script kitty from outside (open tab, run command, etc.)

### Kitty Sessions

Pre-defined workspace layouts launched via command:

```bash
# sessions/dev.conf
new_tab editor
launch --cwd ~/Projects/current-project code .

new_tab terminal
launch --cwd ~/Projects/current-project

new_tab git
launch --cwd ~/Projects/current-project lazygit
```

```bash
# Launch a dev session
kitty --session ~/.config/kitty/sessions/dev.conf
```

### Neovim Setup

- [ ] Install `neovim`
- [ ] Start with [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim) — well-documented minimal config
- [ ] Add plugins incrementally: LSP, treesitter, telescope, oil.nvim (file browser)
- [ ] Catppuccin theme: `catppuccin/nvim`
- [ ] **Vim motions in VSCode first** — install `VSCodeVim` extension, learn the motions before going full Neovim
- [ ] **vim-be-good** game to practice: `paru -S vim-be-good`

### LazyVim Alternative

- LazyVim = opinionated Neovim distribution with batteries included
- Kickstart.nvim = minimal starting point you configure yourself
- Recommendation: start with kickstart, graduate to LazyVim if you want more out of the box

### Fish Shell Deep Config

- [ ] Custom functions for frequent workflows (project jump, AWS switch, etc.)
- [ ] `fish_user_key_bindings` for custom keybinds inside shell
- [ ] Better `$PATH` management
- [ ] Per-directory `.envrc` support via `direnv`

---

## Browser Customization

### Zen Browser

- [ ] **Catppuccin theme** — install via Zen's theme system or userchrome.css
- [ ] **Stylus extension** — apply Catppuccin CSS to popular sites (GitHub, Reddit, YouTube, etc.)
- [ ] **Deep settings exploration** — zen:config, performance settings, privacy tuning
- [ ] **Custom new tab** — minimal, keyboard-focused new tab page
- [ ] **YouTube PWA** — install YouTube as a standalone PWA window (avoids browser chrome)
- [ ] **Vertical tabs** — Zen has native vertical tabs, configure and master it

### Stylus Catppuccin Sites

Priority sites to theme with Stylus:
- GitHub (catppuccin/github)
- Reddit
- YouTube
- Twitch
- Discord (web)
- Google

---

## Email & Communication

### Thunderbird

- [ ] Evaluate **Thunderbird** as native email/calendar client (vs browser Gmail)
- [ ] Or: **Betterbird** — Thunderbird fork with more features and better UX
- [ ] Catppuccin theme available for Thunderbird

### Teams

Currently using Teams PWA in Zen Browser. Improvements:
- [ ] Teams-specific browser profile in Zen (isolated cookies/sessions)
- [ ] PWA mode with desktop integration

---

## Note Taking & Knowledge Base

### Obsidian

Current status: installed, basic use.

- [ ] **Daily notes workflow** — templater plugin for consistent daily note format
- [ ] **Claude AI integration** — Obsidian has community plugins for AI assistants; look into claude.md-based workflows or API-connected plugins
- [ ] **Obsidian Sync or self-hosted** — sync vault across devices (Obsidian Sync, or Syncthing + git)
- [ ] **Canvas** — visual brainstorming in Obsidian, could replace Excalidraw for some uses
- [ ] **Dataview plugin** — query your notes like a database

### AppFlowy

- [ ] Evaluate **AppFlowy** — open source Notion alternative, self-hosted
  - Better for structured data (databases, kanban boards)
  - Compare with Obsidian for personal knowledge management needs

---

## Reading & Books

### CS Book List

Books worth reading — download and read on PC:

| Book | Author | Topic |
|------|--------|-------|
| Structure and Interpretation of Computer Programs (SICP) | Abelson & Sussman | Programming fundamentals, Lisp/Scheme |
| Computer Systems: A Programmer's Perspective (CSAPP) | Bryant & O'Hallaron | How computers actually work — systems programming |
| Designing Data-Intensive Applications (DDIA) | Martin Kleppmann | Databases, distributed systems, data engineering |

**Reading setup:**
- PDFs in `~/Documents/Books/`
- Open with `zathura` (vim keybinds, minimal distraction)
- Or: `mdcat` for markdown-format summaries/notes alongside

### Zathura for Reading

- Dark background reading: Zathura already supports Catppuccin colors via config
- Reflow mode for long PDFs
- Bookmarks: `:bmark` inside zathura

---

## OS-Level Controls & Settings

### Settings Access

Goal: never open a GUI settings app, drive everything from keyboard:

- [ ] **Rofi settings menu** (see Productivity section) — unified launcher for all system settings
- [ ] **Bluetooth toggle** — `blueman` or `bluetoothctl` via rofi, keybind TBD
- [ ] **WiFi switcher** — `nmcli` via rofi, list and connect to networks
- [ ] **Display control** — `wdisplays` or `kanshi` for monitor layout without GUI
- [ ] **Brightness/volume** already on function keys — add fine control via rofi if needed

### Kansi / Auto Monitor Profiles

- [ ] **kanshi** — automatically applies monitor profiles based on which monitors are connected
  - Dock at home → apply home layout
  - Undock → laptop only layout
  - No manual switching needed

### Kanata Key Remapping

- [ ] Install `kanata`
- [ ] Remap Caps Lock: **tap = Esc**, **hold = Ctrl**
- [ ] Evaluate other remaps: F-row as function keys (already mostly done via firmware)
- [ ] Could also implement: Home Row Mods (a/s/d/f = Ctrl/Alt/Super/Shift on hold)

---

## Music & Media

### Spotify Theming

- [ ] **Spicetify** — Spotify desktop client themer
  - Apply Catppuccin Macchiato theme
  - Custom CSS for Spotify desktop
  - Keybindings, custom extensions
  - Install: `paru -S spicetify-cli`

### Ncspot

- [ ] Install `ncspot` — Rust TUI Spotify client
  - Lower resource usage than Electron Spotify
  - Keyboard-driven
  - Good for quick control from terminal

### Media Controls

Waybar already has media control via playerctl. Improve:
- [ ] Show current track name + artist in waybar
- [ ] Click to play/pause
- [ ] Scroll to change volume

---

## Screensaver & Lock Screen

### Screensaver Rotation

Rotate between terminal animations when idle (before lock screen kicks in):

```bash
# scripts/screensaver.sh
#!/bin/bash
# Random screensaver picker
case $((RANDOM % 4)) in
  0) cmatrix -a -b -C cyan ;;
  1) cbonsai -l -t 0.03 ;;
  2) asciiquarium ;;
  3) pipes.sh -p 4 -c 3 ;;
esac
```

- [ ] Wire into `swayidle` — run screensaver after 2 min idle, lock after 5 min
- [ ] Or: run in a kitty window that auto-launches on idle trigger

### Lock Screen

- swaylock (MangoWC): styled with Catppuccin + blurred wallpaper
- hyprlock (Hyprland): same styling

- [ ] **Clock on lock screen** — large time display overlaid on blurred wallpaper
- [ ] **Screensaver on lock screen** — run a terminal animation inside the lock screen (cmatrix behind the time/password prompt)

---

## Visual Flair & Animations

These are the "fun" items — not essential but make the desktop feel alive.

- [ ] **Hex open/close animations** — investigate MangoWC SceneFX or custom animation plugin for hexagonal window transitions (inspired by KDE Wobbly Windows / Burn-My-Windows GNOME extension)
- [ ] **Window blur** — MangoWC SceneFX blur, tune radius and opacity
- [ ] **Active window border glow** — Catppuccin Mauve (#c6a0f6) glow on focused window border
- [ ] **Inactive window opacity** — slightly dim unfocused windows (0.85-0.9 opacity)
- [ ] **Workspace transition animation** — smooth slide when switching tags
- [ ] **Smooth wallpaper transitions** — already using swww, tune transition type and duration per theme
- [ ] **SDDM idle animation** — set a screensaver/animation on the login screen between sessions

---

## Portability & Machine Profiles

The dotfiles repo should be deployable to any machine with minimal friction, adapting to the use case rather than assuming a dev laptop context.

### Machine Profiles

| Profile | Target | Key differences |
|---------|--------|-----------------|
| `swe-laptop` | HP EliteBook (current) | Full dev stack, AWS/Terraform, work integrations, MangoWC |
| `gaming-desktop` | Personal PC (future) | Gaming mode default, different compositor tuning, no work tools |
| `home-productivity` | Personal PC (non-gaming) | Lighter stack, Obsidian/media focus, no work AWS/Terraform |

### How Profiles Would Work

The install script already handles symlinking configs. Extend it to accept a profile argument:

```bash
./scripts/install.sh --profile swe-laptop
./scripts/install.sh --profile gaming-desktop
```

Each profile defines:
- Which packages to install (a packages list per profile)
- Which dotfiles to stow (skip work tools on gaming, skip gaming tools on work)
- Which waybar modules to enable
- Which autostart apps to launch

**Shared across all profiles:** theme system, fish config, kitty, neovim, basic utilities

### Windows Dual Boot Consideration

If deploying to a Windows PC:
- WSL2 + fish/kitty for terminal work (limited)
- Or: proper dual boot, apply the same Arch install + profile system
- Gaming profile would live on Windows side, productivity on Arch
- Dotfiles repo is the same — profile flag determines what gets deployed

### Incremental Philosophy (constraint to keep)

From the project principles — worth writing down explicitly so it doesn't get violated:

1. **Understand everything** — no config line goes in without knowing what it does
2. **One feature at a time** — test before adding the next thing
3. **Stability over aesthetics** — this is a work machine; broken compositor = lost work day
4. **No wholesale dotfile copying** — steal ideas, not configs
5. **If it works, don't touch it** — resist the urge to refactor things that aren't broken

---

## Inspiration Sources

Reference these when planning new features — steal ideas, not configs:

| Source | What's interesting | Link |
|--------|-------------------|------|
| **Caelestia-dots** | Dynamic color extraction, Material 3 palettes, widget concepts | [caelestia-dots/shell](https://github.com/caelestia-dots/shell) |
| **Hyde (hyprdots)** | Theme switching system, multiple layout presets, visual selector UI | [prasanthrangan/hyprdots](https://github.com/prasanthrangan/hyprdots) |
| **end-4/dots-hyprland** | Clean animations, modern aesthetic, AGS/Quickshell widget ideas | [end-4/dots-hyprland](https://github.com/end-4/dots-hyprland) |
| **Adnan's dotfiles** | Minimalist Catppuccin implementation, clean structure | [Adnan-Malik-26/dotfiles](https://github.com/Adnan-Malik-26/dotfiles) |
| **Omarchy** | Opinionated Arch setup by DHH, curated tool choices | [omarchy.org](https://omarchy.org) |

---

## Tools to Evaluate

Things from the notes that need investigation before committing:

| Tool | Category | What to check |
|------|----------|---------------|
| **Walker** | App launcher | Speed vs rofi, plugin ecosystem, Wayland support |
| **Ghostty** | Terminal | Stability, feature parity with kitty |
| **Tabby** | Terminal | SSH management, tab features |
| **Quickshell** | Status bar | Replaces waybar, much more powerful but complex |
| **LM Studio** | Local LLM | Run local AI models — evaluate hardware requirements on i7-1355U/32GB |
| **Mission Center** | System monitor | GUI alternative to btop |
| **Kanata** | Key remapper | Caps Lock → Esc/Ctrl, home row mods |
| **AppFlowy** | Notes | Notion alternative, self-hosted |
| **Rnote** | Drawing | Native whiteboard app, stylus support |
| **Kanshi** | Monitor hotplug | Auto monitor profiles on dock/undock |
| **Wdisplays** | Display control | GUI display layout editor for Wayland |
| **Omarchy** | Dotfiles inspiration | [Look at omarchy](https://omarchy.org) for cool features to steal |
| **glab** | GitLab CLI | Work equivalent of `gh` — MRs, pipelines, issues from terminal |
| **tmux** | Terminal multiplexer | Session persistence for SSH; maybe — kitty tabs + splits may be enough |
| **zellij** | Terminal multiplexer | Rust-based tmux alternative, friendlier UX; same question as tmux |

### Omarchy Notes

- Omarchy is a curated Arch Linux setup by DHH (creator of Rails)
- Interesting for: opinionated tool choices, clean config philosophy
- Worth reading the source even if not using directly

---

## Completed / Shipped

Tracking what's done so this doc doesn't become stale:

- [x] Base Arch installation + dual boot with Fedora
- [x] MangoWC as primary compositor
- [x] Hyprland as backup compositor
- [x] Waybar (separate configs per compositor)
- [x] Rofi-wayland app launcher
- [x] Catppuccin Macchiato as base theme
- [x] Fish shell + Starship prompt
- [x] Lazygit with Catppuccin theme
- [x] Atuin shell history
- [x] Navi CLI cheatsheets
- [x] Tealdeer (tldr, Rust)
- [x] Gping (graphical ping)
- [x] Granted (AWS multi-account)
- [x] awww wallpaper with transitions (was `swww` — renamed after pacman update)
- [x] Arch logo overlay system (arch / rebel / imperial logos)
- [x] Rofi wallpaper picker (thumbnail grid)
- [x] Swaylock + swayidle (MangoWC)
- [x] Hyprlock + hypridle (Hyprland)
- [x] Cliphist clipboard history (`Super+V`)
- [x] Grim + Slurp screenshots
- [x] Wl-color-picker
- [x] Battery alert script
- [x] GNU Stow dotfile management
- [x] Swaync (notification center, MangoWC) — with Catppuccin glass CSS, waybar bell module, `Super+;` keybind, DND toggle
- [x] battery-alert.service (systemd user service — persistent battery monitoring, swaync-compatible)
- [x] Portrait monitor support in wallpaper-set.sh (auto-detected, blurred-backdrop variant)
- [x] Logo area normalization in wallpaper-set.sh (all logos same visual weight regardless of aspect ratio)
- [x] Improved color extraction in wallpaper-set.sh (saturation+contrast scoring, grey wallpaper fallback)
- [x] Monitor fallback rules in mango config (HDMI.*/DP-.* wildcards for unknown displays)
- [x] install.sh: install_local_scripts() + enable_user_services() functions
- [x] Obsidian (note taking)
- [x] Yazi (TUI file manager)
- [x] Btop (system monitor)
- [x] Zoxide (smart cd)
- [x] Eza (better ls)
- [x] Bat (better cat)
- [x] Zathura (PDF viewer)
- [x] MPV (video player)
- [x] Blueman (Bluetooth)
- [x] Snapper + snap-pac (btrfs snapshots)

---

**This document is a living roadmap — check off items as they ship and add new ideas freely.**
