## item_012_flat_glass_aesthetic_settings_toggle_full_rollout - Flat <-> glass aesthetic Settings toggle full rollout
> From version: 1.0.0
> Schema version: 1.0
> Status: Ready
> Understanding: 90%
> Confidence: 85%
> Progress: 0%
> Complexity: Medium
> Theme: Aesthetic tokens
> Reminder: Update status/understanding/confidence/progress and linked request/task references when you edit this doc.
> Indicators reviewed: 2026-08-20 17:08:28

# AI Context
- Summary: (unfilled: replace before this doc is used)
- Keywords: flat, glass, aesthetic, settings, toggle, full, rollout
- Use when: (unfilled: replace before this doc is used)
- Skip when: (unfilled: replace before this doc is used)

# Problem
- Flat-mode spike shipped on migrated surfaces only; un-migrated popups/media/edit-mode/openers stay glassy

# Scope
- In:
  - Route remaining surfaces' sheen+shadows through flatMode/shadowStrength tokens so the toggle flips the whole shell
- Out:
  - Named theme personalities

# Acceptance criteria
- AC5: The Settings flat/glass toggle flips every surface consistently

# AC Traceability
- request-AC5 -> This backlog slice. Proof: AC5: The Settings flat/glass toggle flips every surface consistently
- request-AC1 -> This backlog slice. Proof: AC5: The Settings flat/glass toggle flips every surface consistently

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
