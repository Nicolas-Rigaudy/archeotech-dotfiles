## item_011_decide_and_apply_lid_close_while_docked_suspend_behaviour - Decide and apply lid-close-while-docked suspend behaviour
> From version: 1.0.0
> Schema version: 1.0
> Status: Done
> Understanding: 90%
> Confidence: 85%
> Progress: 100%
> Complexity: Low
> Theme: Stability
> Reminder: Update status/understanding/confidence/progress and linked request/task references when you edit this doc.
> Indicators reviewed: 2026-08-20 17:08:28

# AI Context
- Summary: (unfilled: replace before this doc is used)
- Keywords: decide, apply, lid, close, while, docked, suspend, behaviour
- Use when: (unfilled: replace before this doc is used)
- Skip when: (unfilled: replace before this doc is used)

# Problem
- Random locks are real lid-close suspend events; logind.conf is all defaults so it suspends even with 3 external monitors

# Scope
- In:
  - Decide lid behaviour (ignore vs ignore-on-AC vs as-is); apply logind drop-in; widen hyprlock-launch.sh suspend regex
- Out:
  - Full power-management overhaul

# Acceptance criteria
- AC4: Lid-close while docked behaves per the chosen policy and no longer surprise-suspends

# AC Traceability
- request-AC4 -> This backlog slice. Proof: AC4: Lid-close while docked behaves per the chosen policy and no longer surprise-suspends

# Decision framing
- Product framing: Not needed
- Architecture framing: Not needed
- Decision (2026-09-07): Policy = "stay awake when plugged in". Suspend on lid-close only when on battery AND undocked; ignore on external/AC power and when docked. Keys off AC power (reliably detected) rather than logind's flaky docked-detection, which is the real cause of the surprise-suspends (HandleLidSwitchDocked=ignore is already the default but never fires because logind doesn't count monitors behind hubs/adapters).
- Implementation (2026-09-07): drop-in `system/etc/systemd/logind.conf.d/10-archeotech-lid.conf` (HandleLidSwitch=suspend / HandleLidSwitchExternalPower=ignore / HandleLidSwitchDocked=ignore), deployed by `scripts/update-system-configs.sh`, documented in `system/README.md`. Applied via `sudo systemctl restart systemd-logind` (user step; ends session).
- Sub-scope dropped: "widen hyprlock-launch.sh suspend regex" is obsolete post-hyprlock migration — the current stack uses hypridle `before_sleep_cmd = loginctl lock-session`, which locks before *any* suspend uniformly, so there is no trigger-disambiguation regex to widen.

# Links
- Product brief(s): `prod_001_archeotech_shell`
- Architecture decision(s): (none yet)
- Request: `req_000_archeotech_shell_dotfiles`
- Primary task(s): `task_001_orchestrate_archeotech_shell_delivery`

# Priority
- Priority: High
- Rationale: Set by scaffold input or defaulted for grooming.
