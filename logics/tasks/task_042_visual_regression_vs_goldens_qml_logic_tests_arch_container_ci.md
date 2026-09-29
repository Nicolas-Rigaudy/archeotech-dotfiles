## task_042_visual_regression_vs_goldens_qml_logic_tests_arch_container_ci - Visual-regression vs goldens + QML logic tests + Arch-container CI
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
> Indicators reviewed: 2026-09-29 10:29:30

# AI Context
- Summary: scripts/golden.sh (25-scenario frozen-input matrix, masks, ImageMagick AE diff) with committed goldens; qmltestrunner logic tests over ShellConfigLogic.js; token contrast report; Arch-container CI job (qmllint gate + tests + contrast).
- Keywords: visual, regression, goldens, qml, logic, tests, arch, container
- Use when: Changing the golden matrix, masks, logic tests or the qml CI job.
- Skip when: CI render smoke (needs a cached image with mango; follow-up).

# Definition of Done (DoD)
- [x] The backlog scope is implemented.
- [x] Acceptance criteria are covered.
- [x] Validation passes.
- [x] Meaningful waves followed ADR 009: affected docs updated and the repo left commit-ready without automatic commits.

# Backlog
- `item_068_visual_regression_vs_goldens_qml_logic_tests_arch_container_ci`

# Acceptance criteria
- AC1: A visual regression in a themed component is caught by an ImageMagick diff against its golden and fails CI.
- AC2: At least one pure-logic QML unit (e.g. `ShellConfig._normEntry`) has a passing `qmltestrunner` test.
- AC3: The Arch container CI job runs lint -> logic tests -> headless render smoke -> visual diff end to end and uploads a diff artifact on failure.

# Plan
- [x] 1. Owner decisions: goldens in tests/golden; staged CI (lint + logic tests now, render diff local); core states x 3 looks + grimdark dashboard.
- [x] 2. Extract ShellConfig pure logic to ShellConfigLogic.js; 13 qmltestrunner tests.
- [x] 3. golden.sh + fixture wallpaper + masks derived from back-to-back renders; plant a regression to prove it fails.
- [x] 4. contrast-check.py (token WCAG report) and qmllint-ci.py (syntax gate).
- [x] 5. ci.yml qml job, proven in a local archlinux container.
- [x] 6. qml-reviewer, land on main by path, closeout.
- [x] Use `python3 -m logics_manager flow progress task task_042_visual_regression_vs_goldens_qml_logic_tests_arch_container_ci.md --progress <n>%` during multi-wave work.
- [x] Run `python3 -m logics_manager flow finish task task_042_visual_regression_vs_goldens_qml_logic_tests_arch_container_ci.md` after implementation.

# Validation
- golden.sh: 25 scenarios render in ~2m50s (2 jobs); masks derived from back-to-back renders (connected components of the AE diff); four clean runs at 0 px after masking (worktree x3, unrefactored main x1 = ShellConfig extraction render-neutral). Planted regression ('Nothing playing' -> 'Nothing is playing'): media-dark/light/flat fail at 320/153/315 px, exit 1; threshold set to 40 px. Corrupt golden -> ERROR (magick compare rc=2), exit 1 (reviewer blocking fix). tests/run.sh: 11 test functions (13 incl. init/cleanup) pass; a planted logic break fails 1. CI qml job steps run in a local archlinux:latest container (docker --network host): qmllint-ci rc=0 over 125 files, 13/13, contrast report. qml-reviewer: blocking (compare error read as pass) fixed and re-verified.
- command: `scripts/golden.sh (25/25, planted regression fails); tests/run.sh; qmllint-ci + tests in archlinux container; qml-reviewer` | result: passed | date: 2026-09-29
- Finish workflow executed on 2026-09-29.
- Linked backlog/request close verification passed.

# Report
- Landed on archeotech-shell main as 8d84bd6: scripts/golden.sh + tests/golden (25 goldens, fixture wallpaper, masks.txt), Services/Shell/ShellConfigLogic.js (ShellConfig delegates), tests/run.sh + tests/qml/tst_shellconfiglogic.qml, scripts/contrast-check.py (informational; 63 token pairs below floor today, e.g. tokyo-night-day body 2.78, nord overlay0==surface0 1.00), scripts/qmllint-ci.py (syntax gate), ci.yml qml job, docs/SHELL_VISUAL_DEV.md 'Regression checks'. /verify and /shell-item now require golden.sh + tests/run.sh before landing. Deferred by owner decision (staged CI): render smoke + golden diff in CI (needs a cached image with mango from AUR) and the diff-artifact upload; qmllint duplicate id 'section' in EditOverlay.qml (legal across delegates) left for item_130.
- Finished on 2026-09-29.
- Linked backlog item(s): `item_068_visual_regression_vs_goldens_qml_logic_tests_arch_container_ci`
- Related request(s): `req_000_archeotech_shell_dotfiles`

# Links
- Request: `req_000_archeotech_shell_dotfiles`, `req_005_2026_09_28_audit_upgrade_program`
- Product brief(s): (none yet)
- Architecture decision(s): (none yet)

# AC Traceability
- request-AC6 -> This task. Proof: contributes the goldens the 1.0 fresh-install check will run (tests/golden + scripts/golden.sh, 8d84bd6) and the visual-regression + logic-test layer of req_000 AC6; the fresh-Arch install itself is a later slice.
- request-AC2 -> This task. Proof: the golden render matrix (8 core states x dark/light/flat + grimdark) with image diff and a token contrast check exists and passes (archeotech-shell 8d84bd6); a planted regression fails it. The contrast floor itself and CI-side rendering are later slices (design v2 / item_068 follow-up).
- request-AC1 -> This task. Proof deferred to slice closeout.
- request-AC3 -> This task. Proof deferred to slice closeout.
- request-AC4 -> This task. Proof deferred to slice closeout.
- request-AC5 -> This task. Proof deferred to slice closeout.
