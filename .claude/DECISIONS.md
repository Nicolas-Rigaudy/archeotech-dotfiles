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

> **Superseded:** MangoWC became the primary compositor by late 2025. See entry below. Hyprland config retained as fallback only.

**Context:** Main choice for this project - no alternatives seriously considered.

**Decision:** Hyprland (at project start)

**Rationale:**
- Modern Wayland compositor with smooth animations
- Active development and community
- Good documentation

**Trade-offs Accepted:**
- Wayland compatibility issues with some apps
- Bleeding edge (occasional bugs)

---

### [2025-12] Compositor: MangoWC as Primary (Supersedes Hyprland)

**Context:** MangoWC (wlroots-based, scrolling/stacking layout model) was adopted early in the project. Better IPC integration with Quickshell; wlroots backend means `xdg-desktop-portal-wlr` works correctly. Hyprland config kept as fallback.

**Decision:** MangoWC as primary compositor. Hyprland retained as fallback.

**Rationale:**
- MangoWC IPC via `mmsg -w` integrates cleanly with Quickshell `Process` + `SplitParser`
- wlroots base aligns with xdg-desktop-portal-wlr (vs -hyprland)
- Scrolling layout model suits the workflow better

**Trade-offs Accepted:**
- Smaller community, fewer reference configs
- Quickshell's built-in Hyprland IPC (`Quickshell.Hyprland`) not usable — custom MangoWC IPC layer required
- Some tooling is MangoWC-specific (`mmsg`, `mango/config.conf`)

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

**Status (2026-05-19):** Migration complete. Waybar replaced by Quickshell bar (Sprint 2). swaync replaced by native Quickshell notifications (Sprint 6). Quickshell is now the sole shell.

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

**Last Updated:** 2026-05-19

---

### [2026-05-04] MangoWC IPC: DWL native protocol vs mmsg subprocess stream

**Context:** Current `MangoWC.qml` runs `mmsg -w -O -t -l -c` as a persistent `Process` with `SplitParser`, parsing text output line-by-line. After source-inspecting Noctalia Shell (which has MangoWC support), a better approach was found.

**Options Considered:**
1. **Keep mmsg -w stream** (current)
   - Pros: Already working, familiar
   - Cons: Subprocess overhead, fragile text parsing, reconnect on crash, mmsg output format could change
2. **Quickshell.DWL native protocol** (`DwlIpc` + `DwlIpcOutput`)
   - Pros: Native Wayland DWL protocol, signal-driven, no text parsing, Quickshell handles reconnect
   - Cons: Migration work; `mmsg` still needed for 2 edge cases (display scale queries, some switching fallbacks)

**Decision:** Migrate to `Quickshell.DWL` (`DwlIpc` + `DwlIpcOutput`) in Sprint 2. Keep `mmsg` only for operations the DWL protocol can't provide.

**Rationale:** Noctalia source (the only other multi-compositor Quickshell shell with MangoWC support) confirmed this is the right approach — they use DWL protocol as primary, mmsg only as fallback. Native protocol is more reliable and avoids subprocess management.

**Trade-offs Accepted:** Migration effort. Requires testing DWL protocol actually surfaces all needed state (tags, title, appId, layout, selmon). If any field is missing, mmsg fallback is still available.

---

### [2026-05-04] MPRIS and Notifications: native Quickshell APIs, not external processes

**Context:** Sprint 4 (MPRIS) and Sprint 6 (notifications) were planned. Before implementing, checked all reference projects for how they solve these.

**Options Considered:**
1. **MPRIS via playerctl subprocess** — `playerctl -F status` + `playerctl metadata` polling
   - Pros: Simple, familiar
   - Cons: Subprocess overhead, polling latency, process management
2. **Notifications via swaync** — external daemon (current approach)
   - Pros: Already working
   - Cons: Separate process, separate CSS, never visually unified with shell
3. **Native Quickshell.Services APIs** — `Quickshell.Services.Mpris` and `Quickshell.Services.Notifications.NotificationServer`
   - Pros: Native D-Bus, signal-driven, zero subprocess overhead, fully integrated into QML, single process

**Decision:** Use `Quickshell.Services.Mpris` for MPRIS (Sprint 4). Use `Quickshell.Services.Notifications.NotificationServer` for notifications (Sprint 6). Both confirmed working from end-4/dots-hyprland source inspection.

**Rationale:** Both APIs are first-class Quickshell services, not workarounds. end-4 runs 46 service singletons with zero external polling processes for MPRIS and notifications. The entire rationale for Quickshell was one coherent process — using external daemons for these undermines that.

**Trade-offs Accepted:** Learning the Quickshell.Services.Notifications API (D-Bus server registration). Must handle notification action callbacks, persistence, and grouping in QML/JS.

---

### [2026-05-04] Go daemon: scoped to raw Wayland protocols only, Sprint 9+

**Context:** Go was considered as a backend for various services. After source-inspecting DankMaterialShell (the reference for Go+QML architecture), the correct scope was determined.

**Options Considered:**
1. **Go daemon for everything** — MPRIS, notifications, audio, battery, network, BT, display, night light
   - Pros: Consistent backend layer
   - Cons: Massive over-engineering; Quickshell already has native APIs for MPRIS, notifications, PipeWire audio, UPower battery — rewriting these in Go provides zero benefit
2. **No Go daemon** — pure QML for everything, use shell commands for display/gamma
   - Pros: Simpler
   - Cons: `wlr-randr` and `wlsunset` shell calls are fragile; no access to wlr-screencopy for integrated screenshots
3. **Go daemon scoped to raw Wayland protocols only** ← chosen
   - Handles: `wlr-output-management` (display layout), `wlr-gamma-control` (night light), `wlr-screencopy` (screenshot)
   - Does NOT handle: MPRIS (Quickshell native), notifications (Quickshell native), audio (Quickshell PipeWire), battery (UPower D-Bus), network (nmcli), BT (org.bluez D-Bus)

**Decision:** `archeotech-daemon` Go binary, Sprint 9+. Unix socket at `$XDG_RUNTIME_DIR/archeotech.sock`, newline-JSON RPC. Namespaced methods: `display.extend`, `display.mirror`, `display.laptop-only`, `gamma.set`, `screenshot.region`. QML side: `Services/ArcheotechDaemon.qml` singleton using Quickshell `Socket` type.

**Rationale:** Go earns its place only where Quickshell genuinely can't reach: raw Wayland protocol socket clients (wlr-output-management, wlr-gamma-control, wlr-screencopy). Everything else is native QML APIs. DankMaterialShell confirmed this boundary — their Go daemon handles evdev, udev, wlr protocols, persistent clipboard; their QML handles workspace/window state, MPRIS, notifications.

**Trade-offs Accepted:** One additional binary to build and install. Go dependency in the project. Sprint 9 is non-trivial — display/gamma management without the daemon continues to work (via wlr-randr/wlsunset shell calls), so the daemon is additive not blocking.

---

### [2026-05-11] Bar: Popup rendered inside PanelWindow, not as separate surface

**Context:** Initial popup implementation (pre-sprint 6) used a `Loader` + `PanelWindow` as a separate layer-shell surface. This caused: grey-block rendering artifact when the Loader destroyed the surface, no smooth slide animation between icons (surface was recreated on every hover), and extra compositor round-trips for each popup show/hide.

**Decision:** Popup card lives as a persistent `Shape` child of the bar's own `PanelWindow`. The bar window is extended to 220px tall; a `Region`-based input mask limits pointer events to the bar strip + popup footprint. The card is never destroyed — opacity/scale animate between visible and hidden.

**Rationale:**
- Persistent card means switching between icons slides x with no destroy/recreate; animation is smooth
- Single surface avoids the grey-block artifact (Quickshell bug: layer surface destruction leaves a 1-frame grey fill)
- Input mask on the PanelWindow restricts events correctly without needing a separate surface for hit-testing
- `pill` stays at `z: 1` so it renders on top of the popup card's top edge, keeping visual layering clean

**Trade-offs Accepted:** Bar PanelWindow is now 220px tall (taller than the visible bar). The `exclusiveZone` is still set to bar height only — the extra height is transparent and below the bar. If a future popup content exceeds 220px the card will clip; adjust the constant if needed.

---

### [2026-05-11] Bar: Popup card shape — concave funnel top via QtQuick.Shapes

**Context:** Original popup card was a `Rectangle` with `radius` and a 1px accent border. Needed a shape that visually connects the popup to the bar — wider at the top (aligned to bar bottom), narrowing to a body width via concave arcs.

**Decision:** `QtQuick.Shapes.Shape` with a hand-drawn `ShapePath`: flat wide top edge → CCW concave arcs narrowing to body width → straight sides → CW rounded bottom corners. Fill is `glassBgLight`; no stroke. Shape item width is `bodyWidth + 2*_r` so the funnel ears (which extend `_r` past the body on each side) are within the item's bounding box. `layer.enabled: true; layer.samples: 8` for 8× MSAA on all edges.

**Rationale:**
- The funnel visually anchors the popup to the triggering icon — "this popup came from here"
- `Shape` is the only way to draw non-rectangular filled paths in QML without C++ plugins
- `layer.samples: 8` is the standard fix for pixelated Shape edges in Qt Quick (software antialiasing on Shape is unreliable; MSAA via layer is the correct approach)
- Shape item must be wide enough to contain all path coordinates: funnel ears extend `_r` on each side, so `width = bodyWidth + 2*_r`. Without this, `layer.enabled` clips the ears (layer texture = item bounding box)

**Trade-offs Accepted:** Shape rendering is slightly more expensive than a Rectangle. The persistent card (never destroyed) means this cost is always paid — acceptable given it's one card per screen.

---

### [2026-05-11] Bar: Popup hide — timer grace period + owner tracking

**Context:** Original `hidePopup()` set `_popupVisible = false` immediately. Two bugs resulted:
1. Moving directly between icons caused a flicker (hide + show in quick succession, animation briefly reversed)
2. A QML race where `onEntered(B)` fires before `onExited(A)` (observed in Quickshell/Wayland event delivery) caused the second popup to disappear 250ms after appearing: `onEntered(B)` stopped a timer that wasn't running; then `onExited(A)` started it with nothing to cancel it

**Decision:** `hidePopup()` starts a 250ms `Timer` instead of hiding immediately. `showPopup()` stops the timer, stamps `_lastShowTime`, and records `_popupOwner = item`. `hidePopup(caller)` ignores the call if `caller !== _popupOwner` — stale `onExited` from the previous icon is silently dropped. Popup card's `onExited` has its own `Date.now() - _lastShowTime > 200` guard (prevents hide when popup repositions under the cursor on icon switch).

**Rationale:**
- 250ms grace lets the cursor cross gaps between icons without the popup flashing off
- `_popupOwner` check is timing-independent — works regardless of how many milliseconds separate `onEntered(B)` and `onExited(A)`, which varies with compositor event batching
- Time-based guards (tried: 50ms, then `> 0`) were too coarse: 50ms blocked legitimate quick exits (popup stayed open); `> 0` failed when events fired 1ms apart

**Trade-offs Accepted:** A stale `onExited` from a non-owner icon is silently ignored even if legitimately fired. In practice this is correct behaviour — if `_popupOwner` has already changed, we don't want the old icon to hide the new popup.

---

### [2026-05-11] Bar: Clock absolutely centered, not in RowLayout

**Context:** Clock was a child of the RowLayout's center fill `Item`. If the left section (tags + title + MPRIS) grew wider than the right section (tray icons), the "center" item shifted and the clock was visually off-center in the pill.

**Decision:** Clock (`centerClock`) is a direct child of the `pill` Rectangle with `anchors.centerIn: parent` and `z: 1`. The RowLayout center slot is now a plain `Layout.fillWidth` spacer.

**Rationale:** True visual center of the pill, independent of left/right section widths. `z: 1` ensures the clock renders above the popup card's top edge if they ever overlap.

**Trade-offs Accepted:** Clock can overlap long window titles or MPRIS marquee if both are maximally wide simultaneously. Acceptable — clock is always readable on a dark pill background.

---

### [2026-05-11] Bar: Tray icon hit areas — Item wrappers with fixed bar height

**Context:** Tray icons were bare `Text` elements with `MouseArea` children. The hit area was exactly the glyph bounding box — too small for comfortable clicking, and `parent.color` on the MouseArea targeted the Text's parent Item rather than the icon Text itself, causing color changes to fail silently.

**Decision:** Each icon is wrapped in an `Item` with `height: bar.height; width: icon.implicitWidth + 10`. The `MouseArea` fills the Item. Color changes target the named icon Text id directly (`volIcon.color`, `btIcon.color`, etc.). Live-updating icons (mic, volume, brightness) additionally have `Connections` blocks to update popup content while hovering.

**Rationale:**
- Full bar height hit area is consistent with standard bar UX (the whole strip height is clickable)
- Named icon targets eliminate the `parent.color` ambiguity
- Connections blocks let the popup reflect real-time state changes (e.g. scrolling volume while popup is open) without re-calling `showPopup`

**Trade-offs Accepted:** More verbose per-icon code. Accepted — clarity is worth it.

---

### [2026-05-11] Bar: Notification bell — icon color instead of badge pill

**Context:** Unread notifications were indicated by a small red pill badge (count or "9+") overlaid on the bell icon. The pill style was visually inconsistent with the rest of the bar (the only element with a child overlay shape) and added noise to an already dense tray.

**Decision:** Remove badge pill entirely. Bell icon color encodes state: `subtext1` (no notifications) → `red` (unread notifications) → `accent` (notification center open / hover). The count is available in the notification center panel itself.

**Rationale:** Icon color is the existing pattern for state in the tray (mic red when muted, BT mauve when connected). A count badge is useful when glanceable count matters — for notifications the actionable signal is "there are some" not "there are exactly N". Color conveys that with less visual weight.

**Trade-offs Accepted:** Exact unread count not visible from the bar. Acceptable — count is one click away in the notification center.

---

### [2026-05-12] WiFi Radio Toggle: Quickshell.Networking vs nmcli

**Context:** Sprint 9 WiFi native — need to toggle the WiFi adapter on/off.

**Options Considered:**
1. `nmcli radio wifi on/off` subprocess
2. `Quickshell.Networking.wifiEnabled = true/false` (native property)

**Decision:** `Quickshell.Networking.wifiEnabled`

**Rationale:** Noctalia source-confirmed. Readable+writable boolean property — no subprocess needed. Consistent with our policy of using native Quickshell APIs wherever available (same reason we use Quickshell.Services.Mpris over playerctl, etc.).

**Trade-offs Accepted:** Requires Quickshell 0.2+ (we're on 0.2.1-6, fine).

---

### [2026-05-12] WiFi Network Parsing: Colon-Escape Trick

**Context:** nmcli uses `:` as field separator in `-g` mode, but SSIDs can contain literal `:`. Naive `split(":")` corrupts SSID values.

**Options Considered:**
1. Use `nmcli -t` terse mode — same separator problem
2. Parse via Python3 subprocess — adds dependency
3. Use placeholder replacement: `\:` → placeholder before split, placeholder → `:` after

**Decision:** Placeholder replacement (caelestia's approach)

**Rationale:** Source-confirmed to work. No extra dependencies. The escape sequence `\:` is stable nmcli behavior. Caelestia uses `"STRINGWHICHHOPEFULLYWONTBEUSED"` as the placeholder; we'll use something shorter like `"\x00"` (null char, can't appear in SSID).

**Trade-offs Accepted:** Slightly odd-looking parsing code, but it's isolated to one function.

---

### [2026-05-12] WiFi Password UI: Inline Expansion vs Modal

**Context:** User taps "Connect" on a secured unsaved network — need to collect a password.

**Options Considered:**
1. Modal dialog (separate window / overlay)
2. Dedicated password row at bottom of network list
3. Inline expansion inside the network row itself

**Decision:** Inline expansion inside the network row

**Rationale:** Both end-4 and Noctalia independently arrived at this pattern. Keeps the user's eye on the network they're connecting to. Consistent with the CC's design language (no popups, everything in-panel). The card grows to reveal `TextInput { echoMode: Password }`, shrinks on cancel.

**Trade-offs Accepted:** Card height animation must not fight with list scroll position. List model must be frozen while password field is open (prevent reorder under user's finger). Enterprise (802-1x) deferred to post-Sprint 9.

---

### [2026-05-12] WiFi Forget-on-Failure Pattern

**Context:** When a connect attempt fails (wrong password, timeout), NetworkManager writes a partial connection profile. Leaving it causes all subsequent connect attempts to also fail because NM tries to use the stale profile.

**Options Considered:**
1. Let NM manage profile cleanup
2. Explicitly call `nmcli connection delete <ssid>` on any auth failure before retry

**Decision:** Always forget on failure (option 2)

**Rationale:** Caelestia and DMS both independently implement this. NM does not clean up partial profiles automatically. The delete is safe — the user will re-enter the password on the next attempt.

**Trade-offs Accepted:** User must re-enter password on every failed attempt (not automatically retried with different credentials).

---

### [2026-05-12] Audio Backend: Quickshell.Services.Pipewire vs pactl subprocess

**Context:** Sprint 10 audio sink selection — need to list and switch audio output/input devices.

**Options Considered:**
1. `pactl list sinks` subprocess + `pactl set-default-sink` (current approach for volume)
2. `Quickshell.Services.Pipewire` native bindings

**Decision:** `Quickshell.Services.Pipewire` for device listing and switching; keep pactl for volume (existing, working)

**Rationale:** All three Quickshell repos (caelestia, end-4, Noctalia) use native PipeWire bindings for device management. `PwObjectTracker` is required for reactive volume bindings — without it, `sink.audio.volume` doesn't update. `Pipewire.preferredDefaultAudioSink` is the correct API for setting default device.

**Trade-offs Accepted:** Requires `PwObjectTracker` on the active sink/source — extra boilerplate but mandatory. Volume control can stay on pactl until a full migration is warranted.

---

### [2026-05-12] CC WiFi/BT Row Pattern: CompoundPill (Split Toggle + Expand)

**Context:** WiFi and BT rows in the CC need both a quick toggle (common action) and a details expansion (less common). Combining them in one click area is ambiguous UX.

**Options Considered:**
1. Full-row click = expand, toggle is a separate switch widget on the right
2. Full-row click = toggle, expand via a separate chevron button
3. CompoundPill: left tile = toggle, right body = expand (DMS pattern)

**Decision:** CompoundPill — left ~48px tile toggles, right body expands

**Rationale:** DMS independently derived this pattern. It resolves the ambiguity cleanly: left = power, right = details. Both actions are large touch targets. The visual split (tile vs. body background) communicates the dual nature without labels.

**Trade-offs Accepted:** Slightly more complex layout than a single RowLayout. BT section (Sprint 8) needs to be refactored to this pattern for consistency.

---

---

### [2026-05-12] Settings App: Standalone Window vs CC-Embedded (Wave 2)

**Context:** Wave 2 research confirmed all three QML shells (caelestia, end-4, DMS) provide a dedicated settings app/panel separate from their CC quick-settings.

**Options Considered:**
1. Keep everything in CC, keep growing it with more sections
2. Separate settings app launched from CC gear icon (end-4 model: `qs -p settings.qml`)
3. Expandable CC that becomes the settings panel (caelestia model)

**Decision:** Separate settings window (option 2), launched from CC gear button via IPC. CC stays as quick-access. Sprint 12.

**Rationale:** Caelestia's "CC is settings" model only works because they built it from day one for that purpose — retrofitting ours would require gutting it. End-4 and DMS have proper separation. With deep linking (`openSettingsWithTab(name)`) the two feel seamless anyway. Our CC will eventually have 8+ sections; a separate window with NavRail scales to that.

**Trade-offs Accepted:** Two QML surfaces to maintain. IPC bridge required between CC and settings window. Worth it for the cleaner architecture.

---

### [2026-05-12] Settings Persistence: Config Singleton + JSON + setNestedValue

**Context:** All three QML shells use a config singleton that reads/writes a JSON file. The pattern is convergent enough to adopt directly.

**Options Considered:**
1. Individual QML Settings properties scattered across service files
2. Central `Config.qml` singleton with JSON adapter, dotted key API

**Decision:** Central `Config.qml` singleton (option 2), modeled on end-4's implementation

**Rationale:** Config.qml with `setNestedValue("a.b.c", val)` + JsonAdapter makes every setting instantly reactive throughout the shell. DMS and end-4 independently converged on this. Write debounce (50ms) prevents disk thrashing on slider drags.

**Trade-offs Accepted:** All settings must be keyed by dotted path strings — potential for typos. Mitigated by using typed constants for keys rather than raw strings.

---

### [2026-05-12] Settings Navigation: NavRail (Sidebar) vs Horizontal Tabs

**Context:** Settings panels with 8–34 items. caelestia, DMS, and Noctalia all chose a sidebar/NavRail model over horizontal tabs.

**Options Considered:**
1. Horizontal tab bar at top of settings window
2. Vertical icon+label sidebar (NavRail) with collapsible category groups

**Decision:** NavRail with collapsible categories (option 2)

**Rationale:** Beyond ~6 items, horizontal tabs truncate or wrap. NavRail supports categories, icons, and selection state clearly at any item count. DMS shows it scales to 34 tabs with 10 category groups. Caelestia shows wheel-scroll navigation is a nice bonus.

**Trade-offs Accepted:** Wider minimum window (NavRail takes ~200px). Worth the clarity.

---

### [2026-05-12] Deep Linking: CC Quick Toggle → Settings Pane

**Context:** DMS's `PopoutService.openSettingsWithTab("network")` enables CC quick toggles to deep-link into the full settings panel. Noctalia uses a similar SettingsPanelService pattern.

**Decision:** Implement deep linking from day one in settings architecture. CC gear button and section "more" buttons will call a global `SettingsService.openPane("appearance")` function.

**Rationale:** Without deep linking, settings and CC feel disconnected. With deep linking, CC is the fast path and settings is the full path — they feel like one system.

**Trade-offs Accepted:** Requires IPC or a shared singleton that both CC and settings window can reach. Use Quickshell `IpcHandler` or a `pragma Singleton`.

---

### [2026-05-12] Bluetooth Settings Depth: Three-Category Panel (Noctalia Model)

**Context:** Current Sprint 8 BT implementation shows only paired devices. Noctalia's BluetoothSubTab has three categories (connected, paired, available) with battery + signal + per-category actions.

**Decision:** Future BT settings pane (Sprint 13) will follow Noctalia's three-category model. CC BT section stays as paired-only quick-access.

**Rationale:** The three-category model is the right UX — users need available devices to pair new ones. Battery and signal are valuable for headphone/speaker management. CC stays minimal; settings pane goes deep.

**Trade-offs Accepted:** Requires active BT scanning when panel is open. Scanning is gated behind panel visibility (debounced start/stop) per Noctalia's approach.

---

### [2026-05-12] Theme System: QML-Native Tokens vs HyDE Shell Pipeline

**Context:** HyDE uses a full bash pipeline (wallbash.sh → .dcol files → template substitution per app) for cross-app color cohesion. Requires ImageMagick, swww, and bash expertise.

**Decision:** Build a QML-native token system (`Theme.qml` singleton) for the shell first (Sprint 12+), then add wallpaper color extraction as an enhancement (Sprint 15). Do NOT adopt HyDE's bash pipeline as primary approach.

**Rationale:** Our stack is QML-first. A `Theme.qml` singleton with color tokens that all QML components read from is the right architecture. External app theming (kitty, dunst) can write config files as a side effect — similar to HyDE's template system but triggered from QML.

**Trade-offs Accepted:** External apps won't match shell colors until Sprint 15.

---

---

### [2026-05-19] Bar Popups: Native QML Panels vs External App Launch

**Context:** Bar network and BT icons previously launched `nm-connection-editor` and `blueman-manager`. Sprint 9 goal was to bring these inline as compact popups — same ear+arc Shape geometry as the calendar card.

**Decision:** Replace external app launches with native Shape popups in Bar.qml. WiFi popup shows top-5 networks with connect/disconnect inline; BT popup shows paired device list. Both have adapter toggle headers. "Open Settings" deeplinks into CC via `State.controlCenterOpenSection`.

**Rationale:** External apps break visual cohesion and require separate window management. Native popups give immediate status at a glance and keep the shell self-contained. CC remains the full settings surface for edge cases (password entry, forget, full device list).

**Trade-offs Accepted:** Bar popup capped at 5 networks — power users use CC. Password entry stays in CC only (bar popup triggers deeplink).

---

### [2026-05-19] busctl monitor Fallback: Polling on Access Denied

**Context:** `busctl monitor org.bluez` exits with code 1 (Access denied) in normal user sessions. The original `onExited` handler unconditionally restarted the process, causing an infinite crash loop.

**Decision:** Only restart the monitor on `code === 0` (clean disconnect). Add a 3-second polling `Timer` as fallback when monitor is not running. Timer declared as `property var _pollTimer: Timer {}` — required because `QtObject` has no default property.

**Rationale:** Polling at 3s is sufficient for BT state changes. The monitor approach is best-effort; crashing in a tight loop burns CPU and spams logs with no benefit.

**Trade-offs Accepted:** 3s polling lag for BT state updates when busctl monitor is unavailable.

---

**Last Updated:** 2026-05-19
**Total Decisions:** 51
