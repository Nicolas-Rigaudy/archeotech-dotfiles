## item_073_hardcoded_path_audit_zero_home_corvus - Hardcoded-path audit (zero /home/corvus)
> From version: 1.0.0
> Schema version: 1.0
> Status: Ready
> Understanding: 90%
> Confidence: 85%
> Progress: 0%
> Complexity: High
> Theme: Operator workflow and runtime integration
> Reminder: Update status/understanding/confidence/progress and linked request/task references when you edit this doc.

# AI Context
- Summary: Audits and removes every remaining hardcoded `/home/corvus` path, routing everything through `$HOME`/`Paths.qml` — the 1.0 exit condition for zero hardcoded paths.
- Keywords: hardcoded, path, audit, zero, home, corvus
- Use when: Working on path portability, `Paths.qml`, or grepping for remaining `/home/corvus` references.
- Skip when: Working on the install script itself (item_074) or theme symlink scripting (item_075) — those consume this audit's output, not the audit itself.

# Problem
- Only one hardcoded `/home/corvus` path is known to remain, but there is no final verification pass proving zero occurrences repo-wide.
- Any remaining hardcoded path (previously found in `DisplayPane.qml` output names and the mango wallpaper fallback) breaks the install for any user who isn't this machine's owner.
- Without an audit as an explicit gate, a hardcoded path could reappear silently in future changes.

# Scope
- In:
  - Full repo grep/audit for `/home/corvus` (and other machine-specific absolute paths) across QML, scripts, and configs shipped in the public repo
  - Fix each finding to route through `$HOME` or `Paths.qml` (or config-driven equivalents, e.g. `~/.config/archeotech/outputs.json`)
  - A repeatable check (script or CI grep) that fails if a new hardcoded path is introduced
- Out:
  - The install script itself and package splitting (item_074)
  - Theme symlink scripting (item_075)

# Acceptance criteria
- AC1: `grep -r '/home/corvus' <public repo paths>` returns zero matches.
- AC2: The one previously-known remaining hardcoded path is fixed and portable via `$HOME`/`Paths.qml`.
- AC3: A repeatable check exists (script or CI step) that catches a reintroduced hardcoded path.

# AC Traceability
- request-AC4 -> This backlog slice. Proof: the hardcoded-path audit (zero /home/corvus) is the explicit 1.0 exit condition for portability under milestone 1.0.

# Priority
- Priority: High
- Rationale: Explicit 1.0 exit condition; blocks any stranger installing the shell on a fresh machine.

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
- Request: `logics/request/req_000_archeotech_shell_dotfiles.md`
- Primary task(s): (none yet)

# Priority
- Priority: Medium
- Rationale: Default until groomed.

# Notes
- Hybrid rationale: Derived from request `req_000_archeotech_shell_dotfiles` and kept bounded to one coherent delivery slice.
- Source file: `logics/request/req_000_archeotech_shell_dotfiles.md`.
- Generated locally by logics-manager.
