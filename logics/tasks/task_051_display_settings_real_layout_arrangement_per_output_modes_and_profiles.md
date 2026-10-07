## task_051_display_settings_real_layout_arrangement_per_output_modes_and_profiles - Display settings: real layout, arrangement, per-output modes and profiles
> From version: 1.0.0
> Schema version: 1.0
> Status: In progress
> Understanding: 90%
> Confidence: 85%
> Progress: 90%
> Complexity: Medium
> Theme: Implementation delivery
> Reminder: Update status/understanding/confidence/progress and linked request/backlog references when you edit this doc.
> Owner: claude
> Indicators reviewed: 2026-10-01 16:42:23

# AI Context
- Summary: Settings > Display monitor-layout editor bound to real wlr-randr state (arrange, mode, rotation, scale, apply with 15 s auto-revert), then saved per-monitor profiles that auto-apply on hotplug.
- Keywords: display, settings, real, layout, arrangement, per, output, modes, profiles
- Use when: Changing how outputs are read, arranged, applied or profiled.
- Skip when: Night light or per-output shell bar config.

# Definition of Done (DoD)
- [ ] The backlog scope is implemented.
- [ ] Acceptance criteria are covered.
- [ ] Validation passes.
- [ ] Meaningful waves followed ADR 009: affected docs updated and the repo left commit-ready without automatic commits.

# Backlog
- `item_135_display_settings_real_layout_arrangement_profiles`

# Acceptance criteria
- AC1: After a restart the pane shows the real current layout of every output.
- AC2: The work setup (eDP-1 + HDMI-A-1 + portrait DP-3) can be arranged without overlap and saved as a profile that re-applies on dock.

# Plan
- [x] Wave 1: Hardware.Displays (wlr-randr --json read on start/hotplug/2 s while visible, one-call apply, 15 s keep/revert), DisplaysLogic.js (parse, logicalSize, argv, normalize, snap, hasOverlap; tests), DisplayArrangement canvas, DisplayPane editor replacing the Layout guesses + wdisplays row.
- [x] Wave 2: profiles in ~/.config/archeotech/displays.json keyed by make/model/serial (connector fallback), Save as profile, silent auto-apply on hotplug with a toast, retire monitor-apply.sh hard-coded layouts (seed Work/Home/Laptop), shared apply script usable by the hotplug daemon.
- [ ] Use `python3 -m logics_manager flow progress task task_051_display_settings_real_layout_arrangement_per_output_modes_and_profiles.md --progress <n>%` during multi-wave work.
- [ ] Run `python3 -m logics_manager flow finish task task_051_display_settings_real_layout_arrangement_per_output_modes_and_profiles.md` after implementation.

# Validation
- Wave 1 (archeotech-shell 68631af): tests/run.sh 44/44 (13 DisplaysLogic tests: parse current/native fallback, logical size, argv incl. 0 Hz and no-mode outputs, overlap, snap flush/never-overlap/edge-align/lone, normalize); token-lint 0; golden.sh 25/25 unchanged. Isolated 3-output session: pane mirrors real wlr-randr state incl. a 270 portrait output (2 s re-read); end-to-end: DisplaysLogic snapped portrait to the far left, the generated argv ran in the nested session (rc 0) and wlr-randr read back exactly 0,100 / 720,0 / 2000,0, shell and canvas followed. qml-reviewer blockers fixed: unchanged reads keep the same array (no rebuild mid-drag), apply/revert only name connected outputs, failed apply cancels the countdown, no second apply during countdown. Pending owner: try on the real desk (dock/undock, rotate, Apply then Revert).
- b061015: tests 45/45 (risky(): move safe; rotation, off, scale, resolution, new output risky); token-lint 0; golden.sh 25/25. Isolated renders: confirm dialog on both screens, on top of Settings when it maps after it (the real Apply order); DropdownRow GlassButton field + themed list aligned under the field, current value checked, dark + light. Night light: wlsunset was a schedule (-T 6500 -t N did nothing by day), launched with & (died with the runner shell) and read back from NUL-separated /proc cmdline (always 'off'); now setsid -f wlsunset -t N -T N+1, read back via pgrep -a; isolated session: process reparented to 1 in its own session, args pinned. mango exposes wlr_gamma_control. Not yet seen on real hardware.
- Wave 2 (archeotech-shell 8e73521, dotfiles monitor-apply.sh): scripts/display-profile.py + 12 unit tests (identity by make/model/serial with connector fallback and junk serials; exact-set match; swapped ports follow the monitor; save replaces same name or set; argv only requests offered modes; in_place; mismatches; why_not); CI step added. Isolated e2e (2 outputs): save -> scramble -> auto-apply restores exactly; re-enabled output first lands at the right edge (mango ignores the requested pos), verify-and-reapply fixes it; no notify-send on PATH still exits 0 with the layout applied; already-in-place is silent; unknown set exits 3 and toasts once; corrupt file -> exit 5 (legacy) and kept as .bad. Profiles card rendered with seeded profiles (current marker, list, Update/Replace) dark + light. qml-reviewer blockers fixed (toast can't change rc or hang; only exit 5 falls back to legacy; set change cancels a stale revert countdown; Save uses the field's visible text). tests 45/45, golden 25/25, token-lint 0.
- Owner desk test 2026-10-07: undock toasts 'New display setup', re-dock switches back to Work correctly but was silent (mango monitor rules had already restored the layout, so apply was a no-op). Fixed in archeotech-shell 24aa789: announce when the monitor set changes (session stamp), silent on reloads; fake notify-send e2e: dock toasts even in place, reloads silent, re-dock toasts. Pending: owner saves Laptop/Home and confirms.

# Report
- Not started.

# Links
- Request: `req_005_2026_09_28_audit_upgrade_program`
- Product brief(s): (none yet)
- Architecture decision(s): (none yet)

# Notes
- Owner 2026-10-01: profiles match monitors by make/model/serial (connector fallback; eDP has no serial); matching profile applies silently with a toast; wave 1 first. The editor lives in Settings (no external wdisplays); Mirror dropped (it only stacked outputs at 0,0; mango has no true mirroring). Owner pain point: after unplugging, the second screen sometimes still shows and had to be disabled by hand in wdisplays; wave 1 gives an in-pane Enabled toggle, wave 2's Laptop profile should make it automatic.
- Owner 2026-10-01 after desk test (works): the in-pane countdown was too easy to miss (looked like a bug). Now: moves apply instantly; only risky changes (mode, refresh, rotation, scale, screen off) get the 15 s keep/revert, shown as a centred dialog on every screen (Enter keeps, Esc reverts). Owner also flagged the stock-Qt resolution/refresh pickers and a non-working colour temperature; both fixed in archeotech-shell b061015.
- Owner 2026-10-02: night light must work on both compositors; owner installed wl-gammarelay-rs. archeotech-shell ccfcbcb: picker rows 44/56 px and right-aligned (overlap missed in renders because headless outputs have one mode; now probed with fake mode lists), confirm countdown 20 s starting after wlr-randr returns. 4a8193c: Hardware.NightLight (wl-gammarelay-rs on mango via busctl set-property Temperature, hyprsunset via hyprctl on Hyprland), Settings toggle + 2500-6000 K slider applied live, persisted nightLight.enabled/temperature, re-applied at login, stops a leftover wlsunset. Isolated check: daemon started on boot and on the session bus; headless outputs have no gamma so the tint itself needs the owner's screen. Hyprland path untested (hyprsunset not installed).
