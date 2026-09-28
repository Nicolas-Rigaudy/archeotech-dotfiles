---
name: wrap
description: End-of-session wrap-up for archeotech work - update logics docs, docs/ pages, troubleshooting, and commit explicit paths as the user without pushing.
---
# /wrap - end of session

1. **Logics.** For each task touched: `logics-manager flow progress task <ref> --progress N%`
   or close it out (see implement-task). Record validation with `sync append-note`.
   Never hand-edit indicators, lineage or done status.
2. **Docs.** Update what changed: `docs/PACKAGES.md` (packages), `docs/KEYBINDS-MANGO.md` /
   `docs/KEYBINDS.md` (keybinds), `docs/TOOLS.md`, `docs/MANGOWC-SETUP.md`; ADRs in
   `logics/architecture/` for technical choices; `.claude/TROUBLESHOOTING.md` for new
   issues and fixes; `.claude/claude.md` "Durable feedback" for new standing rules.
3. **Lint the corpus.** `logics-manager lint --require-status`; fix with
   `sync update-indicators <ref> --touch` where only review is needed.
4. **Commit, per repo, explicit paths only.** Format `type[SCOPE]: description`, subject
   only, scope by file type (`[QML]`, `[MD]`, `[SH]`, `[CONF]`, `[PY]`, `[ASSET]`), check
   `git log` for vocabulary. In archeotech-shell use `git commit -m "..." -- <paths>` so
   anything the owner pre-staged is not swept in. Leave theme-switch churn unstaged.
   No Claude attribution. Never push.
5. **Resume note.** Update `.claude/handoffs/RESUME.md` (where things stand, next items, pending owner decisions, owner WIP not to touch) so a fresh session can continue.
6. **Report.** What changed, commits, anything left dirty and why, the next item.
