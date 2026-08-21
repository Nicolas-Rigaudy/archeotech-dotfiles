# Planning moved to logics/

Project planning now lives in the `logics/` corpus, managed by
[logics-manager](https://github.com/AlexAgo83/logics-manager). Do not plan in
ad-hoc Markdown here anymore.

- **Product brief:** `logics/product/prod_001_archeotech_shell.md`
- **Request:** `logics/request/req_000_archeotech_shell_dotfiles.md`
- **Roadmap / milestones:** `logics/roadmap/road_001_archeotech_shell.md`
- **Backlog (61 items):** `logics/backlog/`
- **Architecture decisions (25 ADRs):** `logics/architecture/`
- **Orchestration task:** `logics/tasks/task_001_orchestrate_archeotech_shell_delivery.md`

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
