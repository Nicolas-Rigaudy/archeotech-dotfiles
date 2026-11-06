## item_170_wallpapers_tied_to_themes_auto_switch_on_theme_change - Wallpapers tied to themes; auto-switch on theme change
> From version: 1.0.0
> Schema version: 1.0
> Status: Ready
> Understanding: 90%
> Confidence: 85%
> Progress: 0%
> Complexity: Medium
> Theme: Operator workflow and runtime integration
> Reminder: Update status/understanding/confidence/progress and linked request/task references when you edit this doc.

# AI Context
- Summary: The owner picks wallpapers for each theme (family/flavor, and each pack/register); switching theme applies one of that theme's wallpapers, and the picker shows only the current theme's selection by default, with the existing Show all button revealing everything (as the light/dark filter does today).
- Keywords: wallpapers, tied, themes, auto, switch, theme, change
- Use when: theme switches should change the wallpaper, or the picker filter changes.
- Skip when: pack-shipped wallpaper discovery (item_151, done) or rotation (item_147).

# Problem
- Owner, 2026-11-06: "later i want automatic switching of wallpapers when changing themes with selected themes only on theme (with the same button to show all as dark/light mode)".
- Today a wallpaper is remembered per mode only (item_140 slots `wallpaper.light` / `wallpaper.dark`); a theme or pack switch keeps the same wallpaper unless the mode flips. Pack wallpapers reach the picker since item_151, but nothing selects them on a switch.

# Scope
- In:
  - Assign wallpapers to a theme (base family/flavor, pack, pack register) from the picker; persisted in config.
  - On a theme change, apply that theme's wallpaper (its last pick, or its first when none was picked), building on the item_140 mode slots.
  - Picker default filter: the current theme's wallpapers (pack wallpapers count as the pack's); Show all lifts it, same control as today's light/dark filter.
- Out:
  - Timed rotation (item_147), per-monitor wallpapers (item_148).

# Acceptance criteria
- AC1: Switching theme (or pack register) applies a wallpaper chosen for that theme; switching back restores the previous theme's wallpaper.
- AC2: The picker shows only the current theme's wallpapers by default and everything with Show all.
- AC3: A theme with no wallpaper assigned keeps today's per-mode behaviour.

# AC Traceability
- request-AC1 -> This backlog slice. Proof: bounded delivery slice.
- request-AC2 -> This backlog slice. Proof: promotable backlog item.
- request-AC3 -> This backlog slice. Proof: delivery chain includes a task-ready backlog item.

# Decision framing
- Product framing: Not needed
- Architecture framing: Not needed

# Links
- Product brief(s): (none yet)
- Architecture decision(s): (none yet)
- Request: (to be linked)
- Primary task(s): (none yet)

# Priority
- Priority: Medium
- Rationale: Default until groomed.

# Notes
- Generated locally by logics-manager.
- Related: req_006 (wallpaper modes), item_140 (per-mode slots), item_151 (pack wallpapers in the picker).

# Executions
| When | Runner | Run id | Title | State | PR | Notes |
| --- | --- | --- | --- | --- | --- | --- |

