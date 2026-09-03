## item_092_author_overview_mermaid_diagrams_for_remaining_adrs - Author overview mermaid diagrams for remaining ADRs
> From version: 1.0.0
> Schema version: 1.0
> Status: Draft
> Understanding: 80
> Confidence: 80
> Progress: 0
> Complexity: Medium
> Theme: Docs
> Reminder: Update status/understanding/confidence/progress and linked request/task references when you edit this doc.

# AI Context
- Summary: Hand-author the overview Mermaid diagram the audit flags as missing on the remaining 16 ADRs (adr_001/002/003/008/011/013/014/017/018/019/020/021/022/023/024/025). The 10 load-bearing ADRs + adr_026/027 already have one; `flow repair mermaid` cannot generate diagrams for architecture docs, so each is authored by hand.
- Keywords: mermaid, adr, diagrams, docs, audit, hygiene
- Use when: clearing the `companion_doc_missing_mermaid` audit warnings; a docs-completeness pass.
- Skip when: request/backlog/task docs (mermaid optional there); the already-diagrammed ADRs.

# Problem
- 16 ADRs lack their overview Mermaid diagram, so the audit reports 16 `companion_doc_missing_mermaid` warnings. Non-blocking, but leaves the architecture docs visually incomplete.

# Scope
- In:
  - A concise overview flowchart per remaining ADR (adr_001/002/003/008/011/013/014/017/018/019/020/021/022/023/024/025), inserted right after `# Overview`, plain-ASCII labels, matching the style of adr_004/010/027.
- Out:
  - Mermaid on request/backlog/task docs (not required); re-diagramming the 12 ADRs that already have one.

# Acceptance criteria
- AC1: All remaining ADRs carry a hand-authored overview Mermaid diagram and the audit reports zero `companion_doc_missing_mermaid` findings.

# AC Traceability
- request-AC6 -> This backlog slice. Proof: docs-completeness/hygiene under req_000 AC6 (testing, verification, distribution readiness).

# Decision framing
- Product framing: Not needed
- Architecture framing: Not needed

# Links
- Product brief(s): (none yet)
- Architecture decision(s): (none yet)
- Request: `req_000_archeotech_shell_dotfiles`
- Primary task(s): (none yet)

# Priority
- Priority: Low
- Rationale: Non-blocking docs hygiene (audit warnings only); do during a distribution-readiness docs pass.

# Notes
- Generated locally by logics-manager.
