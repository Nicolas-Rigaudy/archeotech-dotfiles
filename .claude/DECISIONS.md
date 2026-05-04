# Technical Decisions Log

This document tracks all technical decisions made during the project, with rationale and alternatives considered.

**Purpose:** Maintain a clear record of why things are done a certain way, to inform future decisions and help others understand the system.

---

## Decision Format

```markdown
## [YYYY-MM-DD] Decision Title

**Context:** What situation required a decision

**Options Considered:**
1. Option A
   - Pros: ...
   - Cons: ...
2. Option B
   - Pros: ...
   - Cons: ...

**Decision:** Chose Option X

**Rationale:** Why this was chosen

**Trade-offs Accepted:** What we're giving up

**Review Date:** When to reconsider (if applicable)
```

---

## Decisions

### [2025-11-28] Filesystem: btrfs vs ext4

**Context:** Need to choose filesystem for Arch partition during installation.

**Options Considered:**
1. **ext4**
   - Pros: Stable, well-tested, slightly faster
   - Cons: No snapshots, no transparent compression
2. **btrfs**
   - Pros: Snapshots, compression, familiar from Fedora
   - Cons: Slightly more complex, rare corruption issues

**Decision:** btrfs with subvolumes (@, @home, @snapshots, @cache, @log)

**Rationale:**
- Snapshots provide safety net for system changes
- Already familiar with btrfs from Fedora
- Compression saves disk space
- Separate subvolumes allow selective backups

**Trade-offs Accepted:** Slightly more complexity in initial setup

---

### [2025-11-28] Bootloader: GRUB vs systemd-boot

**Context:** Need bootloader for dual-boot with Fedora.

**Options Considered:**
1. **systemd-boot**
   - Pros: Simpler, faster, native to systemd
   - Cons: More manual dual-boot setup, less themeable
2. **GRUB**
   - Pros: Auto-detects other OSes, highly configurable, themeable
   - Cons: More complex, occasional issues

**Decision:** GRUB

**Rationale:**
- Need dual-boot with Fedora (GRUB auto-detects it)
- Can apply Catppuccin theme
- More documentation available
- Familiar from previous Linux experience

**Trade-offs Accepted:** Slightly slower boot, more complexity

---

### [2025-11-28] AUR Helper: paru vs yay

**Context:** Need AUR helper for installing packages from Arch User Repository.

**Options Considered:**
1. **yay**
   - Pros: More mature, widely used
   - Cons: Written in Go, slower
2. **paru**
   - Pros: Rust-based (faster), more features, better UI
   - Cons: Less mature, fewer users

**Decision:** paru

**Rationale:**
- Performance advantage (Rust)
- Better interactive review of PKGBUILDs
- Modern codebase, actively developed
- More colorful/informative output

**Trade-offs Accepted:** Smaller community, newer tool

---

### [2025-11-28] Window Manager: Hyprland

**Context:** Main choice for this project - no alternatives seriously considered.

**Decision:** Hyprland

**Rationale:**
- Modern Wayland compositor
- Smooth animations and blur effects
- Tiling window manager (productivity)
- Active development and community
- Great documentation
- The whole point of this project!

**Trade-offs Accepted:**
- Wayland compatibility issues with some apps
- Bleeding edge (occasional bugs)
- Requires learning new workflow

---

### [2025-11-28] Display Manager: SDDM vs LightDM vs GDM

**Context:** Need graphical login screen.

**Options Considered:**
1. **LightDM**
   - Pros: Lightweight, many themes
   - Cons: Less modern, X11-focused
2. **GDM**
   - Pros: GNOME standard, polished
   - Cons: Heavy, GNOME-centric
3. **SDDM**
   - Pros: Qt-based, works well with Wayland, Catppuccin themes
   - Cons: Fewer themes than LightDM

**Decision:** SDDM

**Rationale:**
- Best Wayland support
- Catppuccin themes available
- Lightweight enough
- Good configuration options

**Trade-offs Accepted:** Fewer themes, Qt dependency

---

### [2025-11-28] Status Bar: Waybar vs AGS vs Quickshell

**Context:** Need status bar for Hyprland.

**Options Considered:**
1. **Waybar**
   - Pros: Most popular, huge community, CSS styling
   - Cons: Limited to JSON config, less dynamic
2. **AGS (Aylur's GTK Shell)**
   - Pros: JavaScript config, very flexible
   - Cons: Steep learning curve, complex
3. **Quickshell**
   - Pros: QML-based, modern, flexible
   - Cons: Very new, small community

**Decision:** Waybar (with option to try Quickshell later)

**Rationale:**
- Huge community means lots of examples
- CSS styling is familiar
- JSON config is simple to understand
- Can switch to Quickshell once comfortable with basics

**Trade-offs Accepted:** Less flexibility than AGS/Quickshell

---

### [2026-04-21] Desktop Shell: Quickshell (full migration planned)

**Context:** Settings hub (rofi dmenu) can't reflect real toggle state or do sliders. The broader goal of a "coherent designed ecosystem" (one visual language for bar + panels + notifications) is unachievable with the current rofi+waybar+swaync patchwork.

**Options Considered:**
1. **AGS/Astal v2** (TypeScript + GTK4)
   - Pros: Moderate learning curve, good if you know JS/TS
   - Cons: No JS/TS knowledge to leverage; would need to learn TS then QML anyway if migrating to Quickshell later
2. **eww** (Yuck DSL)
   - Pros: Lightweight, Rust-backed
   - Cons: Limited UI capabilities, Lisp-like syntax, lower ceiling
3. **Quickshell** (QML)
   - Pros: Highest ceiling, single process for everything, what caelestia is built on, hot-reload, Qt animations
   - Cons: QML learning curve, MangoWC IPC needs custom bridge (not Hyprland-native)

**Decision:** Quickshell — full migration in phases (control center → bar → notifications → overview)

**Rationale:**
- AGS's main advantage is JS/TS familiarity — not applicable here
- No reason to learn AGS as a stepping stone if Quickshell is the destination
- Caelestia (primary visual reference) is Quickshell — its source code is directly useful
- Single QML process = one theme system, one animation engine, zero inter-process visual seams
- MangoWC IPC limitation is workable: `mmsg -w` watch mode streams events, Quickshell `Process` component reads stdout

**Trade-offs Accepted:**
- QML learning investment upfront
- MangoWC requires custom IPC bridge instead of Quickshell's built-in Hyprland support
- Migration is multi-month — waybar stays until each phase is complete

**Review:** Waybar stays until Phase 2 (bar replacement) is complete. swaync stays until Phase 3.

---

### [2025-11-28] App Launcher: rofi vs wofi vs fuzzel

**Context:** Need application launcher.

**Options Considered:**
1. **wofi**
   - Pros: Native Wayland, simple
   - Cons: Limited features, less themeable
2. **fuzzel**
   - Pros: Fast, minimal
   - Cons: Very basic, no plugins
3. **rofi-wayland**
   - Pros: Most features, extensible, many themes
   - Cons: Port of X11 app (not native Wayland)

**Decision:** rofi-wayland

**Rationale:**
- Can extend with custom modi (AWS, SSH, Terraform menus)
- Huge theme collection
- Can integrate clipboard history, calculator, etc.
- Most powerful option

**Trade-offs Accepted:** Not native Wayland (but works well)

---

### [2025-11-28] Terminal: kitty vs alacritty vs wezterm

**Context:** Need GPU-accelerated terminal emulator.

**Options Considered:**
1. **alacritty**
   - Pros: Very fast, minimal
   - Cons: Limited features, TOML config
2. **wezterm**
   - Pros: Lua config, very flexible
   - Cons: Complex, more resource intensive
3. **kitty**
   - Pros: Fast, image support, extensive features
   - Cons: Python-based (but still fast)

**Decision:** kitty

**Rationale:**
- Already using it and familiar
- Image support (needed for yazi file manager)
- Good balance of speed and features
- Excellent documentation

**Trade-offs Accepted:** Not the absolute fastest (but fast enough)

---

### [2025-11-28] Shell: fish vs zsh vs bash

**Context:** Need shell for terminal.

**Options Considered:**
1. **bash**
   - Pros: Universal, default everywhere
   - Cons: Less user-friendly, requires more config
2. **zsh**
   - Pros: Very customizable, Oh My Zsh
   - Cons: Requires configuration, complex
3. **fish**
   - Pros: Friendly, great defaults, syntax highlighting
   - Cons: Not POSIX-compliant, different syntax

**Decision:** fish

**Rationale:**
- Already using it and familiar
- Great out-of-box experience
- Excellent autosuggestions
- Good syntax highlighting
- Staying consistent with previous setup

**Trade-offs Accepted:** Non-POSIX syntax (some scripts need bash)

---

### [2025-11-28] File Manager (GUI): thunar vs nautilus vs dolphin

**Context:** Need lightweight GUI file manager.

**Options Considered:**
1. **nautilus**
   - Pros: GNOME standard, simple
   - Cons: GNOME dependencies, limited features
2. **dolphin**
   - Pros: Feature-rich, powerful
   - Cons: Heavy (KDE dependencies)
3. **thunar**
   - Pros: Lightweight, customizable, plugin system
   - Cons: Less polished than Dolphin

**Decision:** thunar

**Rationale:**
- 90% of Dolphin's features at 30% of weight
- No heavy KDE dependencies
- Good plugin ecosystem
- Integrates well with XFCE/GTK apps

**Trade-offs Accepted:** Less features than Dolphin (but enough for needs)

---

### [2025-11-28] File Manager (TUI): yazi vs ranger vs nnn

**Context:** Need terminal file manager.

**Options Considered:**
1. **ranger**
   - Pros: Mature, vim-like, many features
   - Cons: Python-based (slower), dated
2. **nnn**
   - Pros: Very fast, minimal
   - Cons: Less intuitive, steeper learning curve
3. **yazi**
   - Pros: Modern (Rust), fast, beautiful, image preview
   - Cons: Newer (less mature)

**Decision:** yazi

**Rationale:**
- Modern and actively developed
- Beautiful UI with image preview
- Fast (Rust-based)
- Intuitive keybindings
- Integrates well with kitty (image support)

**Trade-offs Accepted:** Newer tool, smaller community

---

### [2025-11-28] Theme: Catppuccin Macchiato vs Mocha

**Context:** Which Catppuccin flavor to use as primary theme.

**Options Considered:**
1. **Mocha** (darker, cooler)
   - Pros: Popular choice, very dark
   - Cons: Can feel too dark/cold
2. **Macchiato** (darker, warmer)
   - Pros: Warmer tones, good contrast
   - Cons: Less common than Mocha
3. **Frappe** (medium dark, cooler)
   - Pros: Good balance
   - Cons: Less distinct identity
4. **Latte** (light theme)
   - Pros: Good for daytime use
   - Cons: Not preferred for primary

**Decision:** Catppuccin Macchiato with Mauve accent

**Rationale:**
- Warmer tones easier on eyes for long work sessions
- Good contrast while not being extreme
- Mauve accent color is distinctive
- Can add Mocha as alternate theme later

**Trade-offs Accepted:** Less common, fewer examples online

---

### [2025-11-28] Keybind Philosophy: Layout-aware vs Position-based

**Context:** How should keybinds work with AZERTY/QWERTY switching.

**Options Considered:**
1. **Position-based (default)**
   - Pros: Consistent muscle memory across layouts
   - Cons: Keys labeled differently than what they do
2. **Layout-aware (resolve_binds_by_sym)**
   - Pros: Logical (Q key does Q action)
   - Cons: Different positions in each layout

**Decision:** Layout-aware (resolve_binds_by_sym = true)

**Rationale:**
- More intuitive (Q key opens terminal on Q key)
- Switching between AZERTY/QWERTY frequently
- Can relearn muscle memory if needed
- Easier to remember "Super+Q = terminal" than positions

**Trade-offs Accepted:** Need to relearn positions when switching layouts

---

### [2025-11-28] Dual Boot Strategy: Keep Windows Recovery vs Delete

**Context:** Initial plan had Windows recovery partitions to keep.

**Decision:** Delete Windows recovery partitions (chose more space for Arch)

**Rationale:**
- Can recover Windows via:
  - HP Cloud Recovery Tool (downloadable)
  - Fresh Windows install from Microsoft ISO
  - Company IT department (work laptop)
- Extra 33GB valuable for Arch development
- Recovery partitions rarely needed

**Trade-offs Accepted:** No on-disk Windows recovery (but alternatives exist)

---

### [2026-02-19] Wallpaper Picker: waypaper vs rofi custom picker

**Context:** Need a wallpaper switcher UI. waypaper installed but opened fullscreen (ugly, takes whole screen).

**Options Considered:**
1. **waypaper**
   - Pros: Ready-made GUI, thumbnail grid, built-in swww support
   - Cons: Opens fullscreen, can't be easily resized, UI not matching theme
2. **rofi custom picker (wallpaper-picker.sh)**
   - Pros: Full control over appearance, integrates with Catppuccin glass theme, floating popup, same tool as app launcher
   - Cons: Required writing custom script + rasi theme

**Decision:** rofi custom picker (scripts/wallpaper-picker.sh + scripts/assets/wallpaper-picker.rasi)

**Rationale:**
- Rofi already used for app launcher — consistent UX
- Can theme it exactly like the rest of the system
- Floating popup vs fullscreen is a huge UX win
- Can embed logo toggle as a first entry in the same picker
- Thumbnails generated via ImageMagick and cached

**Trade-offs Accepted:** Required more implementation work; waypaper kept installed as config backup (backend=custom)

---

### [2026-02-19] SVG Renderer: rsvg-convert vs ImageMagick for Arch logo

**Context:** Need to render arch-logo.svg (with transparency) to PNG for compositing onto wallpaper.

**Options Considered:**
1. **ImageMagick (magick)**
   - Pros: Already a dependency for color extraction
   - Cons: Renders SVG with white background — transparency lost
2. **rsvg-convert (librsvg)**
   - Pros: Native SVG transparency support, respects fill/opacity, clean output
   - Cons: Extra package dependency (librsvg)

**Decision:** rsvg-convert for SVG→PNG, ImageMagick for color extraction and compositing

**Rationale:**
- ImageMagick's SVG renderer doesn't preserve transparency correctly
- rsvg-convert is the standard Arch SVG renderer and already recommended in the ecosystem
- librsvg is a small package with no heavy dependencies

**Trade-offs Accepted:** Two tools instead of one; minor extra dependency

---

### [2026-02-19] Wallpaper Logo Color Cache: separate LAST_COLOR_FOR file

**Context:** Color extraction from wallpaper was always returning stale color (arasaka color) even after switching wallpapers.

**Root Cause:** `LAST_WALL` was written *before* calling `get_wallpaper_color`, so the cache check inside `get_wallpaper_color` saw the new wallpaper path in `LAST_WALL` but the old color in `LAST_COLOR` — cache never invalidated.

**Decision:** Separate `LAST_COLOR_FOR` file, written only *after* successful color extraction

**Rationale:**
- `LAST_WALL` must be written before color extraction (it's the authoritative source for --toggle and --restore)
- `LAST_COLOR_FOR` is only a cache key for the color — written after extraction succeeds
- Keeps the two concerns properly separated

**Trade-offs Accepted:** One extra cache file in ~/.cache/wallpaper/

---

### [2026-02-19] MangoWC Keybind: spawn vs spawn_shell for scripts

**Context:** `binds=SUPER,w,spawn,~/.local/bin/wallpaper-picker.sh` silently failed — script ran but swww socket was unreachable.

**Root Cause:** MangoWC `spawn` runs the process without a shell environment — no `$HOME`, no `$XDG_RUNTIME_DIR`, no swww socket path resolution.

**Decision:** Use `spawn_shell` for all script keybinds

**Rationale:**
- Scripts rely on environment variables (`$HOME`, etc.)
- swww socket is found via `$XDG_RUNTIME_DIR/swww/` — needs shell env
- `spawn_shell` is semantically correct for shell scripts

**Trade-offs Accepted:** Slightly heavier (spawns a shell process) — negligible for keybinds

---

### [2025-12-08] Screen Sharing: Portal Backend for MangoWC

**Context:** Teams/Zoom/Discord couldn't share screen on MangoWC.

**Options Considered:**
1. **xdg-desktop-portal-hyprland** — wrong backend (MangoWC is wlroots, not Hyprland)
2. **xdg-desktop-portal-wlr** — correct wlroots backend

**Decision:** xdg-desktop-portal-wlr with user-level config at `~/.config/xdg-desktop-portal/mangowc-portals.conf`

**Rationale:**
- MangoWC uses wlroots, needs wlr backend
- User-level config managed by stow, tracked in git — avoids root-owned system config

**Trade-offs Accepted:** Extra package dependency; portals must be running (they autostart)

---

### [2025-12-08] SDDM Config Location: system/etc vs config/

**Context:** SDDM config lives at `/etc/sddm.conf` — can't be symlinked with stow.

**Decision:** Store in `system/etc/sddm.conf`, deploy via `scripts/update-system-configs.sh`

**Rationale:**
- System-level config requires root — can't use stow
- Consistent with other system-level configs (snapper, grub custom entry)
- Still tracked in git

**Trade-offs Accepted:** Manual deploy step needed (not automatic like stow configs)

---

### [2025-12-04] Atuin Up Arrow: Full Integration vs Ctrl+R Only

**Context:** Atuin can take over the up arrow for history search, or just add Ctrl+R fuzzy search while keeping up arrow as simple last-command.

**Decision:** Ctrl+R only — keep up arrow as simple last command (`--disable-up-arrow` flag)

**Rationale:**
- Workflow involves frequent rerun of the exact last command (apply → test → apply → test)
- Simple up arrow is faster for that pattern
- Ctrl+R provides powerful fuzzy search when needed

**Trade-offs Accepted:** Less powerful up-arrow history navigation

---

### [2026-04-21] Focus Mode — Dropped

**Context:** Focus mode toggle (dim unfocused windows to 0.5 opacity) was implemented in settings-hub.sh but doesn't apply to already-open windows.

**Root cause:** MangoWC copies `focused_opacity`/`unfocused_opacity` per-client at window creation time (`c->unfocused_opacity = unfocused_opacity` in `createclient()`). `reload_config` updates the global values but never iterates existing clients. There is no `reapply_opacity` IPC dispatch, no mechanism to update open windows.

**Decision:** Remove focus mode from the settings hub entirely. `unfocused_opacity` stays at `0.85` permanently (matches `focused_opacity` — all windows have transparency, no dimming distinction).

**Future revisit:** If MangoWC adds a `set_opacity` or `reapply_window_rules` IPC command, this becomes trivial.

---

### [2026-05-04] Shell Architecture: Fork vs Build Own

**Context:** After Phase 2 (bar mostly done), the shell still feels clunky compared to Noctalia/DankMaterialShell/end-4. Considered switching to an established project.

**Options Considered:**
1. **Fork Noctalia Shell** — has MangoWC support, polished, plugin-based
   - Pros: Immediate polish, active development, MangoWC IPC solved
   - Cons: Material You aesthetic incompatible with Archeotech's cyber-monastic identity; plugin marketplace design conflicts with curated theme personalities; upstream conflicts when MangoWC adds features
2. **Fork AMBXST** — feature-rich, active Discord community
   - Pros: Breadth of features (OCR, QR, AI, recording)
   - Cons: Hyprland-only IPC — all `mmsg` integration would need to be rewritten
3. **Build own, steal patterns from reference projects** ← chosen
   - Pros: Full ownership of aesthetic; MangoWC IPC layer we built is good; Appearance singleton is right foundation; Archeotech themes (Shadow Spear, Gundam HUD, etc.) can't be achieved by skinning another shell
   - Cons: More work; slower polish ramp

**Decision:** Build our own. The current shell's foundation is sound. The gaps are specific and fixable (animations, state sync, MPRIS, notifications). The aesthetic identity is the whole point.

**What to steal (patterns, not code):**
- end-4: JsonAdapter, FileView hot-reload, component lazy loading
- Noctalia: MangoWC IPC patterns (check their source for MangoWC-specific solutions)
- HyDE: theme switching multi-target approach
- Qylock: lock screen QML implementation (PAM auth, blur)

**Rule added:** Before implementing any workaround for a QML/compositor problem, check how the reference projects solve it. Especially Noctalia for MangoWC-specific issues. See `ANALYSIS.md §2`.

---

### [2026-05-04] Source-Checking Rule for QML Problems

**Context:** We've re-solved problems (blur artifacts, OSD placement, state sync) that established projects have already solved better.

**Decision:** When encountering a QML or compositor problem, check reference sources **before** implementing a solution.

**Lookup order:**
1. **MangoWC-specific problems** → [Noctalia Shell](https://github.com/noctalia-dev/noctalia-shell) (explicit MangoWC support)
2. **QML animation/state patterns** → [end-4/dots-hyprland](https://github.com/end-4/dots-hyprland)
3. **Component architecture** → [caelestia-dots/shell](https://github.com/caelestia-dots/shell)
4. **Lock screen** → [Qylock](https://github.com/Darkkal44/qylock)
5. **Installation/distribution** → [HyDE](https://github.com/HyDE-Project/HyDE), [JaKooLit](https://github.com/JaKooLit/Hyprland-Dots)
6. **Full catalog** → `.claude/ANALYSIS.md §2`

**Rationale:** These projects have more QML hours than we do. Their solutions are tested at scale. Our blur artifact issue (the SceneFX halo on glass panels) was solved with a specific alpha value — Noctalia may have a cleaner approach.

---

## Decision Review Schedule

- **Shell architecture:** Review after Sprint 2 — if polish gap still large, reconsider Noctalia fork
- **Theme system:** Review after first theme switcher proof-of-concept (Sprint 3)
- **Notification daemon:** swaync → Quickshell Phase 3 — review timeline after bar is fully polished
- **Keybind philosophy:** Review if AZERTY/QWERTY conflicts emerge

---

## How to Use This Document

**When making a new decision:**
1. Copy the decision template
2. List all options seriously considered
3. Document why the choice was made
4. Note what you're giving up
5. Add review date if temporary/experimental

**When reviewing old decisions:**
- Check if circumstances have changed
- Evaluate if chosen option still makes sense
- Update or create new decision entry if changing

**When someone asks "why did we...":**
- Point them to this document
- Rationale should be self-explanatory
- If not clear, update the entry

---

---

## [2026-04-29] Quickshell Bar: Popup via PopupWindow, not PanelWindow

**Context:** Bar hover popups needed to appear outside the 42px-tall bar window. Initial attempt used a child Rectangle inside the bar (clipped). Second attempt used a separate `PanelWindow` with `WlrLayershell.leftMargin`/`topMargin` (don't exist). Third attempt used `PopupWindow` from `Quickshell._Window`.

**Decision:** `PopupWindow` with `anchor.item` pointing to the hovered icon item.

**Rationale:** `PopupWindow` is the purpose-built type for floating positioned popups in Quickshell. `anchor.item` lets Quickshell handle all coordinate math — no `mapToGlobal` or manual offset calculation needed. Each `Bar` instance owns its own `BarPopup`, keeping state local and avoiding cross-screen contamination.

**Trade-offs Accepted:** `PopupWindow` API changed between versions (old: `parentWindow`/`relativeX`/`relativeY`; new: `anchor.*`). Must check qmltypes when upgrading Quickshell.

---

## [2026-04-29] Quickshell Bar: Service singletons for all system state

**Context:** Bar and ControlCenter both need access to audio volume, battery, network, bluetooth state. Could poll in each component, or share state via singletons.

**Decision:** `pragma Singleton` QML files in `services/` directory, declared in `services/qmldir`. All components import `"../services" as Services` and read `Services.Audio.volume` etc.

**Rationale:** Single source of truth — bar and control center always show the same value. One `pactl subscribe` process total, not one per component. State changes propagate to all consumers instantly via QML property bindings.

**Trade-offs Accepted:** Singletons are process-global — can't have per-screen audio state (not needed). Hot-reload of singletons sometimes requires full restart to pick up property additions/removals.

---

## [2026-04-29] Quickshell Bar: MangoWC IPC via mmsg, not Hyprland IPC

**Context:** MangoWC uses its own IPC daemon (`mmsg`), not Hyprland's socket. Most Quickshell examples target Hyprland IPC directly.

**Decision:** Shell out to `mmsg -w -O -t -l -c` as a persistent `Process` with `SplitParser`, parse the output in `MangoWC.qml` singleton.

**Rationale:** MangoWC has no QML bindings. `mmsg -w` streams events on stdout — one line per tag/title/layout change. `SplitParser` handles line buffering. Output format is stable and documented enough from source inspection.

**Trade-offs Accepted:** Can't copy-paste from caelestia or end-4 dotfiles (Hyprland-specific). If mmsg output format changes, parser breaks. Currently hardcoded to specific output format (`<output> tag <num> <sel> <occ> <urg>` etc).

---

**Last Updated:** 2026-04-29
**Total Decisions:** 24

## [2026-05-04] Idle management: configurable via control center

**Context:** swayidle was hardcoded with fixed timers. Screen locking felt random (was actually `before-sleep` on lid-close resume). Needed per-action toggles and timer presets without editing config files.

**Decision:** `swayidle/config.sh` sources `~/.cache/swayidle.conf` for DIM/LOCK/SLEEP enable+timeout, builds swayidle args conditionally, kills and restarts itself. ControlCenter IDLE section writes the config file and calls the script on any change.

**Rationale:** No new daemon needed — the script is already the launcher. State persists across reboots via the cache file. `before-sleep` always locks regardless of LOCK_ENABLED (intentional — lock on resume is always correct behavior).

**Trade-offs Accepted:** swayidle restart is ~200ms — brief gap in idle tracking on every settings change.

---

## [2026-05-04] Quickshell layer blur disabled (blur_layer=0)

**Context:** SceneFX `blur_layer=1` caused white halo artifacts around rounded-corner rectangles on layer surfaces (bar, popups, OSD) on Intel Xe — specifically on landscape/laptop outputs, not portrait. Layerrule `noblur` per-surface did not reliably suppress it.

**Decision:** `blur_layer=0` globally. Glass appearance achieved via high-opacity semi-transparent colors (`glassBg` at 0.96, `glassBgLight` at 0.93) instead of blur-behind.

**Rationale:** The halo is a SceneFX/Intel compositing artifact at alpha-boundary edges of layer surfaces. No per-surface workaround was reliable. High opacity gives a readable dark panel that still hints at the content behind on dark wallpapers.

**Trade-offs Accepted:** No true blur-behind on panels. Window content blur (`blur=1`) is unaffected.

---

**Last Updated:** 2026-05-04
**Total Decisions:** 26
