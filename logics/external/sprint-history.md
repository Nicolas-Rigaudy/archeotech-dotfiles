# Archeotech shell — condensed sprint history (archived)

_Condensed reference migrated from `.claude/ROADMAP.md`; source of truth is now `logics/`._

## Sprint timeline

- **Sprints 0-3 (May 2026)** — Foundation: dead-file cleanup + clock fix, directory restructure (Commons/Services/Modules/Widgets), MangoWC service hardening (per-output state, backoff restart), and partial service-quality work (BT signals, error logging, CC state-sync); some S3 items blocked on Quickshell 0.3.0.
- **Sprints 4-5** — Bar polish + MPRIS (marquee, media card, popup redesign, spring easing) and a polish pass (Anim.* tokens, CC collapsibles, flickable + bell fixes).
- **Sprint 6 (+6/7)** — Notification system (server, toasts, history panel, bell badge) plus bar hover popups on all elements and a clock-hover calendar popup.
- **Sprint 7** — Launcher: DesktopEntries, weighted fuzzy + frecency, keyboard nav, centered glass panel.
- **Sprints 8-10** — Connectivity: native Bluetooth (org.bluez D-Bus), native WiFi + bar popups (inline password, scan), and audio sinks + VPN (pactl selector, nmcli monitor).
- **Sprints 11-13** — Settings window (FloatingWindow, Config/Persistent singletons, 6 panes); theme system (ThemeLoader hot-reload, JSON themes, theme-switch.sh); 5 new themes (Dracula/Nord/Gruvbox/Tokyo Night/Monochrome) + symlinked theme dirs.
- **Sprints 14-15** — Mission Dashboard (full-screen overlay: system status, projects, notes, quick launch, tips) and the Drawer Surface (DrawerConfig.json edge→panel mapping, single PanelWindow, edge hover zones).
- **Sprints 16-17** — Perimeter frame layout (flush bar, equal edge gaps) then the Unified Shell Surface (one ShellSurface per monitor, corner blends, panels as content modules; -3700 LOC).
- **Sprint 18** — Configurable Sides + Widget Registry (drop-a-file convention, async widget loaders, primitives moved, WIDGET_API.md; Bar.qml 1537→299 LOC).
- **Sprints 19-20** — System-wide theme switcher + WallpaperPicker (theme-switch.py Caelestia rewrite across 8 targets, card-grid AppearancePane, THEME_SPEC.md) and a Panel Redesign & Polish pass (PanelRegistry axisSize, CC dissolved into Display/Power panes, launcher pinning, wallpaper cache overhaul).
- **Sprint 21** — Module Builder & Community Extension (Chunks 0-2): ShellConfig write-back mutators, edit-mode overlay + widget palette, holder side type, ModuleRegistry scan, plugin:<id> routing, example modules, MODULE_API.md (Chunk 3 desktop widgets deferred).
- **Sprint 22** — Adaptive Shell Frame: single FrameBackground Shape per screen, dynamic rounded inner corners, Framed↔Pill toggle.
- **Sprint 23 — CANCELLED** — Built then reverted a native WlSessionLock/PamContext lock; kept swaylock and made it theme-aware instead.
- **Sprint 24** — Settings Depth + IA restructure: dissolved Control Center, unified right-strip Settings card, audio aliasing, settings search, Connections tabs (WiFi/BT pair/trust), UX pass.
- **Sprint 25** — Hierarchical Theming (family→flavor→accent): refactored ColorScheme, Dark/Light/Auto + day-night schedule, light flavors for all 6 families, Catppuccin accent picker, Zen translucency settled at compositor-opacity + noblur.
- **Locker (post-S25)** — hyprlock replaced swaylock (fixes resume-freeze segfault, restores blur; swaylock kept as fallback).
- **Repo split (pre-30 foundation)** — Split into public `archeotech-shell` and private `archeotech-dotfiles`; 9 boundary fixes (portable paths, config-driven scan roots, output auto-detect); public ships shell + themes + docs + examples.

## Shipped so far (design polish, as of 2026-07-20)

- Launcher polish (StateLayer hover, warmth, depth, two-line rows) set as the quality bar.
- Chrome liquid-glass sheen (vertical gradient on frame/cards/OSD/popups) + strip-card window-space seam fix.
- Dashboard rework (hero + bento, DashCard shell, warm translucent surfaceCard) and shared card style unified on surfaceCard.
- Notifications redesign (glass sheen, surfaceCard rows, two-line layout, StateLayer buttons, trash-can clear-all + root-cause fix).
- Round 3 Settings redesign onto shared GlassButton/SettingsCard/3D toggle/stat-bar slider.
- Accent swatches raised to 3D dots (sibling shadow, top-lit sphere gradient, hover/press pulse).
- Flat-mode toggle (Appearance.flatMode + shadowStrength tokens; default glass, per-surface as migrated); NEXT: Edit Layout buttons + full Settings design pass.
