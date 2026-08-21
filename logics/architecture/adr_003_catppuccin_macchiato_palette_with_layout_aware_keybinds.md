## adr_003_catppuccin_macchiato_palette_with_layout_aware_keybinds - Catppuccin Macchiato palette with layout-aware keybinds
> Date: 2026-08-20
> Status: Proposed
> Related request: (none yet)
> Related backlog: (none yet)
> Related task: (none yet)
> Drivers: Establish a distinctive theme identity and a keybind model that survives frequent keyboard-layout switching.
> Reminder: Update status, linked refs, decision rationale, consequences, and follow-up work when you edit this doc.

# Overview
- Ship Catppuccin Macchiato (mauve accent) as the default palette and resolve keybinds by symbol, not physical position.

# Context
- Macchiato has warmer tones, easier on the eyes during long sessions.
- Position-based bindings would run different actions on the same physical key across AZERTY vs QWERTY.
- The user switches layouts frequently.

# Decision
- Default palette Catppuccin Macchiato with a mauve accent; Mocha shipped as an alternate variant in Sprint 12.
- Keybinds are layout-aware via resolve_binds_by_sym so the Q action always lives on the Q key.

# Consequences
- Macchiato is less common than Mocha (fewer third-party themes).
- Muscle memory has to relearn positions when switching layouts.

# References
- Related request: (none yet)
- Related backlog: (none yet)
- Related task: (none yet)
