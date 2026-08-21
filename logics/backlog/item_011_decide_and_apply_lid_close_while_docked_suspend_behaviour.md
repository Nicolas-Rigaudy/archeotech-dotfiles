## item_011_decide_and_apply_lid_close_while_docked_suspend_behaviour - Decide and apply lid-close-while-docked suspend behaviour
> From version: 1.0.0
> Schema version: 1.0
> Status: Ready
> Understanding: 90%
> Confidence: 85%
> Progress: 0%
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

# Links
- Product brief(s): `prod_001_archeotech_shell`
- Architecture decision(s): (none yet)
- Request: `req_000_archeotech_shell_dotfiles`
- Primary task(s): `task_001_orchestrate_archeotech_shell_delivery`

# Priority
- Priority: High
- Rationale: Set by scaffold input or defaulted for grooming.
