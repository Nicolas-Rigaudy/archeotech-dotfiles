## task_009_profile_flag_install_packages_sh_required_optional_split_remaining - --profile flag + install-packages.sh required/optional split (remaining)
> From version: 1.0.0
> Schema version: 1.0
> Status: Ready
> Understanding: 90%
> Confidence: 85%
> Progress: 0%
> Complexity: Medium
> Theme: Implementation delivery
> Reminder: Update status/understanding/confidence/progress and linked request/backlog references when you edit this doc.

# AI Context
- Summary: (unfilled: replace before this doc is used)
- Keywords: profile, flag, install, packages, required, optional, split, remaining
- Use when: (unfilled: replace before this doc is used)
- Skip when: (unfilled: replace before this doc is used)

# Definition of Done (DoD)
- [ ] The backlog scope is implemented.
- [ ] Acceptance criteria are covered.
- [ ] Validation passes.
- [ ] Meaningful waves followed ADR 009: affected docs updated and the repo left commit-ready without automatic commits.

# Backlog
- `item_074_install_sh_rewrite_install_packages_sh_required_vs_optional`

# Acceptance criteria
- AC1: Running `install-packages.sh` installs required packages by default and prompts or flags before installing optional ones.
- AC2: `install.sh` backs up any pre-existing config with a timestamp before deploying, and a failed prerequisite check aborts before touching the filesystem.
- AC3: A successful `install.sh` run ends in a verification step confirming the shell can launch, followed by a first-run experience.

# Plan
- [ ] Use `python3 -m logics_manager flow progress task task_009_profile_flag_install_packages_sh_required_optional_split_remaining.md --progress <n>%` during multi-wave work.
- [ ] Run `python3 -m logics_manager flow finish task task_009_profile_flag_install_packages_sh_required_optional_split_remaining.md` after implementation.

# Validation
- (no validation recorded yet)

# Report
- Not started.

# Links
- Request: `req_000_archeotech_shell_dotfiles`
- Product brief(s): (none yet)
- Architecture decision(s): (none yet)
