## item_074_install_sh_rewrite_install_packages_sh_required_vs_optional - install.sh rewrite + install-packages.sh (required vs optional)
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
- Summary: Rewrites install.sh with prereq check/backup/stow deploy/service enable/verification/first-run, and adds install-packages.sh splitting required vs optional dependencies.
- Keywords: install, rewrite, packages, required, optional
- Use when: Working on the install/deploy scripts or the required-vs-optional package list.
- Skip when: Working on the hardcoded-path audit itself (item_073, a prerequisite) or theme symlink scripting (item_075, a sibling install step).

# Problem
- There is no `install-packages.sh` distinguishing packages the shell actually requires from optional/nice-to-have tooling, so a fresh install pulls everything or nothing with no guidance.
- The current install path has no timestamped backup, verification step, or first-run experience — a failed or partial install can silently leave a broken config with no rollback.
- A stranger on fresh Arch has no single documented entry point that checks prerequisites before attempting to deploy.

# Scope
- In:
  - `scripts/install-packages.sh`: `paru -S` package list split into required (shell won't run without) vs optional (nice-to-have tooling)
  - Rewritten `scripts/install.sh`: prerequisite check, timestamped backup of any existing config, stow-based deploy, service enable, a verification step, and a first-run experience
- Out:
  - The hardcoded-path audit itself (item_073, must be clean first)
  - Per-variant theme symlink scripting (item_075, a related but separate install step)
  - INSTALL.md documentation content (item_076)

# Acceptance criteria
- AC1: Running `install-packages.sh` installs required packages by default and prompts or flags before installing optional ones.
- AC2: `install.sh` backs up any pre-existing config with a timestamp before deploying, and a failed prerequisite check aborts before touching the filesystem.
- AC3: A successful `install.sh` run ends in a verification step confirming the shell can launch, followed by a first-run experience.

# AC Traceability
- request-AC4 -> This backlog slice. Proof: the install.sh rewrite and install-packages.sh split are the core installer deliverable for milestone 1.0's "installable by a stranger" exit signal.

# Priority
- Priority: High
- Rationale: The installer is the single largest blocker to the 1.0 exit signal of a stranger installing on fresh Arch.

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
