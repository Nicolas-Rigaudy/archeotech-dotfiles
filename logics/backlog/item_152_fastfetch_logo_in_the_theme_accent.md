## item_152_fastfetch_logo_in_the_theme_accent - fastfetch logo in the theme accent
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
- Summary: A new theme-switch target writes a fastfetch config whose logo colours are the active theme's accent, so the Arch logo is mauve on Catppuccin/mauve and follows any family, flavor or accent change.
- Keywords: fastfetch, logo, theme, accent, theme-switch
- Use when: Adding or changing the fastfetch target of scripts/theme-switch.py (archeotech-shell) or config/.config/fastfetch (dotfiles).
- Skip when: Changing other theme-switch targets (kitty, rofi, starship, GTK) or the fastfetch module list.

# Problem
- fastfetch runs on its defaults, so its Arch logo stays cyan whatever the theme. The owner wants it in the theme accent, on the desk and in screenshots (2026-10-26).
- The ANSI colour name `magenta` was rejected: Catppuccin's kitty themes map it to pink in every flavour, and it ignores the chosen accent.

# Scope
- In:
  - `apply_fastfetch` in `scripts/theme-switch.py` (archeotech-shell), following the existing `apply_<target>` pattern: write `~/.config/fastfetch/config.jsonc` with `logo.color.1` and `logo.color.2` set to the accent hex (atomic write).
  - A tracked `config/.config/fastfetch/config.jsonc` in dotfiles and its entry in the `install.sh` CONFIGS array.
- Out:
  - Choosing which fastfetch modules show (keep today's defaults).
  - Key and title colours (logo only, unless the owner asks).
- Verification: an isolated run of the target (never the live theme-switch); fastfetch's escape codes carry the accent RGB.

# Acceptance criteria
- AC1: After a theme switch, the fastfetch logo is drawn in the active accent.
- AC2: The fastfetch config is written by theme-switch like the other targets and deployed by the dotfiles installer.

# AC Traceability
- request-AC1 -> This backlog slice. Proof: AC1: After a theme switch, the fastfetch logo is drawn in the active accent.
- request-AC2 -> This backlog slice. Proof: AC2: The fastfetch config is written by theme-switch like the other targets and deployed by the dotfiles installer.

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
- Request: `logics/request/req_007_fastfetch_logo_in_the_theme_accent.md`
- Primary task(s): (none yet)

# Priority
- Priority: Low
- Rationale: Cosmetic; the README screenshot already shows the mauve logo (rendered with an explicit colour), so nothing public waits on it.

# Notes
- Hybrid rationale: Derived from request `req_007_fastfetch_logo_in_the_theme_accent` and kept bounded to one coherent delivery slice.
- Source file: `logics/request/req_007_fastfetch_logo_in_the_theme_accent.md`.
- Generated locally by logics-manager.
- Implement as a /shell-item.
