## req_007_fastfetch_logo_in_the_theme_accent - fastfetch logo in the theme accent
> From version: 1.0.0
> Schema version: 1.0
> Status: Ready
> Understanding: 90%
> Confidence: 85%
> Complexity: Low
> Theme: Theme system
> Reminder: Update status/understanding/confidence and linked backlog/task references when you edit this doc.

# AI Context
- Summary: The fastfetch logo should take the active theme's accent (mauve on Catppuccin with the mauve accent) and follow every theme or accent switch.
- Keywords: fastfetch, logo, theme, accent, theme-switch
- Use when: Planning the fastfetch theme target or changing how fastfetch is themed.
- Skip when: Working on other theme-switch targets.

# Needs
- fastfetch runs on its defaults, so its Arch logo stays cyan whatever the theme. The owner wants it in the theme accent, on the desk and in screenshots (2026-10-26).
- The ANSI colour name `magenta` was rejected: Catppuccin's kitty themes map it to pink in every flavour, and it ignores the chosen accent.

# Context
- theme-switch.py (archeotech-shell) already writes one config per app through `apply_<target>` functions (kitty, rofi, starship, fish, mango…); fastfetch becomes one more target.
- The dotfiles repo has no fastfetch config yet.

# Acceptance criteria
- AC1: After a theme switch, the fastfetch logo is drawn in the active accent.
- AC2: The fastfetch config is written by theme-switch like the other targets and deployed by the dotfiles installer.

# Definition of Ready (DoR)
- [x] Problem statement is explicit and user impact is clear.
- [x] Scope boundaries (in/out) are explicit.
- [x] Acceptance criteria are testable.
- [x] Dependencies and known risks are listed.

# Companion docs
- Product brief(s): (none yet)
- Architecture decision(s): (none yet)

# References
- scripts/theme-switch.py in the archeotech-shell repo
- `scripts/install.sh`

# Backlog
- `item_152_fastfetch_logo_in_the_theme_accent`
