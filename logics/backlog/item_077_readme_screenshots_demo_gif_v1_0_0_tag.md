## item_077_readme_screenshots_demo_gif_v1_0_0_tag - README screenshots + demo GIF + v1.0.0 tag
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
- Summary: Generates README screenshots and a demo GIF via the Sprint-28 headless harness, then cuts and publishes the v1.0.0 tag with GitHub metadata.
- Keywords: readme, screenshots, demo, gif, tag
- Use when: Working on README visual assets, the demo GIF capture sequence, or the v1.0.0 release/tag/metadata step.
- Skip when: Working on the render harness itself (item_067) or on INSTALL/API documentation content (item_076).

# Problem
- The README has no screenshots or demo GIF, so a stranger evaluating the project has no visual sense of the shell before installing it.
- There is no v1.0.0 tag or GitHub release metadata (description, topics, social preview), so the project has no clear "this is the stable release" marker.
- Manually capturing screenshots for bar/OSD/launcher/dashboard/settings/edit-mode is slow and easy to let go stale after the fact.

# Scope
- In:
  - README screenshots (bar, OSD, launcher, dashboard, settings, edit mode) auto-generated via the S28 `shot.sh` + `qs ipc` state-driving harness
  - A demo GIF sequence (edit mode + theme/accent switch + plugin install) generated the same way
  - Cutting the `v1.0.0` tag and setting GitHub repo description, topics, and social preview
- Out:
  - The render harness implementation itself (item_067, a hard dependency)
  - INSTALL/PLUGIN_API/CONTRIBUTING doc content (item_076)

# Acceptance criteria
- AC1: The README displays at least one auto-generated screenshot for each of bar/OSD/launcher/dashboard/settings/edit-mode.
- AC2: A demo GIF showing edit mode, theme/accent switch, and plugin install is embedded in the README.
- AC3: The `v1.0.0` tag is pushed with GitHub description, topics, and social preview set.

# AC Traceability
- request-AC6 -> This backlog slice. Proof: README screenshots/demo GIF and the v1.0.0 tag are the final release-marker deliverable of milestone 1.0.

# Priority
- Priority: Medium
- Rationale: The capstone release step; depends on the S28 harness (item_067) and cannot start before every other 1.0 item is stable.

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
- Request: `logics/request/req_000_archeotech_shell_dotfiles.md`
- Primary task(s): (none yet)

# Priority
- Priority: Medium
- Rationale: Default until groomed.

# Notes
- Hybrid rationale: Derived from request `req_000_archeotech_shell_dotfiles` and kept bounded to one coherent delivery slice.
- Source file: `logics/request/req_000_archeotech_shell_dotfiles.md`.
- Generated locally by logics-manager.
