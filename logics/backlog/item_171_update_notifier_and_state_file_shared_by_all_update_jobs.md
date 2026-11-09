## item_171_update_notifier_and_state_file_shared_by_all_update_jobs - Update notifier and state file shared by all update jobs
> From version: 1.0.0
> Schema version: 1.0
> Status: Ready
> Understanding: 90%
> Confidence: 85%
> Progress: 0%
> Complexity: Low
> Theme: Machine upkeep
> Reminder: Update status/understanding/confidence/progress and linked request/task references when you edit this doc.
> Indicators reviewed: 2026-11-09 17:34:22

# AI Context
- Summary: One notify script with a per-kind daily rate limit and a state dir (versions.json, last notice per kind, last upgrade time) used by every update job.
- Keywords: update, notifier, state, file, shared, all, jobs
- Use when: writing or changing update notifications or the versions state crow reads.
- Skip when: building the update jobs themselves (item_172, item_173, item_174).

# Problem
- Every update job needs to tell the owner when something needs them, without repeating the same alert every run, and crow needs installed versions without running updaters.

# Scope
- In:
  - scripts/update-notify.sh: one entry point taking a kind (news, upgrade-due, reboot, tool-failed) and a message; rate limit per kind per day; action button that opens `sysup` in kitty for upgrade-due and news.
  - State dir ~/.local/state/archeotech-updates/: last notification per kind, versions.json (tool, installed version, method, last update time, last result), last system upgrade time.
  - Dry-run flag that prints the notification instead of sending it, for tests.
- Out:
  - The update jobs themselves.
  - A shell bar widget.

# Acceptance criteria
- AC4: A second call with the same kind on the same day sends nothing; a different kind sends.
- AC6: versions.json is valid JSON with one entry per followed tool and is documented for crow.

# AC Traceability
- request-AC4 -> This backlog slice. Proof: AC4: A second call with the same kind on the same day sends nothing; a different kind sends.
- request-AC6 -> This backlog slice. Proof: AC6: versions.json is valid JSON with one entry per followed tool and is documented for crow.

# Decision framing
- Product framing: Not needed
- Architecture framing: Not needed

# Links
- Product brief(s): `prod_006_automatic_machine_updates`
- Architecture decision(s): (none yet)
- Request: `req_013_automatic_updates_system_packages_aur_npm_globals_and_user_tools`
- Primary task(s): `task_082_orchestrate_automatic_updates`

# Priority
- Priority: High
- Rationale: Set by scaffold input or defaulted for grooming.

# Executions
| When | Runner | Run id | Title | State | PR | Notes |
| --- | --- | --- | --- | --- | --- | --- |
