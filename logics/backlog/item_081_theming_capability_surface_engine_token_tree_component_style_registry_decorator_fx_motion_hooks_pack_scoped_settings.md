## item_081_theming_capability_surface_engine_token_tree_component_style_registry_decorator_fx_motion_hooks_pack_scoped_settings - Theming capability surface (engine): token tree, component style registry, decorator/FX + motion hooks, pack-scoped settings
> From version: 1.0.0
> Schema version: 1.0
> Status: Ready
> Understanding: 90%
> Confidence: 85%
> Progress: 0%
> Complexity: High
> Theme: General
> Reminder: Update status/understanding/confidence/progress and linked request/task references when you edit this doc.
> Indicators reviewed: 2026-08-21 16:15:50

# AI Context
- Summary: The runtime that makes deep theme packs possible (per adr_026): expand the token tree, add a versioned component style-delegate registry, decorator/FX overlay hooks, a motion-token set, asset/lexicon resolution, and pack-scoped settings via configSchema. This is the load-bearing engine; packs (item_082 etc.) are thin data on top of it.
- Keywords: theming, engine, tokens, style-delegate, registry, decorator, fx, motion, pack-settings, capability-surface
- Use when: Building/extending the theming runtime or the versioned style contract.
- Skip when: Authoring a specific pack (that consumes this) or working non-theming plumbing.

# Problem
- The current theme system is colour/asset-level (family/flavor/accent tokens + Python applier). Packs that change shape, fonts, FX, motion, and add their own settings need a real capability surface + a versioned component style contract, or every pack reinvents structure ad-hoc and upgrades break packs.

# Scope
- In:
  - Expand the token tree (colour, radius, spacing, opacity, blur, elevation, type scale) beyond family/flavor/accent.
  - Component style-delegate registry behind a VERSIONED contract (same props/slots/behaviour; pack supplies the look) — start with a curated component set.
  - Decorator/FX overlay hooks (background textures, shaders) + a motion-token set.
  - Asset + optional lexicon resolution per active pack.
  - Pack-scoped settings: configSchema -> ConfigForm, pack-namespaced persistence, shown only when the pack is active.
  - Load via the adr_016 file:// + injected-appearance mechanism.
- Out:
  - Any concrete pack content (item_082) and pack manifest schema (item_066).
  - Distribution UI/index (item_063 / item_065).
- Guardrail: enforce the adr_026 stable-core invariants (no touching keybinds/IA/core config semantics/behaviour).

# Acceptance criteria
- AC1: A pack can override tokens, shape, fonts, decorator/FX, motion, and assets, and declare pack-scoped settings, without touching core behaviour/IA/keybinds.
- AC2: The component style-delegate contract is versioned (minShellVersion-checkable) and documented for pack authors.

# AC Traceability
- request-AC1 -> This backlog slice. Proof: capability surface lets packs reskin deeply within the stable-core invariants.
- request-AC2 -> This backlog slice. Proof: versioned, documented style contract delivered.

# Decision framing
- Product framing: Not needed
- Architecture framing: Recorded in `adr_026_theming_architecture_skin_structure_boundary_and_versioned_capability_surface`.

# Links
- Product brief(s): `prod_001_archeotech_shell`
- Architecture decision(s): `adr_026_theming_architecture_skin_structure_boundary_and_versioned_capability_surface`
- Request: `req_000_archeotech_shell_dotfiles`
- Primary task(s): `task_001_orchestrate_archeotech_shell_delivery`

# Priority
- Priority: High
- Rationale: Load-bearing for the whole themeable-platform direction; every pack and item_051/021 depend on it.

# Notes
- Generated locally by logics-manager.
