## item_082_flagship_theme_pack_1_wh40k_shadow_spears_dataslate - Flagship theme pack #1: WH40K Shadow Spears dataslate
> From version: 1.0.0
> Schema version: 1.0
> Status: Ready
> Understanding: 95%
> Confidence: 85%
> Progress: 60%
> Complexity: High
> Theme: General
> Reminder: Update status/understanding/confidence/progress and linked request/task references when you edit this doc.
> Indicators reviewed: 2026-09-02 10:37:54

# AI Context
- Summary: The first concrete, end-to-end theme pack on the item_081 engine: a WH40K Shadow Spears (the owner's own chapter) ritualistic dataslate / Inquisition-document identity — parchment/dataslate textures, gothic type, ornamental framing, purity-seal motifs, ritual motion. Doubles as the proof-of-architecture (hardest pack = best stress test) and a flagship traction post (item_080 content strategy).
- Keywords: 40k, warhammer, shadow-spears, dataslate, inquisition, parchment, gothic, flagship-pack, proof-of-architecture
- Use when: Building/refining the 40K pack, or validating the theming engine against a demanding pack.
- Skip when: Working the engine itself (item_081) or a different pack.

# Problem
- The themeable-platform direction needs a real, demanding pack to prove the engine's capability surface is sufficient and its stable-core invariants hold — and to serve as the distinctive, authentic launch identity.

# Scope
- In:
  - A complete Shadow Spears dataslate pack exercising tokens, shape, gothic fonts, parchment/dataslate decorator + texture, ritual motion, sigil/wallpaper assets, and pack-scoped settings (e.g. parchment intensity / purity-seal density / sigil style).
  - Feel-checked live; core behaviour/keybinds/IA verified unchanged when switching to/from base.
- Out:
  - Engine capabilities themselves (item_081) — this pack only consumes them; any gap found feeds back as engine work.
  - Other packs (Gundam/cyberdeck) — follow once the architecture is proven.
- Sequencing + fallback: 40K is deliberately first as the hardest stress test. If the engine fights us badly early, drop to a token+shape-only pack (Gundam-lite or cyberdeck) to shake out the surface, then return to 40K. Record any such pivot here (not silent).
- Depends on: item_081 (engine), item_066 (manifest).

# Acceptance criteria
- AC1: A switchable Shadow Spears dataslate pack renders a coherent, distinct identity (shape/font/texture/motion/assets) and passes a live feel-check.
- AC2: Switching to/from the pack leaves keybinds, IA, and core settings unchanged; any engine gap found is filed back to item_081.

# AC Traceability
- request-AC1 -> This backlog slice. Proof: complete distinct 40K pack delivered + feel-checked.
- request-AC2 -> This backlog slice. Proof: stable-core invariants verified across the switch.

# Decision framing
- Product framing: Not needed
- Architecture framing: Governed by `adr_026_theming_architecture_skin_structure_boundary_and_versioned_capability_surface`.
- Register/sub-pack direction (2026-09-02): the faction registers must re-livery the WHOLE interface per each institution's design language — not just swap the palette. Each register = a distinct sub-theme (structure/shape/motifs/type emphasis), sharing the stable core. Current tokens carry colour-only overrides = placeholder; full per-faction re-livery is deferred future scope (candidate for its own backlog item). IP: RESOLVED (verified 2026-09-07) — the shipped pack is IP-safe: pack name 'Grimdark', registers renamed to Legion/Ordos/Forge, and no GW/WH40K trademark strings remain anywhere in `packs/grimdark`. Only this planning doc's title/slug still carries the old 'wh40k_shadow_spears' name (internal, never shipped); rename it if/when convenient but it's not an IP exposure.

# Links
- Product brief(s): `prod_001_archeotech_shell`
- Architecture decision(s): `adr_026_theming_architecture_skin_structure_boundary_and_versioned_capability_surface`
- Request: `req_000_archeotech_shell_dotfiles`
- Primary task(s): `task_001_orchestrate_archeotech_shell_delivery`

# Priority
- Priority: Medium
- Rationale: Moved to the first post-1.0 drop (roadmap 2026-09-03) — the theming ENGINE ships in v1, the flagship pack follows; so it is no longer top-of-list v1 work. Still the proof-of-architecture + distinctive launch identity when it lands.

# Notes
- Generated locally by logics-manager.
