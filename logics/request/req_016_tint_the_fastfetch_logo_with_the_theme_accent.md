## req_016_tint_the_fastfetch_logo_with_the_theme_accent - Tint the fastfetch logo with the theme accent
> From version: 1.0.0
> Schema version: 1.0
> Status: Draft
> Understanding: 90%
> Confidence: 85%
> Complexity: Medium
> Theme: General
> Reminder: Update status/understanding/confidence and linked backlog/task references when you edit this doc.

# AI Context
- Summary: The fastfetch logo follows the active theme accent colour.
- Keywords: tint, fastfetch, logo, theme, accent
- Use when: picking up this shell fix.
- Skip when: working on another area of the shell.

# Needs
- The fastfetch logo follows the active theme accent colour.

# Context
- Theme switching already rewrites other app configs.

# Acceptance criteria
- AC1: `apply_fastfetch` in `scripts/theme-switch.py` writes the accent into the fastfetch config.
- AC2: The config lives in `config/.config/fastfetch/` and is listed in `install.sh` CONFIGS.
- AC3: Switching theme changes the logo colour on the next fastfetch run.

# Definition of Ready (DoR)
- [ ] Problem statement is explicit and user impact is clear.
- [ ] Scope boundaries (in/out) are explicit.
- [ ] Acceptance criteria are testable.
- [ ] Dependencies and known risks are listed.

# Companion docs
- Product brief(s): (none yet)
- Architecture decision(s): (none yet)

# References
- `scripts/theme-switch.py`
- `config/.config/fastfetch/`
- `install.sh`

# Backlog
- none

# Executions
| When | Runner | Run id | Title | State | PR | Notes |
| --- | --- | --- | --- | --- | --- | --- |

