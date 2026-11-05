## item_163_screensaver_source_plugins_qml_terminal_and_web_examples - Screensaver source plugins: QML, terminal and web examples
> From version: 1.0.0
> Schema version: 1.0
> Status: Ready
> Understanding: 90%
> Confidence: 85%
> Progress: 0%
> Complexity: Medium
> Theme: Ambient
> Reminder: Update status/understanding/confidence/progress and linked request/task references when you edit this doc.
> Indicators reviewed: 2026-11-05 15:05:16

# AI Context
- Summary: (unfilled: replace before this doc is used)
- Keywords: screensaver, source, plugins, qml, terminal, web, examples
- Use when: (unfilled: replace before this doc is used)
- Skip when: (unfilled: replace before this doc is used)

# Problem
- Sources must be drop-in plugins so new screensavers need no core edit.

# Scope
- In:
  - Manifest kind for screensaver sources (module.json) with name, kind (qml / shader / terminal / program / web), preview hint and configSchema. Research: `.claude/SCREENSAVER_RESEARCH.md`.
  - QML: at least one original scene (reusing OrbitViz or the canvas work is fine) and a clock.
  - Shader: Qt ShaderEffect sources (GLSL compiled to .qsb, a small Shadertoy uniform wrapper), at least one theme-aware shader whose uniforms come from the accent and surface tokens; read hyprsaver (MIT) first.
  - Terminal: termflix (about 60 animations, `--screensaver`) as the main shuffle pool, astroterm (star map at the owner's location), a rotating globe, cmatrix/unimatrix, pipes.sh, asciiquarium, cbonsai, tty-clock, a local ASCII Star Wars copy, ascii-magic via npx; each declares its package and is hidden when missing.
  - Program: any fullscreen program under the same window rule as terminal sources; gource on a repo (the active Context's repo once 0.70 lands), mpv over a local video folder; xscreensaver hacks via Xwayland as best effort.
  - Web: a URL source, sandboxed, off by default.
  - docs/MODULE_API.md section for screensaver sources.
- Out:
  - Bundling animation binaries or third-party art in the repo.
  - Porting xscreensaver hacks to Wayland (wscreensaver is unmaintained; Xwayland only).

# Acceptance criteria
- AC2: A new source added under modules/ appears in the picker without core edits; one source of each kind plays in an isolated render.

# AC Traceability
- request-AC2 -> This backlog slice. Proof: AC2: A new source added under modules/ appears in the picker without core edits; one source of each kind plays in an isolated render.

# Decision framing
- Product framing: Not needed
- Architecture framing: Not needed

# Links
- Product brief(s): `prod_005_screensaver_engine`
- Architecture decision(s): (none yet)
- Request: `req_012_screensaver_engine_pluggable_sources_settings_picker_and_idle_hook`
- Primary task(s): `task_077_orchestrate_the_screensaver_engine`

# Priority
- Priority: Medium
- Rationale: Set by scaffold input or defaulted for grooming.

# Executions
| When | Runner | Run id | Title | State | PR | Notes |
| --- | --- | --- | --- | --- | --- | --- |
