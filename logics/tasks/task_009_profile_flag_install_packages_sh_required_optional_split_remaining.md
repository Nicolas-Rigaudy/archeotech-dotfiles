## task_009_profile_flag_install_packages_sh_required_optional_split_remaining - --profile flag + install-packages.sh required/optional split (remaining)
> From version: 1.0.0
> Schema version: 1.0
> Status: Done
> Understanding: 90%
> Confidence: 85%
> Progress: 100%
> Complexity: Medium
> Theme: Implementation delivery
> Reminder: Update status/understanding/confidence/progress and linked request/backlog references when you edit this doc.
> Indicators reviewed: 2026-09-02 14:09:13
> Owner: corvus

# AI Context
- Summary: (unfilled: replace before this doc is used)
- Keywords: profile, flag, install, packages, required, optional, split, remaining
- Use when: (unfilled: replace before this doc is used)
- Skip when: (unfilled: replace before this doc is used)

# Definition of Done (DoD)
- [x] The backlog scope is implemented.
- [x] Acceptance criteria are covered.
- [x] Validation passes.
- [x] Meaningful waves followed ADR 009: affected docs updated and the repo left commit-ready without automatic commits.

# Backlog
- `item_074_install_sh_rewrite_install_packages_sh_required_vs_optional`

# Acceptance criteria
- AC1: Running `install-packages.sh` installs required packages by default and prompts or flags before installing optional ones.
- AC2: `install.sh` backs up any pre-existing config with a timestamp before deploying, and a failed prerequisite check aborts before touching the filesystem.
- AC3: A successful `install.sh` run ends in a verification step confirming the shell can launch, followed by a first-run experience.

# Plan
- [x] Use `python3 -m logics_manager flow progress task task_009_profile_flag_install_packages_sh_required_optional_split_remaining.md --progress <n>%` during multi-wave work.
- [x] Run `python3 -m logics_manager flow finish task task_009_profile_flag_install_packages_sh_required_optional_split_remaining.md` after implementation.

# Validation
- (no validation recorded yet)
- command: `bash -n scripts/install{,-packages}.sh; ./scripts/install-packages.sh --dry-run [--profile minimal|full|bogus]; ./scripts/install.sh --dry-run [--profile full]` | result: passed | date: 2026-09-02
- Finish workflow executed on 2026-09-02.
- Linked backlog/request close verification passed.

# Report
- Not started.
- Finished on 2026-09-02.
- Linked backlog item(s): `item_074_install_sh_rewrite_install_packages_sh_required_vs_optional`
- Related request(s): `req_000_archeotech_shell_dotfiles`

# Links
- Request: `req_000_archeotech_shell_dotfiles`
- Product brief(s): (none yet)
- Architecture decision(s): (none yet)

# AC Traceability
- request-AC1 -> This task. Proof deferred to slice closeout.
- request-AC2 -> This task. Proof deferred to slice closeout.
- request-AC3 -> This task. Proof deferred to slice closeout.
- request-AC4 -> This task. Proof: install-packages.sh added with required(39)/optional split and --profile minimal|recommended|full (recommended prompts before optional); install.sh gained --profile (runs the package installer first), a check_requirements abort-before-touch, timestamped backup, plus verify_shell_can_launch + first_run_experience. Validated via bash -n and --dry-run on both scripts (profiles + bad-profile rejection + full/plain dry-run exit 0); real-system probes (mango/qs/qs list/shell-config) all pass. Implemented in 4ad8b53. Source: `4ad8b53`
- request-AC5 -> This task. Proof deferred to slice closeout.
- request-AC6 -> This task. Proof deferred to slice closeout.
