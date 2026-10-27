## req_007_r_d_what_to_prioritise_cut_and_defer_after_0_40_proposals - R&D: what to prioritise, cut and defer after 0.40 (proposals)
> From version: 1.0.0
> Schema version: 1.0
> Status: Draft
> Understanding: 90%
> Confidence: 85%
> Complexity: Medium
> Theme: General
> Reminder: Update status/understanding/confidence and linked backlog/task references when you edit this doc.

# AI Context
- Summary: R&D note, written 2026-10-21 overnight: what to do after the 0.40 design-system work, what to cut or defer, and why. Everything below the Needs heading is a PROPOSAL; no backlog item was created.
- Keywords: prioritise, cut, defer, after, proposals
- Use when: Re-sequencing 0.50 to 1.0 on road_001, or deciding what 1.0 can drop.
- Skip when: Executing a single item.

# Needs
- Decide the order and the cuts for 0.50, 0.60 and 1.0 now that 0.40 is mostly built on branch night/roadmap-next. Proposals only.

# Context
- State after the 2026-10-21 night run (branches night/roadmap-next in the shell, night/logics here, nothing on main): 0.40 has 110, 111, 116, 045, 134, 138 done earlier; tonight 114 (motion presets, animation speed, reduce motion), 117 (test packs moved to fixtures), 007 and 009 (thumbnail fade, theme crossfade), 006 (picker colour preview), 091 (accent for all families) closed; 112, 113, 115, 130, 039, 017 are partly built and wait on owner decisions or large remaining refactors (see their tasks task_059, 062, 063, 070, 069, 067).
- What peers do (project docs, checked 2026-10-21): DankMaterialShell replaces waybar, swaylock, swayidle, mako, fuzzel and polkit in one shell and supports niri, Hyprland, MangoWC, Sway; Noctalia is a minimal multi-compositor shell with dynamic colour generation and many predefined schemes; Caelestia is Hyprland-first with a fluid animated UI. All three win on breadth of the everyday layer (launcher, notifications, lock, OSD, network/bluetooth), not on identity.
- Roadmap size: 0.50 has 7 items, 0.60 has 5, 1.0 has 12. The scope freeze in road_001 already says new ideas go to 1.1+.

# Proposals
## Prioritise (in this order)
1. Finish 0.40's remaining structural work before adding features: 112 (pack chrome out of core) and 113 (primitive completion). Reason: every 0.50 feature (command palette, notifications v2, cheatsheet) will be written on these primitives and surface recipes; doing them after means rewriting them. 112 is also the gate for add-on packs. Both are implementable without owner input; they are the best use of unattended time.
2. 0.50 order: 118 launcher command palette, then 119 notifications v2, then 120 OSD plus panel IPC plus cheatsheet, then 121 native networking. Reason: 118 and 119 are what a daily user feels first and where DMS/Noctalia set the bar; 120 is cheap once panel IPC exists (it does: `panel` handler); 121 is the riskiest (replaces working nmcli/bluetoothctl code) and buys the least visible change, so it goes last.
3. Display/Input/Clock settings (135-137): 135 and 136 are done or in task form already (task_051/052/055); close the remaining gaps rather than reopening them.
4. 0.60: 122 Contexts first and alone. It is the declared 1.0 headline; 123 (dev radar) is only valuable once Contexts exists because it feeds its facets.

## Cut or defer (proposals, owner decides)
- Defer 124 Claude Ask panel to 1.1. It is a separate product surface (auth, streaming, history) with no dependency from 1.0 exit signals; it dilutes the Contexts headline.
- Defer 013 layout loadouts into 122 as one facet instead of a milestone item; the loadout is a Contexts facet already.
- Defer 021 community theme packs and 065 plugin install by URL to 1.1: they need 112 plus a versioned plugin API (126) to be safe, and the 1.0 bar ("installable by a stranger on fresh Arch") does not need third-party packs.
- Cut 040 demo/onboarding mode from 1.0 unless 077 (screenshots, GIF) is blocked without it; goldens plus `shot.sh --fresh` already produce the README material.
- Keep 127/128 (portability, fresh-Arch install test): they are the actual 1.0 exit signal and the cheapest insurance against a broken first impression.
- Treat 125 (signature motion) and req_004 (canvas applets) as 1.1: they are the showcase job, high effort, no dependency from anything else.

## Risks to watch
- The typography change (item_115) touches every screen; it should not merge to main without the owner's contact-sheet sign-off, and the blur branch should land first so the two do not fight over the same files.
- Branch night/roadmap-next starts from main with 54 unreviewed blur commits; merging it before the blur review mixes the two reviews.
- Motion: the new reduce-motion setting only governs tokens and Commons.Tween; any future NumberAnimation with a literal duration fails token-lint, which is the intended guard.
- Headless renders cannot grab input, so popups with focus grabs (the new tray menu), Esc handling and real scrolling still need a human check on the live bar.

## Open questions for the owner
- Is Claude Ask 1.0 or 1.1? (changes the whole 0.60 shape)
- Is the proportional UI face (Noto Sans + mono for data) the Corvus Dataslate direction you want, or only a step?
- Should bar popups (Wi-Fi, Bluetooth) be dismissible with Esc, at the cost of taking keyboard focus?

# Acceptance criteria
- AC1: The note states what to prioritise, cut and defer after 0.40, with reasons.
- AC2: Scope boundaries and operator impact are explicit.
- AC3: Nothing here is a commitment; any item becomes backlog only after the owner's decision.

# Definition of Ready (DoR)
- [ ] Problem statement is explicit and user impact is clear.
- [ ] Scope boundaries (in/out) are explicit.
- [ ] Acceptance criteria are testable.
- [ ] Dependencies and known risks are listed.

# Companion docs
- Product brief(s): (none yet)
- Architecture decision(s): (none yet)

# References
- logics/roadmap/road_001_archeotech_shell.md
- logics/architecture/adr_032_post_audit_direction_corvus_dataslate_base_add_on_identity_packs_contexts_as_1_0_headline.md
- https://docs.noctalia.dev/noctalia-shell/
- https://alternativeto.net/software/dankmaterialshell/

# Backlog
- none
