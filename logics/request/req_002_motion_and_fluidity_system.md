## req_002_motion_and_fluidity_system - Motion and fluidity system
> From version: 1.0.0
> Schema version: 1.0
> Status: Draft
> Understanding: 70
> Confidence: 70
> Complexity: High
> Theme: Motion
> Reminder: Update status/understanding/confidence and linked backlog/task references when you edit this doc.

# AI Context
- Summary: A shell-wide motion & fluidity system — one interruptible morph driver for island/panels/pills, user-selectable motion "personalities" with live preview, a shared micro-interaction primitive + optional UI-sound service, per-panel entrance choreography and ambient idle motion. Candidate work from the 2026-09-03 ambient-shell research sweep (ANALYSIS.md §20).
- Keywords: motion, fluidity, morph, animation, micro-interaction, easing, sound, ambient
- Use when: scoping/implementing shell motion — panel/island/pill transitions, an animation settings surface, press feedback, entrance choreography.
- Skip when: per-theme visual restyle (theming engine, req_001/adr_027); one-off single-widget tweaks; content of specific applets (req_004).

# Needs
- The shell should read as fluid and alive: motion is consistent, interruptible (no per-property desync mid-transition), and tunable by the user.
- Builds on the §18 motion tokens (partly in task_002) but adds: (1) morph drivers, (2) user-facing motion personalities + live preview, (3) layered micro-interactions + optional sound, (4) entrance/ambient choreography.
- Scope IN: motion token/curve extension; a single interruptible morph driver; motion personalities + in-settings live preview; shared press-feedback primitive; optional UI-sound service (gated); per-panel entrance + ambient idle motion.
- Scope OUT: theme/pack visual restyle (req_001); GPU audio visualizer (existing `cava_audio_visualizer` item); creative applet content (req_004); widget faces/skins (req_003).

# Context
- Existing baseline (NOT greenfield): ANALYSIS §17 already ships a strip->popup->panel morph — one `Shape` animates `_perp`/`_axis` PER-PROPERTY via 240ms OutCubic Behaviors, and the input mask grows with it. ANALYSIS §11.2 already defines the motion-token table (`Anim.fast/base/slow/spring/entrance/exit`, with enter-slow/exit-fast baked in). This request UPGRADES that morph (toward single-driver interruptibility) and EXTENDS that token table (curve presets, personalities) — it does not reinvent them.
- Reference sources (ANALYSIS §20.1): three morph techniques — Hyprism single-driver `morphProgress`, Brain_Shell flare-shape + `Behavior` + mask-follows, vantage pill->dot->panel; also §11.4 caelestia `offsetScale` (one property drives position+opacity) and §16 blob spring squash-and-stretch (stiffness 200/damping 16) as physics flourishes; pibble `Anim.qml` motion personalities + `AnimPreview` live preview; Serpantinum `Sounds` SFX + audio-reactive springs + compound micro-interactions; universal `introState` entrance choreography + ambient idle motion.
- Relates: task_002 (shell-wide design polish), the §18.4 motion recommendations, adr_027 (motion tokens are a pack-overridable layer). Honors the locked rules: `Shape.CurveRenderer` for AA, never `layer.enabled` on interactive/drag content, no fake toggles.

# Acceptance criteria
- AC1: A single interruptible morph driver powers island compact<->expanded and panel/pill transitions — geometry stays in sync and a mid-flight interrupt re-bases smoothly (no snap). Upgrades the existing §17 `_perp`/`_axis` per-property Shape morph; the input mask still grows with the shape.
- AC2: User-selectable motion "personalities" (e.g. bloom/pop/fade/slide/none) with independent off-switches (tiles/launch/menu/power) and a live in-settings preview.
- AC3: A shared micro-interaction primitive (layered press feedback: pop/flash/state-layer) and an optional UI-sound service behind a setting.
- AC4: Per-panel entrance choreography (one `introState` scalar every child reads) plus optional ambient idle motion, all respecting CurveRenderer / no-`layer.enabled`.

# Definition of Ready (DoR)
- [x] Problem statement is explicit and user impact is clear.
- [x] Scope boundaries (in/out) are explicit.
- [ ] Acceptance criteria are testable.
- [ ] Dependencies and known risks are listed.

# Companion docs
- Product brief(s): (none yet)
- Architecture decision(s): relates adr_027 (motion is a pack-overridable token layer); a morph-driver ADR may follow when promoted.

# References
- `.claude/ANALYSIS.md` (§11.2 existing motion-token table; §11.4 panel-slide patterns; §16 blob spring squash; §17 existing strip->popup->panel morph baseline; §20.1 morph techniques + personalities + UI sound; §20.3 recs 1/4/5/6)
- `logics/architecture/adr_027_theming_engine_mechanism_pack_token_overlay_additive_fx_motion_curated_versioned_style_delegate_contract.md`

# Backlog
- none
