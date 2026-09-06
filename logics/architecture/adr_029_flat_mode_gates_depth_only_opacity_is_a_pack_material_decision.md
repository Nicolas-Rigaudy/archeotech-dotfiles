## adr_029_flat_mode_gates_depth_only_opacity_is_a_pack_material_decision - Flat mode gates depth only; opacity is a pack-material decision
> Date: 2026-09-06
> Status: Accepted
> Related request: `req_000_archeotech_shell_dotfiles`
> Related backlog: `item_012_flat_glass_aesthetic_settings_toggle_full_rollout`
> Related task: `task_022_flat_glass_aesthetic_settings_toggle_full_rollout`
> Drivers: the user's flat/glass toggle must read as "flat GLASS", not "opaque slab"; keep transparency + blur on in both modes; preserve pack-material opacity (flat/matte packs) without coupling it to the user toggle; avoid per-surface opacity patches (e.g. the reverted `surfaceRaised` token).
> Reminder: Update status, linked refs, decision rationale, consequences, and follow-up work when you edit this doc.

# Overview
- The `flatMode` user toggle controls DEPTH ONLY (sheen/gradients + drop shadows). It never controls opacity: the shell stays translucent glass in both modes (transparency + compositor blur always on). Opacity is a separate, PACK-material decision — only a pack `material:"flat"|"matte"` renders opaque fills.

# Context
- Note: every code path/symbol cited below lives in the sibling `archeotech-shell` repo (split out 2026-07-09); the Logics validator only sees this dotfiles repo, so those citations read as "missing" here — expected, not stale.
- Two orthogonal visual axes were historically conflated onto one flag:
  - DEPTH — skeuomorphic 3D cues: top-lit sheen gradients + drop shadows. Gated by `depthFlat` / `shadowStrength` and the `sheenHi`/`sheenLo` helpers (`Commons/Appearance.qml`).
  - OPACITY — translucent glass vs opaque slab. Historically gated by the SAME `flatMode` flag (`glassBg`, `glassBgLight`, `surfaceCard`, `glassSheenTop/Bot` all did `flatMode ? opaque : translucent`).
- Because opacity rode on `flatMode`, toggling the user "Flat mode" setting turned every panel into an opaque slab. That also spawned a false sub-problem: neutral tiles (`surface0Alpha`) vanished into the now-opaque panel, "fixed" during item_012 with a `surfaceRaised` elevation token — a patch treating the symptom, not the cause.
- Owner intent (2026-09-06): flat = translucent glass MINUS the 3D depth; 3D/glass = translucent PLUS full skeuomorphic depth (and more of it, everywhere). Neither mode is opaque. Opacity belongs to the theming engine's pack materials (adr_026/027), not the base aesthetic toggle.

# Decision
- `flatMode` gates DEPTH ONLY. `depthFlat` (= `flatMode && !packMaterialMatte`) and `shadowStrength` (= `depthFlat ? 0 : 1`) drive sheen flattening (`sheenHi`/`sheenLo`) and shadow-alpha gating; these are unchanged and correct.
- OPACITY is driven by `packMaterialFlat` (a pack `material:"flat"|"matte"`), NOT `flatMode`. The opaque branches on `glassBg`, `glassBgLight`, `surfaceCard`, and `glassSheenTop/Bot` key on `root.packMaterialFlat`. With no pack (or a glass pack), the base look — glass OR the user's flat toggle — stays translucent.
- Matte packs stay dimensional: `packMaterialFlat` true (opaque) + `packMaterialMatte` true ⇒ `depthFlat` false ⇒ keeps gradients/shadows. Flat packs: `packMaterialFlat` true + matte false ⇒ opaque AND flat.
- No per-surface opacity compensation. The `surfaceRaised` token and its usages were reverted; translucent panels let `surface0Alpha` tiles read on their own, in both modes.
- Toggle copy must describe DEPTH, not opacity ("drop the sheen + shadows … the shell stays translucent").

# Consequences
- Invariant for all future work: never gate opacity on `flatMode`. If a surface must go opaque, gate it on `packMaterialFlat` (pack-driven). New sheen/shadow code gates on `depthFlat`/`shadowStrength` (or the `sheenHi`/`sheenLo` helpers).
- The user flat/glass toggle now differs ONLY in depth; both modes share the same translucency + blur, so tiles/contrast behave identically across the toggle — no elevation-token class of bug.
- Pack authors get opacity via `material:"flat"|"matte"` in the pack manifest; it is intentionally not reachable from the base Settings toggle.
- Verified (isolated `shot.sh`, 2026-09-06): flat card fill moved from opaque `srgb(54,58,79)` to translucent `srgb(49,50,71)` ~ glass `srgb(44,46,65)`; user confirmed live.
- Implemented in `archeotech-shell`: `e31e507` (opacity → `packMaterialFlat` + comments), `c62a63d` (revert `surfaceRaised`), `1fdac3d` (toggle copy). Depth work from item_036/item_012 (sheen flatten + shadow gates + ThemeCarousel) retained.

# References
- Related request: `req_000_archeotech_shell_dotfiles`
- Related backlog: `item_012_flat_glass_aesthetic_settings_toggle_full_rollout`
- Related task: `task_022_flat_glass_aesthetic_settings_toggle_full_rollout`
- Related ADRs: `adr_026` (theming architecture / skin boundary), `adr_027` (theming engine: pack token overlay + materials)
