## item_134_settings_audit_fake_controls_missing_settings - Settings audit: fake controls, missing settings, per-pane gaps
> From version: 1.0.0
> Schema version: 1.0
> Status: Ready
> Understanding: 90%
> Confidence: 85%
> Progress: 0%
> Complexity: Medium
> Theme: Settings
> Reminder: Update status/understanding/confidence/progress and linked request/task references when you edit this doc.

# AI Context
- Summary: 2026-09-29 audit of the 9 Settings panes (Appearance, Shell, Display, Notifications, Connections, Audio, Plugins, Power, About): every control traced to what it drives, config keys written vs read, and settings the shell supports but Settings does not expose. Two more fake controls, one wrong-state selector, and a candidate list of missing settings for the owner to pick from.
- Keywords: settings, audit, fake toggle, config keys, display, audio, missing settings
- Use when: Deciding what Settings should contain, or fixing the defects below.
- Skip when: Working on theme token internals (item_110) beyond the scales noted here.

# Problem
Method: every row (ToggleRow/SliderRow/ButtonGroupRow/SegmentedControl/ConfigForm/TextField) extracted per pane with its action; every `Config.set` key from Settings checked for a reader outside Settings; every `Config.get` key checked for a Settings writer.

Defects (design rule 6, no fake toggles):
- Audio -> "Remember volume on restart" writes `audio.rememberVolume`; nothing reads it (no restore code anywhere).
- Display -> "Layout" (extend/mirror/laptop/external) is fire-and-forget `wlr-randr`: `displayLayout` starts at "extend" and is never read back, so after a restart it shows extend whatever the outputs are.
- Display -> "extend" places EVERY external at 1920,0: with the work setup (eDP-1 + HDMI-A-1 + portrait DP-3) the two externals overlap. Monitor arrangement belongs to mango monitor rules / kanshi-style profiles, not a 4-mode guess.
- Already fixed today: Font Size Scale / Corner Rounding / Padding Scale (unread keys, removed 3376354).

Verified real: pack selector, pack settings form, flat mode, Zen restart, theme picker (ColorSchemeBody: family/flavor/accent/light-dark schedule), toast duration/max/fullscreen/DND persistence, pill frame, corner radius, outer gap (shell-config.json), scroller width (applied to mango via timer; the config key only remembers the value), System Notes selection, power profile, idle dim/lock/sleep (read back from swayidle.conf), night light (read back from the wlsunset pid), per-sink alias and max volume, plugin enable/disable.

Stale keys: `bar.clockFormat` and `bar.height` exist in config.json but nothing reads them (bar height comes from theme tokens).

Supported but hand-edit only (no UI):
- `bar.modules.{battery,bluetooth,music,wifi}` widget options (read by the bar widgets).
- `dashboard.scanRoots` (Active Projects scan directories).

Comparison with the reference shells (2026-09-29, shallow clones at HEAD: DankMaterialShell 2026-09-29, caelestia 2026-09-27, end-4 ii 2026-09-28, Noctalia 2026-09-29 - now a native C++ rewrite, no longer QML). Y = in its settings UI, cfg = config-file only, - = absent.

| Area | Archeotech | DMS | Caelestia | end-4 | Noctalia |
|---|---|---|---|---|---|
| Theme, palette, dark/light schedule | Y | Y | mode only | Y | Y |
| Font family, UI scale, radius, animation speed, reduced motion | - (fake sliders removed) | Y | cfg (tokens file) | fonts | Y |
| Opacity, borders, shadows | flat mode | Y | transparency | transparency | Y |
| Bar layout / per-widget options | edit mode; widget options cfg | Y, multi-bar | Y | Y | Y, per-bar + per-monitor |
| Clock / date format | - | Y | Y | Y | Y |
| Launcher (prefixes, fuzzy, hidden, pinned) | - | Y | Y | prefixes | Y |
| Notifications: position, history, per-app rules | - (timeout/max/fullscreen/DND only) | Y | groups, toast events | timeout, monitor | Y |
| OSD: position, which kinds | - | Y | cfg | timeout | Y |
| Display arrangement, scale, refresh, rotation, profiles | broken 4-mode | Y + profiles | - | - | - |
| Night light schedule | fixed temperature | Y | - | cfg | Y |
| Keyboard layout, mouse, touchpad | - | Y | - | - | layout labels |
| Keybind editor | - | Y | - | cheatsheet | shell nav keys |
| Idle / power profile | Y | Y + AC/battery split | cfg | - | Y (rules) |
| Battery warn level, charge limit | - | Y | cfg | Y | warn level |
| Lock screen | - | Y | cfg | Y | Y |
| Default apps | - | Y | Y | cfg | launch cmd |
| Language / locale, weather location | - | Y | Y | Y | Y |
| Wallpaper (per-monitor, cycling) | Y | Y | Y | Y | Y |
| Plugins | Y | Y + registry | placeholder | - | Y + store |

Settings UX practices seen:
- Search: DMS and Noctalia search every row (jump + highlight); Archeotech searches panes by keyword (PaneRegistry); caelestia's search is a stub; end-4 has none.
- Reset to default per row: DMS (reset icon when value != default), Noctalia (reset + confirm, reset page; UI edits live in a separate override file so reset = delete). Archeotech: none.
- Capability gating: DMS/Noctalia hide panes/rows whose backend is missing (compositor, ddcutil, gamma, battery); Archeotech's Power pane shows them disabled with the reason (keep that: it is more honest).
- Advanced filter / "More" group: Noctalia, DMS.
- Per-monitor settings: DMS, Noctalia.
- Export config / support report: Noctalia.
- Anti-pattern: caelestia shows "under construction" placeholder pages (conflicts with rule 6).

Candidate additions, ranked for this shell (dev/cloud, multi-monitor, dock/undock):
1. Display done properly: read the real layout back, arrangement for eDP + HDMI + portrait DP-3, scale/refresh/rotation, and saved profiles for work vs home (DMS pattern) - fits the dock/undock workflow.
2. Keyboard: layout (AZERTY built-in / QWERTY external), repeat rate; touchpad natural scroll / tap.
3. Typography and motion: font family, UI scale, animation speed, reduced motion (item_110 scales, item_114).
4. Clock/date format; bar widget options now config-only; dashboard scan roots.
5. Settings infrastructure: per-row reset to default, row-level search.
6. 0.50 overlaps: notifications position/history/rules (item_119), OSD kinds/position (item_120), launcher settings (item_118).
7. Later: lock screen, battery warn level / charge limit, default apps, night-light schedule, locale/weather.
Not worth it here: printers, users/greeter, cellular, hotspot, AI/weeb policies.

# Scope
- In:
  - Fix the two fake/wrong-state controls (remember volume: implement restore or remove; display layout: read real state back, fix extend placement or replace with profiles).
  - Remove or wire the stale keys.
  - Owner-selected subset of the missing settings, each as its own item on the right milestone.
- Out:
  - Implementing all candidates in one item.

# Acceptance criteria
- AC1: No Settings control writes state nothing reads, and every selector shows the real current state after a restart.
- AC2: The owner has picked which missing settings to add; each exists as an item on a milestone.

# AC Traceability
- request-AC2 -> This backlog slice. Proof: AC1: no fake or wrong-state Settings controls.

# Decision framing
- Product framing: Needed (which settings belong in 1.0)
- Architecture framing: Not needed

# Links
- Product brief(s): `prod_003_archeotech_1_0_after_the_2026_09_28_audit`
- Architecture decision(s): (none yet)
- Request: `req_005_2026_09_28_audit_upgrade_program`
- Primary task(s): (none yet)

# Priority
- Priority: High
- Rationale: owner-requested (2026-09-29); two more no-fake-toggles violations and a display mode that overlaps monitors on the work setup.

# Notes
- Generated locally by logics-manager.
