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

### [2026-05-12] Settings: standalone window, not CC-embedded

CC is for quick toggles; Settings is the long-form panel. Tried caelestia's "CC is settings" model on paper but retrofitting our CC would require gutting it. With deep-linking (`Commons.State.settingsOpenPane = "appearance"; settingsVisible = true`) the two surfaces feel like one system anyway. Trade-off: two QML surfaces to maintain.

### [2026-05-12] Settings persistence: `Config.qml` singleton + JsonAdapter + dotted keys

Central singleton wraps a single config JSON; components call `Config.get("a.b.c", default)` / `Config.set("a.b.c", val)`. Every setting becomes reactive everywhere with one binding. Write-debounce (50ms) avoids disk thrash on slider drags. end-4 and DMS independently converged on this pattern. Trade-off: keyed by string paths — typos at runtime, not compile-time.

### [2026-05-12] Settings navigation: vertical NavRail (sidebar), not horizontal tabs

Beyond ~6 items, horizontal tabs wrap or truncate; NavRail scales to 34 tabs cleanly (DMS proof point). Caelestia, DMS, and Noctalia all converged on this. Trade-off: wider minimum window (~200px for the rail).

### [2026-05-12] CC compound pills (split toggle + expand)

WiFi and Bluetooth CC rows need both a quick toggle (common) and a details expansion (less common). One full-row click for both is ambiguous. Compound pill = left ~48px tile toggles, right body expands. DMS pattern, independently derived. Trade-off: more complex layout than a single RowLayout.

### [2026-05-12] Deep-linking: CC quick actions → Settings pane

`Commons.State.settingsOpenPane = "<name>"` + `settingsVisible = true` from anywhere in the shell opens the Settings window with the named pane focused. Without this, CC and Settings feel disconnected. With it, the CC is the fast path and Settings is the full path — same system. WallpaperPicker's palette button uses the same mechanism (jumps to Appearance).

### [2026-05-19] Bar popups: native QML, not external apps

Bar WiFi/BT icons used to launch `nm-connection-editor` / `blueman-manager`. Replaced with native Shape popups (top-5 networks + adapter toggle inline). External apps break visual cohesion and require separate window management. "Open Settings" deep-links into CC. Trade-off: bar popup capped at 5 entries; power users go to CC.

### [2026-05-19] busctl monitor fallback: poll on access-denied

`busctl monitor org.bluez` exits with code 1 ("Access denied") in normal user sessions. Original `onExited` unconditionally restarted, creating an infinite crash-loop. Fix: only restart on `code === 0` (clean disconnect); fall back to a 3-second polling `Timer` when monitor is unavailable. Lesson: any auto-restart on subprocess exit must distinguish clean exit from auth/permission failure.

---

## Shell architecture (sprint 17 onwards)

These decisions are locked. Re-read this section + `claude.md` "Locked architecture decisions" + `ANALYSIS.md §15` before changing them.

### [2026-06-02] Widget registry: Noctalia filename convention, not Caelestia DelegateChooser

Caelestia maps widget id → component via a static `DelegateChooser` (type-safe at compile time, pre-instantiated). Noctalia uses `loader.setSource("Widgets/Bar/" + pascalCase(id) + "Widget.qml", props)` — id resolved to filename. Drop a file under `Widgets/Bar/`, add the id to a `shell-config.json` zone, done. We picked Noctalia because the v1.0 release goal is "drop a folder, get a widget" — Caelestia's pattern would require a registry edit per plugin. The S20 plugin namespace (`plugin:<id>`) is a single conditional in `WidgetRegistry`, not a refactor. Trade-off: async first-mount; `setSource(path, props)` is the only reliable way to satisfy `required` properties on a dynamically-loaded widget.

### [2026-06-02] Widget contract: explicit `barRoot` / `stripRoot` context

Bar/strip widgets receive a `required property var barRoot` (or `stripRoot`) injected via `setSource(path, { barRoot, widgetId })`. The exposed API surface (`side`, `horizontal`, `screen`, `showPopup`, `hidePopup`, …) is documented in `docs/WIDGET_API.md`. This is Noctalia's PluginAPI pattern scaled down. Plugin widgets in S21 use the same `barRoot` reference — same surface, manifest-discovered. Documenting the contract before S21 means plugins don't reshape it. Trade-off: a few `_`-prefixed properties remain on `barRoot` for sibling-coordination state (e.g. mutual-exclusion between popups) — documented but underscore-marked "internal-to-bar, reachable when coordinating".

### [2026-06-02] Wallpaper picker as first-class panel, not Settings pane

WallpaperPicker lives in `PanelRegistry` as a strip panel (bottom strip, sibling to `dashboard`), not as a Settings tab. Noctalia pattern; DMS does it as a tab and it's the wrong feel (Settings is a long-lived window). Wallpaper picking is frequent and wants anchor-to-bar positioning + per-monitor instance. Logo selector lives in the same panel — contextually tied. The palette icon in the panel header deep-links to Settings → Appearance when the user wants theme picking instead. Trade-off: the strip panel still grows to full screen axis (Sprint 17 architecture) — Sprint 20's `axisSize` field fixes this.

### [2026-06-02] CC = quick-access only; long settings live in Settings panes

After the S20 trim, ControlCenter holds: Status strip, MEDIA, AUDIO, CONNECTIVITY (WiFi/BT/VPN), Display Layout (kept after user feedback — used often), DND toggle, Power/Lock. Night Light, Power Profile, Idle & Sleep moved to new `DisplayPane` + `PowerPane` (anticipating Sprint 23). The principle: a CC item earns its slot if it's a fast quick-toggle the user reaches for repeatedly; anything that's a multi-step configuration belongs in Settings. Display Layout sits on the line — kept in CC because docking/undocking happens often enough that an extra two clicks would hurt. Trade-off: CC's `displayLayout` and DisplayPane's `displayLayout` are independent caches (neither reads compositor state) so they can drift visually; cheap to fix later with a shared singleton if it matters.

### [2026-06-02] Launcher pinned apps live in Persistence.Config, not shell-config.json

User-editable UI state (pins, toggles, sliders) belongs in `Persistence.Config` (`~/.config/archeotech/config.json`) so the UI can write to it directly. `shell-config.json` is for *architectural* config (side types, widget zones, layout). The launcher first stored pins in `shell-config.json` — wrong layer, since editing JSON from QML risks corrupting the structural config. Moved to `Persistence.Config` with a defaults seed (`["kitty", "zen", "code", "obsidian"]`) returned by `get()` when nothing's persisted yet. Pin/unpin buttons in the list rows + recents tiles write through `Persistence.Config.set()`. Same rule will apply to future per-user state (favourites, custom shortcuts, etc.).

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

---

## Process & methodology

### [2025-11-28] Dual-boot to Arch-only

(Historical — Fedora removed 2026-04-20.) The previous setup kept Fedora alongside Arch for system recovery. Decision was to remove it once Arch had snapshot-based recovery (snapper + snap-pac + grub-btrfs). Recovered an extra 265GB for games (now nvme0n1p7). Recovery falls back to Arch live USB if needed.

---

**Last Updated:** 2026-06-02
**Total Decisions:** 36 (post-cleanup; previous file held 60 entries, dropped tactical/superseded/in-code items)
