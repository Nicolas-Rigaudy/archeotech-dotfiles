## task_078_cyberdeck_ornaments_textures_and_panel_styles - Cyberdeck ornaments, textures and panel styles
> From version: 1.0.0
> Schema version: 1.0
> Status: In progress
> Understanding: 90%
> Confidence: 85%
> Progress: 50%
> Complexity: Medium
> Theme: Implementation delivery
> Reminder: Update status/understanding/confidence/progress and linked request/backlog references when you edit this doc.
> Owner: claude
> Indicators reviewed: 2026-11-05 15:44:00

# AI Context
- Summary: Wave 1 builds the engine delegate seams the Cyberdeck pack needs (FrameStyle, BarSegment cluster/vertical api, CardHeader, SegmentedControl, RowSelection, StripButton, ScreenEffects) on top of item_112's Layer C style delegates; every seam draws nothing without a pack style so base and Grimdark stay pixel-identical. Wave 2 (after item_154's pack exists) ships the pack's own delegates, ornaments and textures.
- Keywords: cyberdeck, ornaments, textures, panel, styles
- Use when: adding or changing a pack style seam, or authoring the Cyberdeck pack's styles/ delegates.
- Skip when: the change is token-only (tokens.json) or the gauge face (item_159).

# Definition of Done (DoD)
- [ ] The backlog scope is implemented.
- [ ] Acceptance criteria are covered.
- [ ] Validation passes.
- [ ] Meaningful waves followed ADR 009: affected docs updated and the repo left commit-ready without automatic commits.

# Backlog
- `item_156_cyberdeck_ornaments_textures_and_panel_styles`

# Acceptance criteria
- AC1: Renders show brackets, rim, ornaments and panel style in all registers; reduce motion disables the glitch; every asset is original.

# Plan
- [x] Wave 1: seams in a worktree (FrameStyle + FrameBackground suppressFill, BarSegment cluster/vertical, CardHeader, SegmentedControl, RowSelection, StripButton, ScreenEffects), documented in docs/STYLE_API.md, proven with a throwaway probe pack; goldens + tests/run.sh unchanged; qmllint + qml-reviewer; land by path.
- [ ] Wave 2 (needs item_154 pack): Cyberdeck delegates, ornaments, textures, per-register renders, reduce-motion check.
- [ ] Use `python3 -m logics_manager flow progress task task_078_cyberdeck_ornaments_textures_and_panel_styles.md --progress <n>%` during multi-wave work.
- [ ] Run `python3 -m logics_manager flow finish task task_078_cyberdeck_ornaments_textures_and_panel_styles.md` after implementation.

# Validation
- Wave 1 (2026-11-05, archeotech-shell 36db5dc): scripts/golden.sh --root <wt> passed with no pack style loaded (24 ok + settings-light FLAKY then 0 px; the wallpaper-* flakes also fail on unfixed main); tests/run.sh 127 passed 0 failed; Qt6 qmllint clean except known singleton false positives and dynamic delegate-property reads; a throwaway probe pack (removed) rendered all seven seams in the none/launcher/settings:appearance/dashboard states; main vs worktree logs show the same pre-existing _winY binding loops and ButtonGroupRow recursive-rearrange warnings.

# Report
- Wave 1 landed (36db5dc): FrameStyle (replacesGlass -> FrameBackground.suppressFill, framePath), ScreenEffects (z 11, never paints the content hole), BarSegment cluster/vertical, Prim.CardHeader (DashCard), SegmentedControl delegate (keyRect, activeText/idleText), Prim.RowSelection (launcher + settings nav, selectedText), StripButton (per-slot active; Strip.buttonStyled drops the opener accent cell). Documented in docs/STYLE_API.md; qml-reviewer should-fixes applied (api objects gated on hasStyle, HoverHandler blocking false, launcher selectedText). Wave 2 waits for the item_154 pack.

# Links
- Request: `req_011_cyberdeck_theme_pack_droid_console_identity_for_the_shell_and_terminal`
- Product brief(s): (none yet)
- Architecture decision(s): (none yet)

# Executions
| When | Runner | Run id | Title | State | PR | Notes |
| --- | --- | --- | --- | --- | --- | --- |

# Notes
- Pending: wave 2 (Cyberdeck delegates, ornaments, textures, per-register renders, reduce-motion check) needs the item_154 pack; Appearance.shellVersion is still 0.3.0, so a pack cannot yet declare minShellVersion for these seams (owner call on bumping).
