## item_134_settings_audit_fake_controls_missing_settings - Settings audit: fake controls, missing settings, per-pane gaps
> From version: 1.0.0
> Schema version: 1.0
> Status: Ready
> Understanding: 80%
> Confidence: 80%
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

Candidate missing settings (owner picks; grouped by pane):
- Appearance: font family and a real type/spacing/radius scale (lands with item_110 scales); animation speed / reduced motion (item_114); glass vs satin once item_116 decides.
- Shell / Bar: clock format (24h/12h, seconds, date), bar widget options above, dashboard project scan roots.
- Display: per-output arrangement from the real compositor state (read back), scale, refresh rate, rotation for the portrait DP-3; night light schedule (sunset/sunrise instead of fixed temperature only).
- Input (new pane): keyboard layout (AZERTY built-in / QWERTY external, Alt+Shift switch), repeat rate, touchpad natural scroll / tap-to-click.
- Notifications: per-app rules, sound, toast position (overlaps 0.50 item_119).
- Power: battery charge limit, lid-close behaviour (item_011 decided it in config), low-battery warning level.
- Launcher (new section): pinned apps list and providers (overlaps 0.50 item_118).

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
