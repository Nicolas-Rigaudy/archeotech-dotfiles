# Archeotech Dotfiles — Full System Analysis

**Last Updated:** 2026-05-04
**Purpose:** Comprehensive reference: ecosystem research, current state audit, gap analysis, and roadmap to a distributable GitHub release.

---

## Table of Contents

1. [Quickshell Ecosystem Research](#1-quickshell-ecosystem-research)
2. [Reference Projects — Full Catalog](#2-reference-projects--full-catalog)
3. [Current System Audit](#3-current-system-audit)
4. [Gap Analysis — Where We Are vs Where We Want To Be](#4-gap-analysis)
5. [Dead / Obsolete Files Found](#5-dead--obsolete-files)
6. [Architecture Decision: Build vs Fork](#6-architecture-decision)
7. [Roadmap To Distributable Release](#7-roadmap-to-distributable-release)
8. [Installation Design](#8-installation-design)

---

## 1. Quickshell Ecosystem Research

### What Makes a Shell "Polished"

Based on analysis of the top Quickshell projects (end-4 at 14.3k stars, DankMaterialShell at 6.1k, Noctalia at 6.3k), the gap between "functional" and "polished" comes down to these specific things:

#### Animation system
- Every panel open/close uses a state machine with enter/exit transitions
- Spring physics easing (`NumberAnimation { easing.type: Easing.OutBack }`) not just linear
- Element-level micro-animations: hover scale, press depress, active color fill
- The OSD is the only animated piece in our current shell — everything else snaps

#### State architecture
- **Singleton registry pattern**: All state lives in singletons. UI binds, never copies.
- **No polling for D-Bus-capable services**: Bluetooth, network, battery should use D-Bus signals or `busctl monitor`, not timers
- **External state sync**: If user changes power profile from terminal, UI updates within 2s
- **Lazy component loading**: `active: false` until first use, deactivation timer unloads

#### Theme system
- Colors in one QML singleton (`Appearance.qml` — we have this ✅)
- A `theme.json` file on disk that the singleton reads — enables live theme switching without restart
- Hot-reload: changing `theme.json` propagates to all bound properties instantly

#### Configuration persistence
- Settings written to a JSON file on every change, not just read at startup
- Control center state (DND, power profile, night light) reflects external changes
- Nothing hardcoded in QML — everything reads from config/theme files

#### Missing features that users expect
- Native notification center (not outsourced to swaync)
- Lock screen as a Quickshell component
- MPRIS media card in bar + control center
- App launcher (we use rofi externally — invisible seam)
- Screenshot integration with annotation

---

## 2. Reference Projects — Full Catalog

### Tier 1 — Primary References (Architecture + Polish)

#### end-4/dots-hyprland ★14.3k
**URL:** https://github.com/end-4/dots-hyprland
**What it does:** The most complete Quickshell shell. Bar, sidebar panels, workspace overview with live previews, AI integration (Gemini/Ollama), Material Design 3.
**Steal these patterns:**
- `JsonAdapter` pattern: JSON config file ↔ QML property bindings, bidirectional, debounced 50ms writes
- `FileView` for watching config files — changes propagate live
- Component lazy loading: `active: false`, deactivated by timer when closed
- `Colors.qml` pragma singleton for theme — referenced by all components
- EngineGeneration isolation for safe hot-reload
- Custom URL schemes `root://` and `qs://` for internal resource access
**Why not fork:** Hyprland-only IPC. Our MangoWC `mmsg` layer would need full rewrite of the WM integration.

#### Noctalia Shell ★6.3k
**URL:** https://github.com/noctalia-dev/noctalia-shell
**What it does:** Multi-compositor shell (Hyprland, Niri, Sway, MangoWC, Scroll, Labwc). ~100 plugins. GLSL shaders.
**Steal these patterns:**
- Multi-compositor IPC abstraction layer (directly applicable — they support MangoWC)
- GLSL shader system for blur/fade effects
- Plugin registry architecture for extensibility
- Setup wizard for first-time config
- `Modules/`, `Services/`, `Widgets/`, `Shaders/` directory structure
**MangoWC support:** Yes — best reference for MangoWC IPC patterns.
**Closest to our use case.** Study their MangoWC integration specifically.

#### DankMaterialShell ★6.1k
**URL:** https://github.com/AvengeMedia/DankMaterialShell
**What it does:** Complete shell replacement (bar, lock, idle, notifications, launcher). Go backend + QML frontend.
**Steal these patterns:**
- Backend/frontend separation: Go services expose IPC to QML (scales better than pure QML)
- Multi-compositor abstraction layer
- Complete replacement design (not "add bar on top of waybar")
- Distribution packaging (RPM, Deb, NixOS)
**Why not fork:** Material Design 3 aesthetic is opposite of Archeotech's cyber-monastic direction. Go dependency adds complexity.

#### caelestia-dots/shell ★9.3k
**URL:** https://github.com/caelestia-dots/shell
**What it does:** The original primary visual reference for this project. Material Design 3 with wallpaper-extracted dynamic theming via `matugen`. Complete shell: bar, launcher, notification system, media dashboard, system controls, widgets, lock screen. Unusually high C++ component (19.2%) for performance-critical paths.
**Steal these patterns:**
- `matugen` pipeline: wallpaper → Material 3 palette → all component colors in one pass
- JSON-based configuration exported to all components
- Command-line interface for shell control (e.g., `caelestia media play`, `caelestia lock`) — clean separation of shell API from UI
- Module structure: `components/` (primitives) → `modules/` (features) → `services/` (system) → `utilities/`
- Lock screen implementation as a first-class shell component
- How they handle the bar → notification panel → control center as one unified surface
**Why not fork:** Material You aesthetic conflicts with Archeotech curated themes. The matugen dynamic color extraction is specifically what we *don't* want (we want hand-crafted theme personalities, not wallpaper-extracted colors).
**Status:** Listed as primary inspiration in project roadmap. Read the source before building any major new component.

#### AMBXST (Axenide)
**URL:** https://github.com/Axenide/Ambxst
**Stars:** ~1k, 2219 commits, 19 releases, active Discord
**What it does:** Hyprland shell. Full-featured: launcher, clipboard, notifications, OSD, system monitoring, audio mixing (EasyEffects), Bluetooth, wallpaper manager, emoji picker, color picker, OCR, QR scanning, AI integration, screen recording (gpu-screen-recorder), game mode, power management.
**Steal these patterns:**
- File-watch triggers: watches config files, wallpapers, themes — behavior changes on file update
- Hot-reload with service restart on QML changes
- Integration with external tools rather than reimplementing (OCR → tesseract, recording → gpu-screen-recorder)
- Non-intrusive install: single line sourced into compositor config
- Scope of utility integration (the breadth is the product)
**Note:** Hyprland only. Relevant for feature scope, not IPC patterns.

### Tier 2 — Feature References

#### Qylock ★1.5k
**URL:** https://github.com/Darkkal44/qylock
**What it does:** Quickshell lockscreen specialist. Multiple themes including video backgrounds, pixel art, game-themed (Minecraft, NieR, Genshin).
**Steal these patterns:**
- How to build a Quickshell lockscreen (PAM auth, blur, clock overlay)
- Video background rendering in Quickshell
- Lock screen theme system
**Use for:** Phase 3 — native Quickshell lock screen.

#### NibrasShell ★705
**URL:** https://github.com/AhmedSaadi0/NibrasShell
**What it does:** Async-first architecture. AI system daemon for resource monitoring. Smart Capsule widget (weather, media, stats). Material 3 theming. GIF/video wallpapers. Built-in settings GUI.
**Steal these patterns:**
- Async-first design — all operations non-blocking (prevents UI freezes on slow commands)
- Built-in settings app (no file editing by users)
- Smart capsule widget pattern (dynamic island-style contextual display)

#### Nucleus Shell
**URL:** https://github.com/nucleus-hq/nucleus-shell
**What it does:** Composable modules, JSON config, multiple theme variants (Love, Forests, Passion, Metallic).
**Steal these patterns:**
- Multiple complete visual theme variants from day one
- JSON-only configuration (no QML edits required for customization)

#### tripathiji1312/quickshell ★92
**URL:** https://github.com/tripathiji1312/quickshell
**What it does:** Clean architecture example. Three-tier: Components → Modules → Services.
**Steal these patterns:**
- The three-tier directory structure (best practice separation)
- Full notification server implementation (action buttons, image support)
- Pywal integration pattern

#### YAHR-Quickshell
**URL:** https://github.com/bgibson72/yahr-quickshell
**What it does:** 13 unified themes synchronized across Neovim, Firefox, VSCodium, Kitty, GTK. Glassmorphism as first-class design. SDDM auto-sync. Google Calendar in widgets.
**Steal these patterns:**
- Theme sync scripts (bidirectional sync with editor/browser)
- SDDM color matching automation
- Glassmorphism specs: 92% opacity panels, 1px accent border at 35% alpha, frosted glass cards

#### ColorShell
**URL:** https://github.com/retrozinndev/colorshell
**Note:** AGS-based (not Quickshell). Dynamic theming via pywal16.
**Steal:** Multi-language support approach (EN/FR/PT/RU/TR/JP).

### Tier 3 — Distribution/Install References

#### HyDE ★(gold standard for theme switching)
**URL:** https://github.com/HyDE-Project/HyDE
**What it does:** The gold standard for theme switching. 20+ simultaneous targets (GTK2/3/4, Qt5/6, cursor, icons, dconf, flatpak, fonts, Hyprland). Wallbash auto-generation. Font inheritance. Incremental theme patching. Migration system for version upgrades.
**Steal for installation:**
- Modular script phases: `-i` (pkgs), `-d` (defaults), `-r` (restore), `-s` (system services)
- Declarative restoration format (CSV-like: overwrite|backup|path|config|deps)
- Timestamped backups before any overwrite
- Global function library (300+ utility functions in `global_fn.sh`)
- Theme thumbnail preview in rofi selector
- Migration scripts for version upgrades (`migrations/v26.4.3.sh`)
**Steal for theme switching:**
- Multi-target synchronization approach
- Sanitization before apply (removes conflicting rules)
- Parallel component application (background processes)
- Font inheritance system (per-theme font definitions)

#### JaKooLit/Hyprland-Dots ★3.3k
**URL:** https://github.com/JaKooLit/Hyprland-Dots
**What it does:** Best-in-class interactive install UX. Phased installation. GPU/VM detection. Express vs interactive mode. Auto-backup with cleanup. i18n README (5 languages). Distro-specific repos.
**Steal for installation:**
- Phased approach: high-customization apps first, then standard configs
- `lib_detect.sh` for GPU/VM/NixOS detection
- `lib_prompts.sh` for interactive keyboard/resolution/animation preferences
- Express mode (no prompts, sensible defaults)
- Integrated git-based update mechanism with auto-stash
- Per-app backup strategies (rofi/waybar have special handling)

#### ML4W
**URL:** https://github.com/mylinuxforwork/dotfiles / https://ml4w.com/os
**What it does:** Distribution via hosted scripts. `.dotinst` custom descriptor format. Selective restoration checklist. 50+ individual setting files (each = 1 value). Matugen adaptive colors.
**Steal for installation:**
- Individual setting files pattern (`~/.config/ml4w/settings/` — each setting is 1 file)
- Listener system for runtime config changes
- Per-distro preflight checks
- Piped install: `bash <(curl -s https://ml4w.com/os/stable)`

#### R7rainz/dotfiles
**URL:** https://github.com/R7rainz/dotfiles
**What it does:** Uses `gum` for styled terminal output. Error handler with recovery instructions. Sudo caching. Component-colored output, bordered sections.
**Steal for installation:**
- Visual install script with `gum` (Tokyo Night colors → adapt to Catppuccin Mauve)
- Error handler with recovery guidance
- Progress indication with color-coding

---

## 3. Current System Audit

### File Inventory — Quickshell

```
config/.config/quickshell/
├── shell.qml                    ✅ Main shell root, IPC handlers
├── Appearance.qml               ✅ Theme singleton (colors, fonts, spacing, radii, animations)
├── Osd.qml                      ✅ Volume/brightness OSD, per-screen, 1.5s auto-hide
├── qmldir                       ✅ Module definition
├── bar/
│   ├── Bar.qml                  ✅ Per-screen pill bar, all tray modules, hover popups
│   └── qmldir
├── controls/
│   ├── ControlCenter.qml        ✅ 320px right panel, audio/display/system/idle/tools
│   └── components/
│       ├── ActionButton.qml     ✅ Icon+label button (tools section)
│       ├── PillButton.qml       ✅ Toggle button with active state
│       ├── SectionHeader.qml    ✅ Section label
│       └── ToggleSwitch.qml     ✅ Animated thumb toggle
└── services/
    ├── Audio.qml                ✅ PulseAudio via pactl, subscribe + auto-restart
    ├── Battery.qml              ✅ /sys/class/power_supply/BAT0, 30s poll
    ├── Brightness.qml           ✅ brightnessctl, reads /sys/class/backlight
    ├── Bluetooth.qml            ✅ busctl → org.bluez, 5s poll
    ├── Network.qml              ✅ nmcli monitor (persistent subscription)
    ├── MangoWC.qml              ✅ mmsg -w stream, per-output tags/title/layout
    └── qmldir
```

### Known Weaknesses in Current QML

| Issue | Location | Impact |
|-------|----------|--------|
| No panel enter/exit animations | ControlCenter, Bar popups | Feels "snappy"/cheap |
| Clock updates every 10s | Bar.qml | Visible lag |
| Battery hardcoded to BAT0 | Battery.qml | Breaks on other hardware |
| Bluetooth 5s polling | Bluetooth.qml | Laggy state updates |
| State reads at startup only | ControlCenter.qml | Desyncs with external changes |
| Silent process failures | All services | Debugging impossible |
| Idle config as shell script | ControlCenter.qml | Fragile parsing |
| 10 lines to close CC (manual bbox) | shell.qml | Will break on resize |
| No spring easing | All animations | Flat, lifeless feel |
| No MPRIS integration | Bar.qml | Missing now-playing |

### File Inventory — Scripts

```
scripts/
├── install.sh              ✅ Stow deploy + scripts + systemd
├── uninstall.sh            ✅ Remove symlinks
├── wallpaper-set.sh        ✅ Wallpaper + logo overlay system (awww)
├── wallpaper-picker.sh     ✅ Rofi thumbnail grid
├── battery-alert.sh        ✅ Battery monitor daemon
├── swaylock-launch.sh      ✅ Dynamic wallpaper lock screen
├── mango-reload.sh         ✅ Safe MangoWC reload + wlr-randr re-apply
├── project-jump.sh         ✅ Rofi project launcher
├── wlogout-launch.sh       ✅ Per-monitor adaptive margins
├── setup-snapper.sh        ✅ Automated snapper setup
├── update-system-configs.sh ⚠️  Exists but not called by install.sh
├── show-keybinds.sh.bak    ❌ DEAD — delete
└── assets/
    ├── arch-logo.svg        ✅ Active
    ├── rebel-logo.svg       ✅ Active
    ├── imperial-logo.svg    ✅ Active
    ├── wallpaper-picker.rasi ✅ Active
    └── panel.rasi           ✅ Active
```

### File Inventory — Config Dirs

```
config/.config/
├── hypr/            ✅ Hyprland (backup compositor) — fully configured
├── mango/           ✅ MangoWC (primary) — autostart.sh OUTDATED (see §5)
├── quickshell/      ✅ Active shell
├── waybar/          ⚠️  Two configs: config-mango, config (Hyprland) — possibly redundant
├── swaync/          ✅ Active notification daemon
├── dunst/           ❌ DEAD — replaced by swaync, not autostarted
├── rofi/            ✅ App launcher + wallpaper picker
├── kitty/           ✅ Terminal
├── fish/            ✅ Shell + conf.d/
├── swaylock/        ✅ MangoWC lock screen
├── swayidle/        ✅ MangoWC idle manager
├── wlogout/         ✅ Power menu
├── waypaper/        ✅ Backup wallpaper picker (backend=custom)
├── gtk-3.0/         ✅ GTK3 theme
├── gtk-4.0/         ✅ GTK4 theme
├── btop/            ✅ System monitor
├── yazi/            ✅ TUI file manager
├── zathura/         ✅ PDF viewer
├── bat/             ✅ bat (better cat)
├── cava/            ✅ Audio visualizer
├── xdg-desktop-portal/ ✅ Screen sharing
├── environment.d/   ✅ Env vars (cursor theme, etc.)
├── navi/            ✅ CLI cheatsheets
├── lazygit/         ✅ TUI git client
├── atuin/           ✅ Shell history
└── systemd/user/    ✅ battery-alert.service
```

---

## 4. Gap Analysis

### Phase 2 Bar — What's Missing

| Feature | Status | Priority |
|---------|--------|----------|
| MPRIS now-playing | ❌ Not started | High |
| Brightness in bar tray | ❌ Not started | Medium |
| Clock on 1s tick | ❌ Currently 10s | High (easy fix) |
| Panel enter/exit animations | ❌ None | High |
| Spring easing on all animations | ❌ Linear only | Medium |

### Phase 3 — Notification Center

The single biggest missing piece for a coherent shell. swaync is a separate process with separate CSS — it will never feel unified.

What's needed:
- `org.freedesktop.Notifications` D-Bus server in QML
- Notification popup card component (matching bar/CC aesthetic)
- Notification history panel (slides from right, same glass style)
- DND toggle in panel (real toggle, not swaync relay)
- Action buttons on notifications
- Per-app icon resolution (from desktop file)

Reference: end-4's notification implementation, NibrasShell's async notification handling.

### Phase 3 — Lock Screen

Currently: swaylock (external, separate CSS) for MangoWC. Not a Quickshell component.
What's needed: Quickshell PanelWindow as lock screen with:
- Blur/dim current session behind it
- Clock + date overlay
- Password input field
- Wallpaper background (from `~/.cache/wallpaper/last-wallpaper`)

Reference: Qylock (1.5k stars, specialized in this).

### Theme Switcher — Critical Gap

The Archeotech style guide defines 5 distinct theme personalities (Macchiato, Mocha, Shadow Spear, Gundam HUD, Neon Liturgy). None exist beyond Macchiato.

What's needed for each theme:
- `themes/<name>/theme.json` — Quickshell reads this live (hot-reload, no restart)
- `themes/<name>/mango-overrides.conf` — border/shadow/radius values
- `themes/<name>/kitty-colors.conf` — terminal palette
- `themes/<name>/starship.toml` — prompt style (raven sigil for Shadow Spear, crosshair for Gundam)
- `themes/<name>/rofi-vars.rasi` — color overrides
- `themes/<name>/wallpaper` — path/symlink to wallpaper set

Theme switcher script (`scripts/theme-switch.sh`):
1. Copy `theme.json` to `~/.config/quickshell/theme.json`
2. Patch mango config (border/shadow)
3. Swap kitty include
4. Swap starship symlink
5. Swap rofi vars
6. Call `mango-reload.sh`
7. Send wallpaper transition via `wallpaper-set.sh`

### Developer Modules — Bar

The bar should show contextual dev info (always visible, dims when not relevant):
- Git branch + dirty indicator (from focused window CWD via MangoWC `mmsg`)
- AWS profile (`$AWS_PROFILE` env)
- Terraform workspace (`terraform workspace show`, only in tf repos)

Reference: The roadmap's "Developer Workflow Integration" section.

### Distribution Gaps

For a clean GitHub release:
1. `install.sh` is incomplete (missing 8+ config dirs, no system config deployment)
2. No package installation step (no `pacman -S` / `paru -S`)
3. No prerequisites check (quickshell-git, awww, etc.)
4. No `INSTALL.md` targeting a fresh Arch install
5. No screenshots / demo GIF for README
6. autostart.sh is outdated (launches waybar + dunst instead of quickshell + swaync)

---

## 5. Dead / Obsolete Files

### Delete immediately

| File | Reason |
|------|--------|
| `scripts/show-keybinds.sh.bak` | Backup of replaced script, git-tracked dead weight |
| `config/.config/dunst/dunstrc` | Replaced by swaync. Not autostarted. Misleading to have in repo. |

### Fix immediately

| File | Issue | Fix |
|------|-------|-----|
| `config/.config/mango/autostart.sh` | Launches `waybar` (replaced by quickshell), `dunst` (replaced by swaync), `swww-daemon` (renamed to `awww`), hardcoded wallpaper path | See §7 for corrected version |
| `scripts/install.sh` | CONFIGS array has 19 entries, repo has 27 config dirs. Missing: quickshell, swaync, wlogout, waypaper, navi, lazygit, atuin, swaylock, swayidle | Update CONFIGS array |
| `docs/PACKAGES.md` | Missing `quickshell-git`; `swww` should be `awww` | Update entries |

### Clarify (not broken, but confusing)

| File | Issue |
|------|-------|
| `config/.config/waybar/` | Still has two configs (config, config-mango). Phase 2 of Quickshell migration is "mostly done" but autostart still launches waybar as the primary bar. Once Quickshell Phase 2 is complete, waybar configs should move to `legacy/` or be removed. |
| `scripts/update-system-configs.sh` | Exists, deploys /etc configs, but is never called by install.sh. Should be integrated or documented clearly. |

---

## 6. Architecture Decision

### Verdict: Build Our Own (Option C — pattern study, not fork)

**Why not fork Noctalia:**
- Their aesthetic (Material You, plugin marketplace) conflicts with the Archeotech cyber-monastic identity
- Their theme system is designed for dynamic wallpaper-extracted colors; ours is curated hand-crafted themes
- Forking means fighting their architecture whenever we want something outside their design

**Why not fork AMBXST:**
- Hyprland-only IPC. Our MangoWC `mmsg` layer would need to replace all IPC code.
- Their aesthetic is also generic/neutral

**Why build our own with pattern study:**
- We already have the right foundation: `Appearance.qml` singleton, service singletons, MangoWC IPC layer, multi-monitor bar instantiation
- The quality gap is specific and fixable: no panel animations, state desyncs, 10s clock, no MPRIS
- The Archeotech aesthetic (Shadow Spears, cyber-monastic, named theme personalities) cannot be achieved by theming someone else's shell
- Full ownership means no upstream conflicts when MangoWC adds new IPC features

**What to steal (patterns, not code):**
- end-4: JsonAdapter, FileView hot-reload, lazy component loading
- Noctalia: MangoWC IPC patterns, multi-compositor abstraction structure
- HyDE: theme switching multi-target approach, installation script structure
- JaKooLit: interactive install UX, phased backup approach
- Qylock: Quickshell lock screen implementation

---

## 7. Roadmap To Distributable Release

### Sprint 1 — Fix The Broken Things (1-2 sessions)

**Goal:** Clean up the mess before building new features.

- [ ] Fix `mango/autostart.sh` — quickshell replaces waybar, swaync replaces dunst, awww replaces swww
- [ ] Delete `dunstrc` and `show-keybinds.sh.bak`
- [ ] Fix `install.sh` — add all 27 config dirs to CONFIGS array, add quickshell-git check
- [ ] Fix clock in Bar.qml — 1000ms tick (3-char change)
- [ ] Update `docs/PACKAGES.md` — add quickshell-git, fix awww

### Sprint 2 — Polish Phase 2 Bar (2-3 sessions)

**Goal:** Bar feels polished. Every transition is smooth.

- [ ] Add ControlCenter enter/exit animation (slide + opacity, 200ms OutQuart)
- [ ] Add spring easing to all tag width/color animations in bar
- [ ] Add MPRIS service singleton + now-playing module in bar (scrolling text, icon)
- [ ] Add MPRIS media card in ControlCenter (album art, track, prev/play/next)
- [ ] Fix state sync in ControlCenter (2s poll on `onVisible` for power profile, night light, DND)
- [ ] Add Brightness tray icon to bar (matches Volume pattern exactly)

### Sprint 3 — Theme Switcher Foundation (2-3 sessions)

**Goal:** `Super+Shift+T` switches between Macchiato and one other theme end-to-end.

- [ ] Move Appearance.qml hardcoded colors to `themes/archeotech-macchiato/theme.json`
- [ ] Make Appearance.qml read from `~/.config/quickshell/theme.json` via FileView
- [ ] Create `themes/archeotech-mocha/theme.json` (second theme = proof of concept)
- [ ] Write `scripts/theme-switch.sh` (patches mango, kitty, rofi, quickshell, triggers awww)
- [ ] Add theme picker overlay to Quickshell (rofi-style list with color swatches)
- [ ] Create kitty, rofi, mango variants for both themes

### Sprint 4 — Native Notifications (3-4 sessions)

**Goal:** swaync removed. All notifications are Quickshell components.

- [ ] Implement `org.freedesktop.Notifications` D-Bus server in QML
- [ ] Build notification popup card (glass pill style, icon + title + body + actions)
- [ ] Build notification history panel (slides from right)
- [ ] Real DND toggle (not swaync-client relay)
- [ ] Wire notification bell in bar to history panel
- [ ] Test with: Teams, system alerts, battery-alert.service, playerctl

### Sprint 5 — Lock Screen + Distribution Polish (2-3 sessions)

**Goal:** swaylock removed. First clean distributable release on GitHub.

- [ ] Build Quickshell lock screen (blur, clock, password field, wallpaper bg)
- [ ] Write `scripts/install-packages.sh` (full `paru -S` list)
- [ ] Rewrite `install.sh` to full-featured installer (prereq check, phased backup, verification)
- [ ] Write `INSTALL.md` targeting fresh Arch install (step by step)
- [ ] Take screenshots for README (each theme, each major component)
- [ ] Write proper README with showcase images

### Sprint 6 — Shadow Spear Theme + Dev Modules (ongoing)

**Goal:** Second complete theme personality. Developer workflow in bar.

- [ ] Create `themes/shadow-spear/` full theme (compositor, terminal, prompt, rofi, wallpaper)
- [ ] Add git branch module to bar (from focused window CWD via mmsg)
- [ ] Add AWS profile module to bar (always visible, dims when `$AWS_PROFILE` unset)
- [ ] Add per-workspace wallpapers (hook on MangoWC tag switch via mmsg -w)

---

## 8. Installation Design

### Target: Fresh Arch Linux + MangoWC Install

```
git clone git@github.com:corvus/archeotech-dotfiles.git ~/Projects/archeotech-dotfiles
cd ~/Projects/archeotech-dotfiles
./scripts/install.sh
```

### Planned install.sh Flow

```
1. prereq_check()
   - Arch Linux? (check /etc/arch-release)
   - Required tools installed? (stow, git, quickshell-git, awww, swaync, ...)
   - Missing packages? → print install command, ask to continue

2. backup_configs()
   - Timestamped backup of any non-symlink configs
   - Keeps only latest backup per component (JaKooLit approach)

3. deploy_stow()
   - stow -t ~ config
   - Covers all 27 config dirs atomically

4. install_scripts()
   - Symlink all scripts/ to ~/.local/bin/
   - chmod +x all scripts

5. enable_services()
   - battery-alert.service symlink + systemctl enable

6. interactive_prompts()
   - "Which compositor? MangoWC / Hyprland / Both" → set default autostart
   - "Apply wallpaper now? Y/n"

7. verify()
   - Check all symlinks exist
   - Check quickshell --check (if available)
   - Print next steps
```

### Distribution Checklist (Before First GitHub Release)

- [ ] All configs in repo (no manual steps required)
- [ ] `install.sh` handles full deploy from zero
- [ ] `scripts/install-packages.sh` installs all AUR + pacman packages
- [ ] README has screenshots of all major components
- [ ] README has "Getting Started" (3-command install)
- [ ] INSTALL.md has detailed step-by-step for fresh Arch
- [ ] All dead files deleted
- [ ] autostart.sh correct (quickshell, swaync, awww)
- [ ] No hardcoded paths (no `/home/corvus/` anywhere in configs)
- [ ] Version tag on first release

### Hardcoded Paths Audit (Must Fix Before Distribution)

Search and replace `corvus` / `/home/corvus` in all configs before distributing:
- `scripts/battery-alert.sh` — may have hardcoded paths
- `config/.config/swayidle/` — may reference specific paths
- `config/.config/mango/autostart.sh` — currently has `~/Projects/archeotech-dotfiles/scripts/battery-alert.sh` (should use `$HOME/.local/bin/battery-alert.sh`)
- Any wallpaper paths (should use `$HOME/Pictures/Wallpapers/` or configurable)

---

## Quick Reference: Key Decisions Made

| Decision | Choice | Reason |
|----------|--------|--------|
| Shell framework | Quickshell (QML) | Highest ceiling, what caelestia uses, MangoWC compatible |
| Architecture | Build own, steal patterns | Archeotech aesthetic can't be achieved by theming another shell |
| Theme system | JSON file + FileView hot-reload | Live switching without restart |
| Compositor | MangoWC primary, Hyprland backup | Scrolling layouts |
| Notification daemon (current) | swaync | Quickshell Phase 3 replacement planned |
| Lock screen (current) | swaylock | Quickshell Phase 5 replacement planned |
| Theme palette | Catppuccin Macchiato + named personalities | Curated > dynamic extraction |
| Install approach | stow + install.sh | Simple, auditable, no magic |
| Distribution target | Arch Linux | Primary OS, paru for AUR |
