# Technical Decisions Log

Architecturally load-bearing decisions and non-obvious trade-offs. For implementation detail, read the code and its comments. For tactical numbers (radii, paddings, timer durations), see `.claude/claude.md` "Locked architecture decisions". For ephemeral workarounds, see git history.

---

## Format

```markdown
### [YYYY-MM-DD] Decision title

What was decided (1–2 sentences). Why — the non-obvious rationale that wouldn't be derivable from reading the code. Trade-off accepted.

(Optional: a second paragraph for reference links, supersession notes, or review-by date.)
```

Rules:
- One paragraph per decision is the default. `Options Considered` is only worth listing when the rejected alternatives still illuminate the decision later.
- A choice that's visible in the code (UI patterns, numeric values, file organisation) doesn't need a decision entry — write a comment in the file instead.
- A choice that's been superseded by a later sprint architecture should be deleted, not annotated — git history retains the path we took.
- When in doubt: would someone reading the codebase six months from now understand *why* without this entry? If yes, don't add it.

---

## System & install

### [2025-11-28] Filesystem: btrfs with subvolumes

btrfs over ext4. Subvolume layout `@, @home, @snapshots, @cache, @log` lets snapper take per-subvolume snapshots (data only, no caches/logs in the backup). Already familiar from Fedora. Trade-off: slightly more setup ceremony than ext4.

### [2025-11-28] Bootloader: GRUB

GRUB over systemd-boot. Originally chosen because it auto-detected Fedora for dual-boot; the dual-boot is now gone (2026-04-20) but GRUB stays — themed (Catppuccin), well-documented, and stable. Trade-off: slower boot, more config surface than systemd-boot.

### [2025-11-28] AUR helper: paru

paru over yay. Faster (Rust), better interactive PKGBUILD review, more informative output. Trade-off: smaller community than yay.

### [2025-12] Compositor: MangoWC primary, Hyprland fallback

MangoWC over Hyprland. wlroots base aligns with `xdg-desktop-portal-wlr`; scrolling layout suits the workflow; `mmsg -w` streams events cleanly into Quickshell's `Process` + `SplitParser`. Hyprland config retained as a fallback for the rare day MangoWC breaks. Trade-off: smaller community than Hyprland; no `Quickshell.Hyprland` native bindings — custom `Services/Compositor/MangoWC.qml` IPC layer required.

### [2025-11-28] Display manager: SDDM

SDDM over LightDM/GDM. Best Wayland support, Qt-native, Catppuccin themes available. Trade-off: fewer themes than LightDM, Qt dependency.

### [2025-11-28] App launcher (system-wide): rofi-wayland

rofi over wofi/fuzzel for system menus (settings hub, wallpaper-picker legacy, project-jump). Most extensible — custom modi for AWS / SSH / Terraform; large theme ecosystem. The in-shell launcher (`Super+Space`) is now native Quickshell — rofi stays for ad-hoc tools.

Trade-off: X11 port, not native Wayland (works correctly under `rofi-wayland`).

### [2025-11-28] Terminal: kitty

GPU-accelerated, image protocol support (yazi previews), good defaults, already familiar. Trade-off: not the fastest pure-text terminal (alacritty wins there) but fast enough and far more capable.

### [2025-11-28] Shell: fish

Friendly defaults, syntax highlighting, autosuggestions, already familiar. Trade-off: non-POSIX — bash scripts run via shebang, fish handles the interactive shell only.

### [2025-12-08] Screen-sharing portal: xdg-desktop-portal-wlr

MangoWC is wlroots-based, **not** Hyprland-based. The portal must be `xdg-desktop-portal-wlr`, not `-hyprland`. User-level config at `~/.config/xdg-desktop-portal/mangowc-portals.conf` so it's stow-managed.

### [2025-12-08] SDDM config in `system/etc/`, deployed by script

SDDM reads `/etc/sddm.conf` (root-owned), so it can't be stowed. We track it at `system/etc/sddm.conf` and deploy via `scripts/update-system-configs.sh`. Trade-off: manual deploy step.

### [2025-12-04] Atuin: Ctrl+R only, not up-arrow

Atuin's `--disable-up-arrow` flag — keep ↑ as simple last-command, get fuzzy search on `Ctrl+R`. Workflow is `apply → test → apply → test`, so simple ↑ is faster than scrolling through fuzzy results.

---

## Theme & aesthetics

### [2025-11-28] Palette: Catppuccin Macchiato, mauve accent

Macchiato over Mocha (warmer tones, easier on eyes during long sessions). Mauve accent for the distinctive identity. Mocha shipped as an alternate variant in Sprint 12. Trade-off: less common than Mocha (fewer existing third-party themes).

### [2025-11-28] Keybinds: layout-aware (`resolve_binds_by_sym`)

Position-based bindings would mean "the key labeled Q" runs different actions on AZERTY vs QWERTY. Layout-aware means the *Q action* always lives on the Q key, regardless of which physical position that is. Switching layouts frequently — this is the only model that works. Trade-off: muscle-memory has to relearn positions when switching layouts.

### [2026-05-12] Theme system: QML-native tokens, not HyDE bash pipeline

Built a `Theme.qml` (now `Commons/Appearance.qml`) singleton with color tokens that every QML component reads from, rather than adopting HyDE's wallbash → .dcol → per-app template pipeline. Our stack is QML-first; binding through a token singleton is the cleanest path. External apps (kitty, rofi, starship, GTK, VSCode, Obsidian) get configured by `scripts/theme-switch.py` writing out files as a side effect — same idea as HyDE, triggered from Python instead of bash. Trade-off: Adding a new external-app target means editing the Python applier table.

### [2026-06-02] theme-switch: Python with template registry (Caelestia pattern)

Rewrote `theme-switch.sh` to a thin entrypoint into `theme-switch.py`. The Python script does atomic temp+rename writes, `fcntl.flock(LOCK_EX | LOCK_NB)` to prevent stampedes, per-target `try/except` so one broken applier doesn't break the rest, and `{{key}}` template substitution from `theme.json` for starship and rofi templates in `scripts/themes/templates/`. `atomic_write` calls `path.resolve()` before renaming so writing through a stow symlink (e.g. `~/.config/starship.toml`) preserves the link. Trade-off: ~30ms Python startup vs bash, fine for an interactive switch.

---

## Shell architecture (Quickshell)

### [2026-04-21] Desktop shell: build our own Quickshell, not fork

Considered forking Noctalia (MangoWC support, polished) or AMBXST (feature-rich, Hyprland-only). Build-own won: Material You aesthetic is incompatible with Archeotech's curated theme identity; AMBXST's Hyprland-only IPC would need to be rewritten anyway; the foundation we have (Appearance singleton, MangoWC IPC layer) is sound; reference projects supply *patterns* without dictating the aesthetic.

Steal-from list (source-inspected 2026-05-04):
- end-4: JsonAdapter, FileView hot-reload, lazy component loading
- Noctalia: multi-compositor service facade pattern, MangoWC-specific patterns
- Caelestia: component architecture, theme/wallpaper pipeline, lock-screen QML
- Qylock: lock screen `WlSessionLock` + `PamContext`
- HyDE: theme switching multi-target approach
- DMS: Go daemon scope, template registry

### [2026-05-04] Source-checking rule

Before implementing any workaround for a QML / compositor problem, check how the reference projects solve it. These projects have more QML hours than we do; their fixes are tested at scale. Lookup order: MangoWC → Noctalia; QML patterns → end-4; component architecture → Caelestia; lock screen → Qylock; installation → HyDE/JaKooLit. Full catalog in `.claude/ANALYSIS.md §2`.

### [2026-05-04] MangoWC IPC: `mmsg -w` subprocess stream

MangoWC has no QML bindings; `mmsg -w -O -t -l -c` streams events on stdout, parsed line-by-line via Quickshell `Process` + `SplitParser`. Noctalia uses `Quickshell.DWL` for its MangoWC backend, but `Quickshell.DWL` is **not upstream** — it lives in a custom fork. We stay on `mmsg -w` until or unless DWL lands in Quickshell proper.

Trade-off: subprocess overhead, fragile text parsing, parser re-spec on any `mmsg` output-format change. Worth it for unblocking multi-compositor work without depending on a fork.

### [2026-05-04] MPRIS + Notifications: native Quickshell services

`Quickshell.Services.Mpris` and `Quickshell.Services.Notifications.NotificationServer` instead of `playerctl` polling and `swaync`. Both are first-class D-Bus services, signal-driven, zero subprocess overhead. The reason for using Quickshell at all was one coherent process — external daemons for these undermine that. Confirmed working from end-4 source inspection.

### [2026-05-04] Quickshell layer blur disabled (`blur_layer=0`)

SceneFX `blur_layer=1` causes a white-fringe halo around rounded-corner layer surfaces (bar, popups, OSD) on Intel Xe — landscape outputs only, portrait unaffected. `layerrule = noblur` per-surface did not reliably suppress it. We disabled layer blur globally and rely on high-opacity translucent panels (`glassBg` at 0.96, `glassBgLight` at 0.93) for the glass feel. Window-content blur (`blur=1`) is unaffected.

### [2026-05-04] Go daemon scoped to raw Wayland protocols only

`archeotech-daemon` (Sprint 26) only handles things Quickshell genuinely can't reach: `wlr-output-management` (display layout), `wlr-gamma-control` (night light), `wlr-screencopy` (screenshot). MPRIS, notifications, audio (Pipewire), battery (UPower), network (nmcli), Bluetooth (org.bluez) all stay native QML — they have working native APIs. DMS confirmed this boundary in source. Trade-off: extra binary to build, Go dependency in the project.

### [2026-05-12] Audio backend: `Quickshell.Services.Pipewire` for devices, pactl for volume

PipeWire native bindings for device listing and switching (the right API for that surface — required by `PwObjectTracker` for reactive volume properties); pactl subprocess for the existing volume control (already working, no migration value). All three reference shells (caelestia, end-4, Noctalia) use the same split. Trade-off: a `PwObjectTracker` instance on the active sink/source is mandatory boilerplate.

### [2026-05-12] WiFi radio toggle: `Quickshell.Networking.wifiEnabled`

Native property over `nmcli radio wifi on/off`. Same family of decisions as MPRIS/Pipewire — use Quickshell's native APIs when they exist. Noctalia source-confirmed.

### [2026-05-12] Settings persistence: `Config.qml` singleton + JsonAdapter + dotted keys

Central singleton wraps a single config JSON; components call `Config.get("a.b.c", default)` / `Config.set("a.b.c", val)`. Every setting becomes reactive everywhere with one binding. Write-debounce (50ms) avoids disk thrash on slider drags. end-4 and DMS independently converged on this pattern. Trade-off: keyed by string paths — typos at runtime, not compile-time.

### [2026-05-12] Settings navigation: vertical NavRail (sidebar), not horizontal tabs

Beyond ~6 items, horizontal tabs wrap or truncate; NavRail scales to 34 tabs cleanly (DMS proof point). Caelestia, DMS, and Noctalia all converged on this. Trade-off: wider minimum window (~200px for the rail).

### [2026-05-12] Deep-linking: bar/panel quick actions → Settings pane

`Commons.State.settingsOpenPane = "<name>"` then open the Settings panel (`ShellState.openGlobal("settings")`) from anywhere in the shell focuses the named pane. The bar is the fast path; Settings is the full path — same system. The WiFi popup's "needs password" jumps to Connections; the Appearance switcher's "More" jumps to Appearance.

### [2026-05-19] Bar popups: native QML, not external apps

Bar WiFi/BT icons used to launch `nm-connection-editor` / `blueman-manager`. Replaced with native Shape popups (top-5 networks + adapter toggle inline). External apps break visual cohesion and require separate window management. The popup's full-management action deep-links to Settings → Connections. Trade-off: bar popup capped at 5 entries; power users go to Settings.

### [2026-05-19] busctl monitor fallback: poll on access-denied

`busctl monitor org.bluez` exits with code 1 ("Access denied") in normal user sessions. Original `onExited` unconditionally restarted, creating an infinite crash-loop. Fix: only restart on `code === 0` (clean disconnect); fall back to a 3-second polling `Timer` when monitor is unavailable. Lesson: any auto-restart on subprocess exit must distinguish clean exit from auth/permission failure.

### [2026-06-15] Bluetooth: set Trusted *before* Connect

`connectDevice()` marks the device `Trusted=true` before calling `Connect`. An untrusted audio device brings the ACL link up, then bluez is denied A2DP/HFP profile setup ("avdtp/Hands-Free Connection refused" in bluetoothd) and tears the whole link down — i.e. it "connects then disconnects straight away". Trust authorises the audio profiles and also enables auto-reconnect on power-on / range return. The device model emits **all** tree devices (`{name,address,connected,paired,trusted}`, deduped with `sort -u` because a connected device otherwise appears once per audio sub-object) — the UI filters `.paired` for the paired list and shows unpaired ones under AVAILABLE while scanning.

### [2026-06-15] Bluetooth discovery/pairing needs a persistent agent (`bt-agent.py`)

Scan and pair require a persistent D-Bus connection — a one-shot `busctl` call dies instantly, so discovery can't be held open and pairing has no agent to answer. `scripts/bt-agent.py` is a small dbus-python + GLib `NoInputNoOutput` BlueZ agent: `--scan <secs>` holds discovery open, `--pair <MAC>` does Pair+Trust+Connect. Must be symlinked to `~/.local/bin` (in `install.sh` `LOCAL_SCRIPTS`); `Bluetooth.qml` calls it by name. Trade-off: a Python dependency (dbus-python, PyGObject) for the pairing path.

---

## Shell architecture (sprint 17 onwards)

These decisions are locked. Re-read this section + `claude.md` "Locked architecture decisions" + `ANALYSIS.md §15` before changing them.

### [2026-06-02] Widget registry: Noctalia filename convention, not Caelestia DelegateChooser

Caelestia maps widget id → component via a static `DelegateChooser` (type-safe at compile time, pre-instantiated). Noctalia uses `loader.setSource("Widgets/Bar/" + pascalCase(id) + "Widget.qml", props)` — id resolved to filename. Drop a file under `Widgets/Bar/`, add the id to a `shell-config.json` zone, done. We picked Noctalia because the v1.0 release goal is "drop a folder, get a widget" — Caelestia's pattern would require a registry edit per plugin. The S20 plugin namespace (`plugin:<id>`) is a single conditional in `WidgetRegistry`, not a refactor. Trade-off: async first-mount; `setSource(path, props)` is the only reliable way to satisfy `required` properties on a dynamically-loaded widget.

### [2026-06-02] Widget contract: explicit `barRoot` / `stripRoot` context

Bar/strip widgets receive a `required property var barRoot` (or `stripRoot`) injected via `setSource(path, { barRoot, widgetId })`. The exposed API surface (`side`, `horizontal`, `screen`, `showPopup`, `hidePopup`, …) is documented in `docs/WIDGET_API.md`. This is Noctalia's PluginAPI pattern scaled down. Plugin widgets in S21 use the same `barRoot` reference — same surface, manifest-discovered. Documenting the contract before S21 means plugins don't reshape it. Trade-off: a few `_`-prefixed properties remain on `barRoot` for sibling-coordination state (e.g. mutual-exclusion between popups) — documented but underscore-marked "internal-to-bar, reachable when coordinating".

### [2026-06-15] Bar popups need their own input-mask region

Bar popups (HoverCard/Calendar/WiFi/BT) float *below* the bar, outside the `SideLoader` rect that `ShellSurface`'s input mask covers — so clicks passed straight through to the windows behind. Fix: `Bar.qml` exposes `_anyPopupOpen` + `_popupBounds` (union bounding box of every visible popup, bar-local coords); `ShellSurface.qml` mirrors it into a `_topBarPopupMask` `Region`. Any future bar/popup restructure must preserve this or popups become click-through. Related: `showPopup()` guards `if (_wifiPopupVisible || _btPopupVisible) return` so a hover status card never renders behind a pinned WiFi/BT popup (one popup slot).

### [2026-06-15] Panels are global: open/close affects all screens

A panel (CC-era → now Settings/NC/Launcher/Dashboard/Media/Wallpaper) is open on *every* screen or none — strip icons call `toggleGlobal`, reflect `isOpenAnywhere`, and every close path (Esc, content close, click-outside) calls `closeAllAcross()`. Rationale: opening via the bar gear / IPC was already global, so per-screen strip-icon open + per-screen close was asymmetric — exiting on one screen left the panel open on the others. Trade-off: you can't show a panel on only one screen; acceptable for a single-user multi-monitor desktop where the panels are modal-ish.

### [2026-06-11] Dissolve Control Center; Settings is a unified side panel

Removed the catch-all Control Center entirely and distributed its functions to where they already half-lived: the **bar** is the quick-action surface (volume/mic/brightness/network/BT/battery/power each already have icons + popups), **Settings** is the deep-config surface, and focused tools get their own panels. The WiFi network list was implemented in *three* places (bar `WifiPopup`, CC, `ConnectionsPane`) — CC was pure redundancy. Settings stops being a `FloatingWindow` and becomes a `PanelRegistry` panel on the **right** strip (where CC was; spatially matches the top-right gear), sharing the glass/animation/`ShellState` single-open model with every other panel. The media player became a standalone bottom-strip `MediaPanel`; DND moved into the Notifications header. Trade-off: opening Settings is now a large right-edge drawer rather than a movable/resizable window — accepted for full coherence with the locked one-ShellSurface architecture. Supersedes the prior "Settings: standalone window" and "CC = quick-access only" decisions.

### [2026-06-11] One Appearance home; bottom panel = compact Appearance switcher

Theme + wallpaper + logo were split across surfaces (theme in a Settings pane, wallpaper in a standalone bottom panel) and couldn't reach each other. Unified into one canonical **Settings → Appearance** pane (theme cards + wallpaper carousel + logos + typography + geometry). The bottom `Super+W` panel is now a compact **Appearance quick-switcher** (theme + wallpaper + logo) rather than wallpaper-only, so both surfaces show the same thing and the quick panel isn't missing colors. No duplicated logic: the theme grid and wallpaper/logo UI are extracted into shared `Widgets/Appearance/ThemeGridBody.qml` + `WallpaperPickerBody.qml`, hosted by both the pane (`embedded: true`, fixed-height carousel) and the panel (full chrome, fill-height carousel). The panel id stays `wallpaper` (keeps the `Super+W` keybind + IPC) but the strip icon reads "Appearance" (palette glyph). Supersedes "Wallpaper picker as first-class panel, not Settings pane".

### [2026-06-02] Launcher pinned apps live in Persistence.Config, not shell-config.json

User-editable UI state (pins, toggles, sliders) belongs in `Persistence.Config` (`~/.config/archeotech/config.json`) so the UI can write to it directly. `shell-config.json` is for *architectural* config (side types, widget zones, layout). The launcher first stored pins in `shell-config.json` — wrong layer, since editing JSON from QML risks corrupting the structural config. Moved to `Persistence.Config` with a defaults seed (`["kitty", "zen", "code", "obsidian"]`) returned by `get()` when nothing's persisted yet. Pin/unpin buttons in the list rows + recents tiles write through `Persistence.Config.set()`. Same rule will apply to future per-user state (favourites, custom shortcuts, etc.).

### [2026-06-03] Edit mode writes `shell-config.json` from QML (refines the rule above)

Sprint 21's visual builder makes `ShellConfig` writeable — `setSideType`/`setZoneWidgets`/`setStripIcons`. This is not a contradiction of the launcher-pins decision: the distinction isn't "QML must never write structural config", it's *which* surface owns it. The edit-mode builder is the deliberate, sole owner of side/zone structure, so it's the right place to write it. Corruption risk is avoided by always full-rewriting from a deep clone of `ShellConfig.data` (mirroring `Persistence.Config`'s clone→reassign→serialize), never partial-mutating the file. The write path reuses the existing hot-reload: the FileView watch re-parses our own write and the live `Bar`/`Strip` re-sync via `onDataChanged` — so the editor never touches live widget items. Ad-hoc per-user state (pins, toggles) still belongs in `Persistence.Config`, not here.

### [2026-06-03] Edit overlay edits an abstract config map, not live Bar/Strip items

`EditOverlay` reads `ShellConfig` and renders its own abstract representation of the four edges (type switcher + zone chip rows). It deliberately does **not** reach into the live `Bar`/`Strip` instances to manipulate them. Rationale: the live-reconfigure machinery already exists (write config → hot-reload → re-sync), so the editor only needs to write the file and watch the real shell update underneath the dimmed overlay. Decoupling the editor from rendering internals keeps it robust to Bar/Strip refactors and avoids cross-window drag (unreliable on Wayland — `ANALYSIS.md` line 2092); intra-window drag-and-drop is a later enhancement (backlog).

### [2026-06-03] `holder` side type = `Strip` in holderMode, not a new component

A fourth side type, `holder` (hidden widget container, revealed on hover/shortcut), reuses `Strip` with a `holderMode` flag rather than a bespoke component. In holder mode the resting body is `visible: false` and `sideGap` returns 0 (no `exclusiveZone`, no `CornerBlend`), leaving only a thin edge-width hover-catch; the popup card attaches flush to the screen edge (`_edgeInset: 0`) instead of inset by the collapsed strip body. Trade-off: `Strip.qml` carries a little extra conditional logic, but the card/icon/panel behaviour is otherwise identical so there's no duplicated geometry to keep in sync.

### [2026-06-03] Module discovery: Process+jq scan, rescan-on-open; lowercase `modules/` dir

`ModuleRegistry` (Sprint 21 Chunk 2) discovers community modules with the codebase's standard `Process`+`jq` scan idiom (one compact JSON object per `module.json`, each tagged with its absolute dir) rather than `FolderListModel` — consistent with `ActiveProjects` and avoids an extra QML import surface. Two roots: repo-tracked `~/.config/quickshell/modules/` and user `~/.local/share/archeotech/modules/`. Note the **lowercase** `modules/` — deliberately distinct from the PascalCase `Modules/` (the shell's internal QML tree post-S17) so "installable extension" and "app internals" never blur. Directory-change watching isn't readily available, so discovery re-runs on edit-mode open (cheap, and the only moment freshness matters) instead of a live FileView watcher. Built-in widgets/panels stay in WidgetRegistry/PanelRegistry — modules are strictly the third-party layer.

### [2026-06-03] Plugin panel resolution lives in `Strip`, not `PanelRegistry`

A `panel-content` module's metadata is resolved by `Strip._metaFor` (falls back to `ModuleRegistry` when `PanelRegistry.panelFor` returns undefined) rather than by extending `PanelRegistry`. Reason: `PanelRegistry` would need to import its sibling singleton `ModuleRegistry`, and singleton-to-singleton imports within `Services/Shell` are fragile; `Strip` already imports the services namespace, so the fallback is a no-cost addition there. Plugin panels carry a `contentUrl` (absolute `file://`) instead of a `content` Component, so the strip's content area is split into two mutually-exclusive `Loader`s (one `sourceComponent`, one `source`) — binding both on a single Loader races because Qt treats them as exclusive. A plugin panel is opened by an auto-generated `StripIconBase` icon (the module's glyph), so a module needs no bespoke icon QML.

### [2026-06-03] Frame = one unified `FrameBackground` Shape per screen, not separate per-side bodies + corner pieces

The frame's resting glass is drawn by a single `FrameBackground.qml` per ShellSurface (one `Shape`/`PathSvg`, `WindingFill`), replacing the 4 separate `CornerBlend` Items + the per-side body fills. The driving constraint is **translucent compositing**: the glass is semi-transparent, so any two overlapping pieces double their alpha and show a visible seam — and adjacent sides of *different thickness* (30px bar meeting 10px strip) can't share a clean, dynamically-sized corner when they're separate pieces that must tile edge-to-edge (the corner radius gets locked to the abutment inset, and meeting "at the notch" forces an overlap). Drawing everything as one filled path removes both problems: overlaps merge into one region (single alpha), and the inner-junction fillet radius is free of the layout. Bar/Strip Items became **transparent** containers that only host widgets. Path construction: full-width horizontal bands + vertical bands *between* them (no overlap by design) + concave fillet wedges at active junctions; outer corners round by `corners.radius` in pill mode and stay sharp in framed (a radius-0 SVG arc renders as a `lineto`, so one path serves both); termination ends (neighbour off/holder) cap their inner corner always and outer corner in pill, clamped to half the band thickness. Trade-off: the corner geometry is now JS-computed SVG path strings (less declarative, must rebuild on `ShellConfig.onDataChanged` — binding-through-function tracking proved unreliable, so an explicit `Connections` rebuilds it), and the frame corners are no longer in the input mask (they're decorative — clicks there pass through).

### [2026-06-03] `setSideType` resets `size` to the type default on every switch

Switching a side strip↔bar resets its `size` (bar→30, strip→10) instead of only seeding when undefined. Without this, a strip (size 10) switched to a bar kept size 10, and since `FrameBackground` sizes each band from `sideGap` (= size), the band never resized — the switch did nothing visible. There is no size editor yet, so sizes are always the type defaults anyway; overriding on switch is correct and idempotent. Zones/icons are still preserved across switches (toggle-back stays non-destructive). Trade-off: a future custom-size feature will need to special-case this.

---

### [2026-06-10] Keep swaylock + make it theme-aware; do NOT build a native lock (Sprint 23 cancelled)

Sprint 23 was scoped as "replace swaylock with a native `WlSessionLock` + `PamContext` QML lock." Built it, then cancelled it before shipping: swaylock is battle-tested and the user is happy with it, and the *only* real gap was that its colors didn't follow theme switches. That gap is closed far more cheaply by adding swaylock as a `theme-switch.py` target (template + stripped-hex applier) than by owning a compositor-level lock surface. A broken `WlSessionLock` locks you out of the session with no in-session recovery (swaylock can't help once ext-session-lock engages) — not worth the risk for theming alone. The native lock's only remaining edges (live widgets on the lock surface, "pure-Quickshell" distribution story) don't justify it. Trade-off: lock UI is still a separate stack (swaylock config) rather than sharing the shell's QML components. The native-lock QML was deleted (recoverable from git/this session if ever wanted). `WlSessionLock` + `PamContext` remain confirmed-working APIs on QS 0.3.0 if revisited.

---

## Wallpaper / logo system

### [2026-02-19] SVG renderer: rsvg-convert for SVG→PNG, ImageMagick for color extraction

ImageMagick's SVG renderer fills transparency with white; `rsvg-convert` (librsvg) preserves alpha correctly. Use rsvg for any SVG→PNG conversion; keep ImageMagick for histogram color extraction and final compositing.

### [2026-04-21] Focus mode dropped permanently

`unfocused_opacity` cannot be re-applied to existing clients on MangoWC `reload_config` — the client opacity is copied per-window at creation time in `createclient()`. There's no IPC dispatch to re-iterate open windows. Until MangoWC adds a `set_opacity` or `reapply_window_rules` IPC, focus mode is impossible. We removed it from the settings hub; `unfocused_opacity` stays at `0.85` (= `focused_opacity`), no dimming distinction. Revisit if/when the upstream IPC lands.

### [2026-06-02] Logo previews: in-memory SVG substitution via FileView + data URI

The original `arch-logo.svg` / `rebel-logo.svg` / `imperial-logo.svg` have `LOGO_COLOR` / `LOGO_OPACITY` placeholders that `wallpaper-set.sh` substitutes at composition time. For the QML preview tiles, three `FileView`s read the originals and `_svgDataUri(text())` does the substitution in-memory, returning `data:image/svg+xml;utf8,...` for `Image.source`. Single source of truth — no committed preview duplicates. Trade-off: tiny per-mount substitution + URI encode; negligible.

### [2026-06-02] Composite cache: per-(wallpaper, logo, orientation), keyed by sha1 of wallpaper path

The original cache was single-slot — one `$COMPOSED_IMG` file + a `$COMPOSED_CACHE` flag storing `<logo>:<wallpaper>`. Switching anything invalidated it and forced a 2-4s re-render. Replaced with `$CACHE_DIR/composed/<sha1>-<logo>-{l,p}.png` files; cache hits are O(1) file existence checks. Background-warm subshell composites the *other* logos for the current wallpaper after every apply, so the next logo switch is cache-hit. `--warm-all` subcommand pre-renders every combination (~167 MB for 16 wallpapers × 3 logos × 2 orientations). Trade-off: disk grows with usage; no automatic cleanup yet (cheap enough on 512 GB).

### [2026-06-24] Zen transparency: compositor opacity + noblur, not app-level ARGB

Zen's *clean* glass (its own premultiplied ARGB surface, like kitty/VSCode) needs the WebRender native compositor, which is **blocklisted on this Intel Xe / Mesa** GPU — force-enabling it throws diamond/star artifacts. So we let **MangoWC** dim the whole window instead (`focused_opacity:0.88/0.75,appid:zen` + `noblur:1,appid:zen`), Zen rendered opaque internally. Trade-off accepted: slightly more washed than the app-level apps (compositor-vs-premultiplied-alpha gap, not config-fixable) but artifact-free. `Super+SHIFT+O` toggles opaque for screen-share. Full diagnosis + revisit-trigger (Mesa lifting the blocklist) in `TROUBLESHOOTING.md`.

### [2026-07-01] Roadmap re-sequenced: extensibility/plugins before portability

After a distribution-readiness audit vs the inspiration repos, reordered the path to v1.0. Was: 26 multi-compositor → 27 distribution. Now: **26 Widget Extensibility & Plugin Manager → 27 Dev Workflow Official Plugin → 28 Distribution/v1.0**, with multi-compositor + Go daemon pushed *behind* v1.0. Rationale: the product differentiator is "everything super-customizable + a plugin ecosystem," and per-instance widget config (`configSchema` is declared but unconsumed) is the last thing forcing users to hand-edit `shell-config.json`. Multi-compositor is real work but only benefits *other people's machines* (Hyprland is already the tested backup), so it's genuinely "later." Dev-workflow tooling becomes the first **official plugin** (Obsidian model) rather than core — dogfoods the plugin API and keeps niche TF/AWS tooling out of the default install.

### [2026-07-01] Per-instance widget config: read-time shim, not a migration; JSON-string in ListModel; config in edit mode, not a defaults layer

Sprint 26 made `configSchema` consumed. Zone/strip entries became `{id, config}` objects, but the shim (`ShellConfig._normEntry`) normalizes **on read** so old bare-string `shell-config.json` files load unchanged — no migration script, no version bump. Config rides through `Bar._syncZone`'s stable `ListModel` as a **JSON string** (`configJson`), not a nested object role: ListModel mangles nested object/array roles, and a string is trivially diffable + updatable in place (`setProperty`), which is what lets an instance's config edit *not* reload the live widget. Rows are keyed on `id + "#" + occurrence` so two same-id widgets (two clocks) keep distinct delegates. Config is edited per-instance from the edit-mode chip gear; there is deliberately **no global-default layer** for built-ins (YAGNI — the schema `default` covers unset fields, and a defaults store would need its own persistence + merge order). Trade-off: reordering two identical-id widgets recreates the moved delegate (occurrence changes); cheap.

### [2026-07-01] External plugins read an injected `appearance`, not `import Commons`

Quickshell's `qs.Commons` module import (and the deprecated `root:/` scheme) only resolve for files **inside** the config tree; a module loaded from `~/.local/share/archeotech/modules/` via absolute `file://` cannot import the shell's tokens by any prefix (confirmed against QS 0.3.0 docs). Rather than symlink external modules into the stow-managed config tree (pollutes the repo, needs a rescan), the loaders inject `Commons.Appearance` as an `appearance` property — but only onto `plugin:` widgets that declare it, via the strict-safe `'x' in item` `onLoaded` guard, so built-ins that `import Commons` are untouched. Trade-off: external authors use `appearance.colors.x` instead of the familiar `import`; shell *services* beyond theme tokens are still not exposed to external modules. **Correction (2026-07-02):** this applies to *bundled* modules too — they also load via absolute `file://`, so `import "../../Commons"` fails for them as well (it was throwing `undefined` for the `hello`/`notes` examples). All modules use injected `appearance`; the doc claim that bundled ones can `import Commons` was wrong.

### [2026-07-02] Strip panel state carries a `side`; wildcard opens resolve to a primary host

The strip panel-open state was keyed per-screen by panel id only (`{open}`), so the same opener placed on 2+ sides (e.g. `settings` on both strips) opened the panel on *every* hosting strip. Added a `side` to the state (`{open, side}`): a strip shows the panel only when `activeSide === side`, and a strip icon threads its own side through `toggleGlobal`. Bar/IPC openers have no side → wildcard `""`, which each strip resolves to a single **primary host** (first side in a fixed priority order whose config lists the panel), so the gear/shortcut also open exactly one. Kept in `Strip`/`ShellState`, no `ShellState`→`ShellConfig` coupling.

### [2026-07-02] Bars host panels via a shared `PanelHost`; `BarPanel` reuses the strip's neck Shape

Panels were renderable only inside `Strip.qml`'s card, so a bar could toggle a panel but not show one. Extracted the panel logic (meta resolution + content loaders + size targets) into a holder-agnostic `PanelHost` kernel, and gave the bar a `BarPanel` that drops from the bar edge anchored to the clicked opener. `BarPanel` deliberately reuses the **exact neck `Shape` geometry** from the strip card (concave arcs at the attached edge, convex far corners) rather than a rounded `Rectangle` — a floating rounded card read as detached/incoherent; the neck fuses it into the bar like every other panel. Panel openers on a bar are **direct widgets** (`dashboard`/`launcher`/`wallpaper`, panel = the widget id) with no hover popup and no config step — a bar opener behaves like a strip icon (click → open), not a tooltip'd generic. `PanelOpenerWidget` passes its bar's `side` to `ShellState`, so the panel resolves to that bar (not a strip's primary host). Trade-off: `Strip.qml` keeps its own inline copy of the panel logic for now (it's freshly polished; converging it onto `PanelHost` is deferred to phase 4) — two copies until then. Also generalised `ShellSurface`'s bar-popup input mask from top-only to all four sides so a bar panel is clickable and click-outside doesn't self-dismiss it. Phases 0–2 of the holder-unification (ROADMAP S26 follow-up C); 3 (one per-side `content` list) and 4 (`holderRoot` contract) remain.

### [2026-07-02] Layered Shapes eat input — use `Shape.CurveRenderer` for AA, not `layer.enabled`

The strip popup card set `layer.enabled: true` (for MSAA on its `ShapePath`). Symptom: the card jittered on hover — the strip-level `MouseArea` never received hover at all, and the icons inside the layered card flipped hover in lockstep with the card's size, a feedback loop that made the popup oscillate open/closed. Root cause: a layered item renders to an offscreen texture and its input hit-testing misbehaves in size-dependent ways, swallowing/mis-mapping hover for itself and children. Fix: drop the layer, use `preferredRendererType: Shape.CurveRenderer` (Qt's native curve AA, no offscreen texture) — smooth edges *and* correct hit-testing. **Rule for the polish work: never wrap interactive content in a `layer.enabled` item; antialiase Shapes with CurveRenderer.** (`HoverCard.qml` still uses a layer but hosts no interactive children, so it's unaffected — revisit if it ever does.)

### [2026-07-03] Unified per-side `content` list: one canonical model, derived legacy views, round-trip via co-resident align flavours (S26-C phase 3)

Merged the bar `zones{left,center,right}` and strip `icons[]` into one ordered `content: [{ id, config, align }]` per side — `align` is the bar zone, `""` the strip icon list. `ShellConfig._sideContent` is the read-time shim (reads `content`, else flattens old `zones`/`icons`), so old files load untouched; mutators write `content`, converting a side on its first GUI edit (no migration, mixed formats coexist in one file forever). Kept `zoneEntries`/`stripEntries`/`zoneWidgets`/`stripIcons` as **derived views** (filter by align) so Bar/Strip/EditOverlay didn't move in phase 3 — the render code migrated in phase 4. The subtle call: a bar↔strip type flip must stay non-destructive, but the old design relied on the side object carrying **both** `zones` and `icons`. Replicated that in one list by letting entries of both flavours co-reside (align `L/C/R` **and** `""`), each renderer reading only its own align; `setSideType` seeds the target flavour only when empty and never deletes the other, so round-trips don't lose or duplicate widgets. Also unified the two `WidgetRegistry` catalogues into one `availableWidgets` with `{bar,strip}` caps (old arrays = filtered views). Verified the mutation logic with a standalone JS port (shim read, zone isolation, round-trip, per-align config indexing) before any live reload.

### [2026-07-03] One `holderRoot` contract; `BarPill` absorbs `StripIconBase`; one `WidgetLoader`; Strip shares `PanelHost` (S26-C phase 4)

Replaced the split `barRoot`/`stripRoot` widget contexts with a single `holderRoot` superset that both Bar and Strip expose (side/horizontal/type/screen/screenName/thickness + `togglePanel`/`showsPanel`/`dismissPopups`/`iconHover*`/`showPopup`&friends) — each holder implements its half and **stubs the other's** (a strip no-ops `dismissPopups`/`showPopup`; a bar no-ops the hover-reveal hooks), so one widget runs on any side and calls only contract methods, never `ShellState` or internal popup props directly. Folded `StripIconBase` into `BarPill` (added an optional active/hover highlight bg) and **deleted all 6 strip wrapper files** + the whole `Widgets/Strip/` dir — `PanelOpenerWidget` is now the one holder-aware opener (flat pill on a bar, filled highlighted cell on a strip, glyph from the unified catalogue or an injected plugin glyph). Merged `BarWidgetLoader`+`StripWidgetLoader` into one `WidgetLoader` (+ `WidgetRegistry.widgetFile(id, isStrip)`), and renamed `barRoot`/`stripRoot`→`holderRoot` shell-wide incl. the bundled `hello` example. Strip now mounts panels through the shared `PanelHost` kernel (its inline meta+loader+ready copy deleted — the deferred phase-1 convergence). Gotcha found on reload: the strip `showsPanel(id)` wrapper initially returned `_showsPanel(id)` (side/primary-host routing only), so **every** opener on an active side highlighted — fixed to `_activePanel === id && _showsPanel(id)`, matching the bar's semantics ("`id` **is** the active panel here"). Kept Strip's own card geometry/clustering/hover-reveal (holder-specific chrome) — only the panel-mount converged. Docs (WIDGET/PANEL/MODULE_API) rewritten for the unified contract.

### [2026-07-03] Lock screen: swaylock-effects → upstream swaylock (interim) → hyprlock (planned)

Diagnosed a recurring resume freeze (gray screen + cursor, force-restart only) as **swaylock segfaulting on resume** — 3 coredumps, identical stack in `wl_display_dispatch_queue` (a Wayland event callback), triggered when the locker is active across suspend and an output changes on resume (lid close→open removes+re-adds the internal panel). Verified this is (a) **unmaintained** — `swaylock-effects` (jirutka's fork, and the whole mortie→jirutka chain) is dead, no upstream fix; (b) a **known, longstanding sway-ecosystem bug** affecting even plain swaylock/sway (swaylock #90, sway #6395/#2626, wlroots #2145), i.e. output-hotplug-during-resume fragility, not a config error. Patching a custom build of abandoned C code was rejected (bad for a repo heading to distribution). **Interim:** swapped to upstream `swaylock` 1.8.5 (maintained; normal locking verified under MangoWC) and de-effected the config + its theme-switch template, since upstream errors on the fork's options (`clock`/`effect-*`/`grace*`/`fade-in`, and bare `indicator` → `indicator-idle-visible`) — cost: lost blur/clock, brief grey pre-wallpaper flash, same fragile lineage. **Real fix (shipped 2026-07-08):** hyprlock — a separate, actively-maintained codebase (not the sway lineage) that restores blur + clock; see the `[2026-07-08]` entry below. **Process note:** during diagnosis I twice asserted wrong causes from memory and once locked the user's live screen with a mis-scoped test — lesson: for anything touching the running display, hand the user the command; verify claims against logs/sources before stating them.

### [2026-07-08] Lock screen: shipped the hyprlock migration — generated config (like swaylock's), "Console" layout, helper-script dynamic labels

Completed the swaylock → hyprlock migration planned on 2026-07-03. hyprlock replaced swaylock on every trigger (`Super+L`, swayidle idle + before-sleep, wlogout); swaylock is **kept as a documented fallback** (not removed — de-risks the *intermittent* resume case until hyprlock has many cycles of daily use). Verified across suspend/resume + dock/undock in initial testing.

Mechanics deliberately mirror the swaylock approach so nothing new was invented: `~/.config/hypr/hyprlock.conf` is generated by `theme-switch.py` from `scripts/themes/templates/hyprlock.conf.tmpl` (stripped-hex color vars wrapped in hyprlang `rgb()`/`rgba()`), so the lock re-themes on every switch. The wallpaper is indirected through a stable `~/.cache/wallpaper/current` symlink (maintained by `wallpaper-set.sh`) because hyprlock's `background { path }` is static. The two label commands that hyprlang can't safely inline (`$(...)`/`#` get mangled) live in `scripts/hyprlock-info.sh` (bottom status bar + rotating phrase) — the rule: keep `cmd[update:N]` label logic in a testable script, not the config.

**Design ("Console" layout, settled with the user over several iterations):** no card; a thin oversized FiraCode-Light clock (a *light weight of the theme's own font* — a true light sans wasn't installed and a missing font falls back ugly *on the lock*, which can't be previewed safely); date; a rotating dev/inspiration phrase; an understated **boxless** input (transparent field + a thin lavender underline `shape`, no placeholder — the user liked swaylock's boxless feel); and one quiet bottom status bar (`user · layout · battery · uptime`; layout via `mmsg -g -k`, so MangoWC-only — degrades gracefully on the Hyprland fallback). **Auth feedback:** the verify state is transparent (no color flash — hyprlock's default green "checking" flash was disliked, and it's shown on *every* submit, not just failures); failure is a soft translucent-red wash + `Wrong — N` text (a solid red fill read as "too boxy"). The slow wrong-password response is **PAM's `pam_unix` fail-delay** (~2 s, system-wide anti-brute-force in `/etc/pam.d/system-auth`), left as the safe default — not a hyprlock issue and not weakened for a repo heading to distribution.

**Follow-up (ROADMAP Feature Backlog):** a "Lock Screen" Settings pane that regenerates `hyprlock.conf` from a config model (toggle/arrange elements, phone-lockscreen feel). hyprlock is a separate process with no live QML/IPC, so it's a **config generator**, not QML widgets on the lock surface — and today's template becomes the default preset.

---

## Process & methodology

### [2025-11-28] Dual-boot to Arch-only

(Historical — Fedora removed 2026-04-20.) The previous setup kept Fedora alongside Arch for system recovery. Decision was to remove it once Arch had snapshot-based recovery (snapper + snap-pac + grub-btrfs). Recovered an extra 265GB for games (now nvme0n1p7). Recovery falls back to Arch live USB if needed.

---

**Last Updated:** 2026-07-08 (hyprlock lock-screen migration)
**Total Decisions:** 38 (post-cleanup; previous file held 60 entries, dropped tactical/superseded/in-code items)
