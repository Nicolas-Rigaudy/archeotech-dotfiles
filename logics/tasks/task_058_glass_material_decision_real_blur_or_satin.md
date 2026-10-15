## task_058_glass_material_decision_real_blur_or_satin - Glass material decision: real blur or satin
> From version: 1.0.0
> Schema version: 1.0
> Status: Done
> Understanding: 90%
> Confidence: 85%
> Progress: 100%
> Complexity: Medium
> Theme: Implementation delivery
> Reminder: Update status/understanding/confidence/progress and linked request/backlog references when you edit this doc.
> Owner: claude
> Indicators reviewed: 2026-10-15 17:20:09

# AI Context
- Summary: Spike real compositor blur behind the shell's single full-screen layer (mango blur_layer + scenefx transparency mask), measure halo and cost on the GPU, then record the material decision (real blur or satin) in an ADR superseding adr_008 and update the goldens.
- Keywords: glass, material, decision, real, blur, satin
- Use when: Changing shell panel opacity, mango layer blur rules or the glass presets.
- Skip when: Window (client) blur or kitty opacity only.

# Definition of Done (DoD)
- [x] The backlog scope is implemented.
- [x] Acceptance criteria are covered.
- [x] Validation passes.
- [x] Meaningful waves followed ADR 009: affected docs updated and the repo left commit-ready without automatic commits.

# Backlog
- `item_116_glass_material_decision_real_blur_or_satin`

# Acceptance criteria
- AC1: An ADR records the decision and the goldens reflect it.

# Plan
- [x] Add a reviewed `--renderer gles2` option to shot.sh so scenefx effects render headless on the GPU.
- [x] Render blur_layer=1 + layerrule blur for archeotech-shell at panel alpha 0.70/0.80/0.96; check corner fringe and shadow halo.
- [x] Fix halo sources if found (shadow alpha outside panels, stale layer rules).
- [x] Owner picks from one contact sheet; ADR supersedes adr_008; presets/mango config/goldens follow.
- [x] Use `python3 -m logics_manager flow progress task task_058_glass_material_decision_real_blur_or_satin.md --progress <n>%` during multi-wave work.
- [x] Run `python3 -m logics_manager flow finish task task_058_glass_material_decision_real_blur_or_satin.md` after implementation.

# Validation
- 2026-10-14 spike: shot.sh --renderer gles2 (new option) on the Iris Xe render node. blur_layer=1 renders frosted panels with no corner fringe; soft outer shadows became a ~15px hard-edged blurred band (scenefx mask is binary), flat mode clean; blur_optimized=1 shows the wallpaper through windows (x-ray), 0 blurs the windows. Owner picks: blur on, clean edge with no shadow and no rim, x-ray/blur as a setting. Branch fix/item_116 cd3cb0b: contrast-check --glass --strict 0 below floor (dark panels 0.85/0.82, monochrome is the floor); python3 -m unittest discover tests/py 35 OK; tests/run.sh 72 passed; token-lint 0; theme-fidelity 0; golden.sh 25/25 after updating 9 dark/flat goldens (lower alpha over the test pattern, dropped shadow); qml-reviewer: no blocking, should-fixes applied. Pending: owner check on the live bar via archeotech-live.sh preview.
- 2026-10-15 live preview: toast clean once swaync (D-Bus activated since 2026-10-12, owned org.freedesktop.Notifications) was stopped; strip hover key band fixed (961668f, tight 2px shadow under blur), owner confirmed clean. Goldens: 7 light/flat regenerated (46af648), 25/25 pass, tests/run.sh 72 passed. Landed on main by fast-forward (cd3cb0b..46af648). Preview limitation found: the shell calls ~/.local/bin/theme-switch.sh (main's applier), so preview clicks on Opacity / Behind windows did not reach mango until landing. Pending owner: X-ray vs Blur difference on hardware (maybe a weaker blur for Blur), Style card separator look.
- 2026-10-15 (2): reproduced headless with scripts/desk-check.py at the owner's desk (1920x1200, live wallpaper, gles2, app behind, wlrctl hover): Glass->Solid halo (mango never un-blurs; fixed cc63c62), strip hover band (961668f), corner staircase. scenefx coverage patch: bright-edge excess at the Settings corner, X-ray over a dark window, 64.8 (stock) -> 0.6 (patched; crisp staircase 0.8); hover card corners <= 0.9. packages/scenefx-coverage test-built with makepkg (checksum OK, patch applies); its lib re-rendered: smooth corners, soft hover/toast shadows, no band. Blur mode 0.70 (e5bbe78): gate scripts/contrast-check.py --glass --strict 0 below floor (base alphas); measured over a light window muted 1.96 / desc 4.28, owner read it fine live over a white page. Every landing: scripts/golden.sh 25/25, tests/run.sh 72 passed.
- command: `scripts/golden.sh --root <wt> (25/25); tests/run.sh (72 passed); scripts/contrast-check.py --glass --strict (0 below floor); scripts/desk-check.py + edge-excess check (64.8 -> 0.6)` | result: passed | date: 2026-10-15
- Finish workflow executed on 2026-10-15.
- Linked backlog/request close verification passed.

# Report
- Glass is real compositor blur (adr_035): owner-picked 0.82 dark panels, 0.70 in Blur mode, X-ray/Blur setting, 18px corners, 2-pass radius-3 blur. Stock scenefx needs blur-safe rendering (no outer shadows/fades, crisp edges, tight toast/OSD windows); with packages/scenefx-coverage installed the shell drops those (marker file). Also landed: one Prim.Divider (soft recessed channel, thin for lists) for all separators; desk-check.py + shot.sh --mango-libs; swaync/dunst masked (install.sh). Pending owner: install the patched scenefx (makepkg -si) and upstream the patch.
- Finished on 2026-10-15.
- Linked backlog item(s): `item_116_glass_material_decision_real_blur_or_satin`
- Related request(s): `req_005_2026_09_28_audit_upgrade_program`

# Links
- Request: `req_005_2026_09_28_audit_upgrade_program`
- Product brief(s): (none yet)
- Architecture decision(s): (none yet)

# AC Traceability
- request-AC3 -> This task. Proof: adr_035 records real layer blur (supersedes adr_008); goldens regenerated with each visual landing (cd3cb0b, 46af648, 610de5f, 6c7b741), scripts/golden.sh 25/25.
