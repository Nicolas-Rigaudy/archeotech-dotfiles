## req_014_mask_the_clock_in_the_cyberdeck_dashboard_goldens - Mask the clock in the cyberdeck dashboard goldens
> From version: 1.0.0
> Schema version: 1.0
> Status: Draft
> Understanding: 90%
> Confidence: 85%
> Complexity: Medium
> Theme: General
> Reminder: Update status/understanding/confidence and linked backlog/task references when you edit this doc.

# AI Context
- Summary: The goldens dashboard-cyberdeck-netrunner, -megacorp and -deck fail on main because the clock is not masked.
- Keywords: mask, clock, cyberdeck, dashboard, goldens
- Use when: picking up this shell fix.
- Skip when: working on another area of the shell.

# Needs
- The goldens dashboard-cyberdeck-netrunner, -megacorp and -deck fail on main because the clock is not masked.

# Context
- Seen on main 10/11/2026.
- The other dashboard goldens already mask volatile fields.

# Acceptance criteria
- AC1: The clock area is masked in the three cyberdeck goldens.
- AC2: The goldens pass on main twice in a row at different times.

# Definition of Ready (DoR)
- [ ] Problem statement is explicit and user impact is clear.
- [ ] Scope boundaries (in/out) are explicit.
- [ ] Acceptance criteria are testable.
- [ ] Dependencies and known risks are listed.

# Companion docs
- Product brief(s): (none yet)
- Architecture decision(s): (none yet)

# References
- none

# Backlog
- none

# Executions
| When | Runner | Run id | Title | State | PR | Notes |
| --- | --- | --- | --- | --- | --- | --- |

