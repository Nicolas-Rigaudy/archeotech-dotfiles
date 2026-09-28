# Planning moved to logics/

Project planning now lives in the `logics/` corpus, managed by
[logics-manager](https://github.com/AlexAgo83/logics-manager). Do not plan in
ad-hoc Markdown here anymore.

- **Product briefs:** `logics/product/prod_001_archeotech_shell.md` (long-lived) and `logics/product/prod_003_archeotech_1_0_after_the_2026_09_28_audit.md` (post-audit direction to 1.0)
- **Active program:** `logics/request/req_005_2026_09_28_audit_upgrade_program.md`, orchestrated by `logics/tasks/task_031_orchestrate_2026_09_28_audit_upgrade_program.md`
- **Roadmaps:** `logics/roadmap/road_001_archeotech_shell.md` (shell: 0.30 Safety net -> 0.31 Correctness -> 0.40 Design system v2 -> 0.50 Utility -> 0.60 Contexts -> 1.0 -> 1.1+ add-on packs) and `logics/roadmap/road_002_dotfiles_machine_config.md` (personal machine config)
- **Direction ADR:** `logics/architecture/adr_032_post_audit_direction_corvus_dataslate_base_add_on_identity_packs_contexts_as_1_0_headline.md`
- **Audit evidence (2026-09-28):** `.claude/audits/2026-09-28/` (five reports, contact sheets, `render-matrix.sh`)
- **Legacy:** `logics/request/req_000_archeotech_shell_dotfiles.md` and the Obsolete `task_001`/`task_002` orchestration tasks

The former planning docs are archived (read-only reference) at:
- `logics/external/ROADMAP.archived.md`
- `logics/external/DECISIONS.archived.md`
- `logics/external/sprint-history.md` (condensed shipped history)

## Working with the corpus

```bash
logics-manager status                 # next work signal
logics-manager view --open            # browser board
logics-manager flow list              # open docs
logics-manager lint --require-status  # validate
logics-manager audit --group-by-doc   # traceability + grooming warnings
```

See `LOGICS.md` / `logics/instructions.md` for the safe-edit rules (never
hand-edit indicators, lineage links, or done status — use the CLI).
