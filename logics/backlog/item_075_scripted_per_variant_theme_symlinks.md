## item_075_scripted_per_variant_theme_symlinks - Scripted per-variant theme symlinks
> From version: 1.0.0
> Schema version: 1.0
> Status: In progress
> Understanding: 90%
> Confidence: 85%
> Progress: 20%
> Complexity: High
> Theme: Operator workflow and runtime integration
> Reminder: Update status/understanding/confidence/progress and linked request/task references when you edit this doc.
> Indicators reviewed: 2026-09-28 15:27:45

# AI Context
- Summary: Scripts the per-variant theme symlinks (`~/.config/archeotech/themes/<variant>` → repo) inside install.sh instead of relying on manual linking.
- Keywords: scripted, per, variant, theme, symlinks
- Use when: Working on theme deployment/symlinking during install.
- Skip when: Working on the install.sh backup/stow/verify flow itself (item_074) or package splitting (item_074) — this item is specifically the theme-symlink step.

# Problem
- Theme variants are currently linked into `~/.config/archeotech/themes/<variant>` by hand, which a fresh install has no record of and cannot reproduce.
- `theme.json` and the kitty confs per theme package are the committed source of truth, but nothing scripts turning that source into the expected runtime symlink layout.
- Without scripting this step, every fresh deploy risks missing or stale theme symlinks that silently break theme switching.

# Scope
- In:
  - A script (invoked from `install.sh`) that symlinks every theme variant from the repo into `~/.config/archeotech/themes/<variant>` reproducibly
  - Idempotent re-run behavior (safe to run again without duplicating or breaking existing symlinks)
- Out:
  - The rest of the install.sh backup/stow/verify/first-run flow (item_074)
  - Generating new theme variants themselves (out of scope; this only symlinks existing committed themes)

# Acceptance criteria
- AC1: Running the install step creates a symlink for every committed theme variant under `~/.config/archeotech/themes/`.
- AC2: Re-running the step on an already-deployed machine is idempotent and does not break existing theme selection.

# AC Traceability
- request-AC4 -> This backlog slice. Proof: scripted per-variant theme symlinks are an explicit milestone 1.0 install.sh deliverable for fresh-deploy reproducibility.

# Priority
- Priority: Medium
- Rationale: Required for a clean fresh install (2026-09-28 audit)

# Decision framing
- Product framing: Not needed
- Product signals: (none detected)
- Product follow-up: No product brief follow-up is expected based on current signals.
- Architecture framing: Not needed
- Architecture signals: (none detected)
- Architecture follow-up: No architecture decision follow-up is expected based on current signals.

# Links
- Product brief(s): (none yet)
- Architecture decision(s): (none yet)
- Request: `req_005_2026_09_28_audit_upgrade_program`
- Primary task(s): `task_031_orchestrate_2026_09_28_audit_upgrade_program`

# Priority
- Priority: Medium
- Rationale: Default until groomed.

# Notes
- Hybrid rationale: Derived from request `req_000_archeotech_shell_dotfiles` and kept bounded to one coherent delivery slice.
- Source file: `logics/request/req_000_archeotech_shell_dotfiles.md`.
- Generated locally by logics-manager.

# Tasks
- `task_031_orchestrate_2026_09_28_audit_upgrade_program`
