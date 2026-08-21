## req_001_theming_capability_surface_flagship_identity_packs - Theming capability surface & flagship identity packs
> From version: 1.0.0
> Schema version: 1.0
> Status: Ready
> Understanding: 90%
> Confidence: 90%
> Complexity: Medium
> Theme: Theming ecosystem
> Reminder: Update status/understanding/confidence and linked backlog/task references when you edit this doc.
> Indicators reviewed: 2026-08-21 17:14:40

# AI Context
- Summary: The theming-platform request — make Archeotech a themeable-shell PLATFORM (neutral glass BASE + swappable, community-authorable identity PACKS) per adr_026, proven with a flagship pack. The scope home for the engine (item_081), flagship WH40K pack (item_082), HUD framing kit (item_078), and pack distribution/tiers (item_021/066/065/063). Skin/structure boundary: everything visual can change; keybinds/IA/config semantics stay put.
- Keywords: theming, capability surface, packs, skin-structure boundary, versioned style contract, WH40K, HUD, community, tiers
- Use when: Grooming or promoting any theming-platform slice, or checking the theming subsystem's bounded need and acceptance criteria.
- Skip when: Working non-theming features (dev-tooling plugin, testing harness, Hyprland, release plumbing) or the shell-wide design-polish rollout.

# Needs
- Turn the shell from a single fixed identity into a themeable platform: a neutral glassmorphism base plus swappable identity packs authored like widget plugins, so the owner and the community can reskin presentation deeply — tokens, type, shape, component-style delegates, decorator/FX, motion, assets, and pack-scoped settings — without ever changing keybinds, information architecture, or config semantics (adr_026).
- Prove the surface with a bundled flagship pack (WH40K Shadow Spears dataslate) plus a reusable HUD framing kit that packs opt into, and distribute packs on the same plugin rails as widgets.

# Context
- Direction (owner, 2026-08-21): themes must go far beyond colour — decorative styling, shapes, fonts, FX, animations — and be community-authorable, mirroring the widget-builder model; yet Settings stay familiar and inner-workings must not change between packs.
- A single fixed identity under-serves both breadth (r/unixporn standard glass) and distinctiveness (WH40K/Gundam/cyberpunk hooks); this is also the traction engine (item_042 ricing R&D, item_080 traction/presentation).
- Builds on existing rails rather than replacing them: adr_004 (token singleton + Python applier), adr_010 (widget registry), adr_016 (external plugins via file:// + injected appearance), adr_009 (reactive Config), adr_022 (per-instance config), adr_008 (glass). Architecture decided in adr_026.
- Roadmap home: milestone `0.265 - Theming & Identity` (engine + flagship + HUD); distribution/tier work rides the plugin milestones (0.27) and Manager pane (0.26).
- Distribution model (decided owner, 2026-08-21): a git-backed `plugins.json` catalog with DECENTRALIZED payloads — each pack/widget lives in the author's own repo/release; the index only lists it. Submission = a PR against the index repo, CI-gated by a manifest schema check + a headless test-load (item_067). No backend server. Ship order: install CLI + `plugins.json` index FIRST, in-shell Explorer/Manager pane next. A public library site is a post-v1, non-blocking add — a STATIC gallery generated from the same `plugins.json` ($0 GitHub Pages), not a dynamic backend.

# Acceptance criteria
- AC1: A versioned theming capability surface exists — a pack can override tokens, type, shape, component-style delegates, decorator/FX, motion, assets, and declare pack-scoped settings — behind a `minShellVersion`-gated style contract (item_081).
- AC2: The stable core is enforced — a pack cannot rebind keybinds, alter IA / the <=2-keystroke rule, or change core config-key semantics or component behaviour; packs only ADD their own settings.
- AC3: The base and at least one deep flagship pack (WH40K) are both selectable and swap the whole identity at runtime, with the HUD kit rendering only where a pack opts in (item_082, item_078).
- AC4: Theme packs install / enable / configure through the plugin rails — `plugins.json` index + `archeotech plugin install` CLI first, in-shell Manager/Explorer pane next; each manifest carries a tier + `minShellVersion` (item_066, item_065, item_063).
- AC5: Trust is tiered (official / verified / community). Data-only packs (theme = JSON + assets) are treated as low-risk; unverified CODE packs (QML widgets, which can run processes) surface an install-time warning. A public gallery site is explicitly OUT of the v1 acceptance bar — a static export of `plugins.json` is a later add (item_021).

# Definition of Ready (DoR)
- [x] Problem statement is explicit and user impact is clear.
- [x] Scope boundaries (in/out) are explicit.
- [x] Acceptance criteria are testable.
- [x] Dependencies and known risks are listed.

# Companion docs
- Product brief(s): (none yet)
- Architecture decision(s): (none yet)

# References
- Architecture: `adr_026_theming_architecture_skin_structure_boundary_and_versioned_capability_surface`
- Backlog: item_081 (engine), item_082 (flagship WH40K), item_078 (HUD kit), item_021 (distribution/tiers), item_066 (manifest), item_065 (install/index), item_063 (Manager pane), item_051 (personalities)
- Spec: `THEME_SPEC.md` (in the archeotech-shell repo since the 2026-07-09 split); drivers: item_042, item_080

# Backlog
- none
