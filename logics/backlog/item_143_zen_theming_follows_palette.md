## item_143_zen_theming_follows_palette - Zen browser theming that actually follows the shell palette
> From version: 1.0.0
> Schema version: 1.0
> Status: Ready
> Understanding: 90%
> Confidence: 85%
> Progress: 0%
> Complexity: Medium
> Theme: Theming
> Reminder: Update status/understanding/confidence/progress and linked request/task references when you edit this doc.

# AI Context
- Summary: Make Zen browser follow the shell's family/flavor/accent; the previous userChrome CSS approach never visibly recoloured Zen and was removed.
- Keywords: zen, browser, theming, workspace gradient, userChrome, palette
- Use when: Reviving browser theming from theme-switch.
- Skip when: Shell-only palette work (adr_033).

# Problem
- Owner 2026-10-01: Zen theming never worked. theme-switch's apply_zen wrote chrome/archeotech-colors.css + an @import into userChrome.css, but Zen's chrome is its own workspace gradient, which userChrome cannot recolour, and the CSS only loads on a Zen restart.
- Removed on 2026-10-01 together with the fake "Restart Zen on theme change" toggle (archeotech-shell 5a9ba75, applier/template removal on main the same day). Backup of the removed profile files: none kept in the repo; the generated CSS can be rebuilt from git history (scripts/themes/templates/zen-colors.css.tmpl).

# Scope
- In:
  - Research how Zen stores workspace themes/gradients (profile prefs or DB) and whether a running Zen can pick them up without a restart.
  - A theme-switch applier that writes the palette there, if feasible; no browser restart without the owner's explicit opt-in.
- Out:
  - Web content theming (per-site dark mode).

# Acceptance criteria
- AC1: After a theme switch, Zen's chrome visibly uses the new palette (owner-confirmed), with no forced browser restart.
- AC2: The applier only touches Zen-owned theme data it documents, and is reversible.

# AC Traceability
- request-AC2 -> This backlog slice. Proof: AC1: After a theme switch, Zen's chrome visibly uses the new palette (owner-confirmed), with no forced browser restart.

# Decision framing
- Product framing: Not needed
- Architecture framing: Not needed

# Links
- Product brief(s): `prod_003_archeotech_1_0_after_the_2026_09_28_audit`
- Architecture decision(s): (none yet)
- Request: `req_005_2026_09_28_audit_upgrade_program`
- Primary task(s): (none yet)

# Priority
- Priority: Low
- Rationale: owner: "not today"; nice-to-have cross-app consistency, no shell functionality depends on it.

# Notes
- Generated locally by logics-manager.
