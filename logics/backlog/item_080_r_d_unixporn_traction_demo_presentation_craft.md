## item_080_r_d_unixporn_traction_demo_presentation_craft - R&D: unixporn traction + demo/presentation craft
> From version: 1.0.0
> Schema version: 1.0
> Status: Done
> Understanding: 95%
> Confidence: 90%
> Progress: 100%
> Complexity: Medium
> Theme: Research
> Reminder: Update status/understanding/confidence/progress and linked request/task references when you edit this doc.
> Indicators reviewed: 2026-08-21 16:01:07

# AI Context
- Summary: Research on what makes r/unixporn posts get traction and how to demo/present a shell so it lands — the "would this hit the front page" question. Covers common denominators of top posts, demo formats + tooling, screenshot/video composition, transparency/edge/shell-look craft, and a concrete audit of what archeotech should modify vs add before a launch post. Complements item_042 (feature inspiration); this one is about presentation, not features.
- Keywords: unixporn, traction, demo, presentation, screenshot, composition, wf-recorder, fastfetch, cohesion, launch
- Use when: Prepping a launch/showcase post, the README hero shot/GIF (item_077), or deciding polish that maximizes "wow" per effort.
- Skip when: Doing internal feature work with no presentation angle.

# Problem
- We can build a great shell and still get zero traction if the presentation is off. Need to know, concretely, what makes ricing posts land and whether archeotech's current look/demo would earn upvotes if posted.

# Scope
- In:
  - Common traits of high-traction r/unixporn posts; demo formats + tooling; screenshot/video composition; transparency/edge/shell-look craft; an archeotech-specific modify-vs-add audit; a pre-post checklist.
- Out:
  - Implementing the polish/demo assets (spawns follow-on items, e.g. item_077 README hero/GIF).

# Acceptance criteria
- AC1: A findings list of traction + demo/presentation factors, triaged for Corvus, is produced.
- AC2: A concrete modify-vs-add audit + pre-post checklist for archeotech is recorded and feeds the polish/launch backlog.

# AC Traceability
- request-AC1 -> This backlog slice. Proof: traction + demo-craft findings recorded below.
- request-AC2 -> This backlog slice. Proof: archeotech audit + checklist recorded below, feeding follow-on items.

# Findings (2026-08-21)

## Method
- Swept r/unixporn trend/meta commentary, ricing guides (beginner + presentation), the awesome-ricing tool list, Waybar "clean look" guidance, and the demo-tooling landscape (wf-recorder / OBS / Peek). Triaged against the Corvus persona and the current shell.
- Reality check up front: **the bar is high and the sub is saturated with Hyprland+matugen Material-You clones.** "Looks nice" is table stakes now. Traction comes from a *distinct identity executed cleanly*.
- **Architecture reframe (2026-08-21):** archeotech is a themeable-shell PLATFORM = a neutral glassmorphism BASE + swappable identity PACKS (Gundam-HUD, 40K dataslate, cyberdeck neon, later Star Wars/games). This is the traction engine, not a single look — see "Content strategy" below.

## Part 0 — Content strategy (the platform's traction multiplier)
- **One codebase -> many posts.** Post the clean-glass BASE for broad r/unixporn appeal (competes on the standard axis), then each theme PACK as its own post. Few rices can do a series from one setup — the "same shell, four identities" angle is itself the hook.
- **Cross-community reach.** Each pack earns a second audience: 40K dataslate -> r/Warhammer40k, cyberdeck -> r/cyberpunkgame, Gundam -> r/Gundam, plus r/unixporn. Fandom crossposts often out-perform the unixporn post.
- **Authenticity beat.** The 40K pack is the self-made Shadow Spears chapter — real lore reads, and dataslate/Inquisition-document looks are genuinely rare on the sub (vs. yet another neon bar). Strong first-pack candidate.
- **Sequencing:** flagship BASE first, then ONE pack end-to-end (recommend 40K dataslate — most distinctive + stress-tests the theming-depth architecture hardest). HUD/cyberdeck follow once the pack architecture is proven.

## Part 1 — What high-traction posts have in common (applies per-theme)
- **A single, instantly-readable identity.** The top posts telegraph a theme in one glance (a game, an anime, a color, a concept). Each archeotech pack must sell its identity in <1s; the base sells "clean, modern, cohesive glass".
- **Total cohesion.** Wallpaper, bar, terminal, launcher, notifications all share the *same* palette and corner/opacity language — "looks like a screenshot from a video game." Inconsistency is the #1 upvote-killer; top ricers refactor specifically to remove UI inconsistencies.
- **Restraint / negative space.** Neutral dark base + 1–2 accents used sparingly. Overstuffed bars read amateur. A centered clock/anchor gives symmetry.
- **A wallpaper that ties the room together.** The wallpaper is doing half the work — it must share the shell's palette and match the theme (raven/mecha/gothic-tech), not fight it.
- **Craft signals.** Consistent fonts everywhere, clean font rendering, aligned spacing, matched corner radii. These subconsciously read as "professional".
- **A title with a hook.** `[WM] Theme name` format; a named, lore-flavored theme ("ARCHEOTECH-OS", a rite/codex name) outperforms "my hyprland setup".

## Part 2 — The demo: formats + tooling
- **Formats that land (in order):** (1) one killer hero still, (2) a short looping GIF/MP4 showing *motion* (panels opening, workspace switch, visualizer, launcher search), (3) an album of 3–5 stills for depth. Motion is what separates memorable from forgettable now — hence item_042 A2 (cava) and A4 (motion language) matter for the demo, not just the product.
- **Capture (Wayland):** `grim` + `slurp` for stills; `wf-recorder` for scriptable/repeatable clips (ideal for a deterministic demo — pairs with the planned headless render harness item_067); **OBS** for a polished multi-scene walkthrough; **Peek**-style flow for quick GIFs (use wf-recorder -> ffmpeg/gifski on Wayland). Add these to docs/PACKAGES.md if we standardize a capture flow.
- **Post-production:** subtle rounded-corner + drop-shadow/padding framing on the final image reads more "designed"; keep it tasteful. Consistent 16:10 (native panel) or 16:9 crop.
- **Content of the shot:** show real usage — a tiled layout, terminal running `fastfetch`/a themed fetch, launcher open mid-search, a notification or the media/visualizer surface. Don't show an empty desktop; don't show clutter.

## Part 3 — Composition of the money shot
- **Pick one focal beat** and compose around it (e.g. launcher + HUD framing + visualizer in one frame). Symmetry/anchor helps.
- **Populate meaningfully:** 2–3 windows max, themed terminal content, no personal/identifying junk, no default app chrome that breaks the palette.
- **Wallpaper + fetch as signature:** a themed `fastfetch` with the ARCHEOTECH sigil/ASCII is a classic traction beat and reinforces identity.
- **Consistency pass before capture:** every visible element (GTK/Qt apps, terminal, browser if shown) must be themed — one unstyled window tanks the whole shot.

## Part 4 — Transparency / edge styling / shell-look craft
- **Transparency:** moderate, not maximal — blur + ~15–30% surface transparency reads "premium"; too much hurts legibility and looks cheap. Archeotech already uses high-opacity glass (ADR 008) — verify contrast holds in the hero shot.
- **Edges:** consistent corner radius across *all* surfaces; the HUD-framing kit (item_078) gives edges a deliberate identity vs generic rounded rects. This is a differentiator, not just polish.
- **Spacing/padding:** uniform gaps; the bar shouldn't be crammed. Group modules into pills/segments; drop any module that isn't earning its space.
- **Type:** one type system, all-caps mono micro-labels for the HUD feel, comfortable sizes. Clean rendering (hinting) matters in stills.
- **Accent discipline:** mauve as the single hero accent; secondary accents rare. Matches STYLE_GUIDE and the "1–2 accents" traction rule.

## Part 5 — Archeotech audit: modify vs add
- **Modify (tighten what exists) — mostly the task_002 coherency slices already cover this:**
  - Finish coherency audit slices 2–5 (item_035–038): selector unification, flat-mode sweep, dedup, tokens — this IS the "remove all inconsistency" work that top posts require.
  - Verify glass contrast/legibility for a hero shot (ADR 008 high-opacity path).
  - Bar module discipline: audit for anything overstuffed; group into pills.
  - Ship/curate a **signature wallpaper** that shares the palette + raven/mecha theme (half the shot's impact).
  - Themed `fastfetch`/terminal preset for demos.
- **Add (net-new, high demo ROI):**
  - HUD framing kit (item_078) — gives edges a unique identity.
  - cava visualizer (item_079) — motion beat for the GIF.
  - Motion language pass (item_042 A4) — makes the video read "premium".
  - A standardized capture/demo flow (grim/slurp + wf-recorder script; ties to headless harness item_067).
  - README hero + demo GIF + v1.0.0 tag (item_077 already exists — this research feeds it).

## Part 6 — Pre-post "front-page" checklist (go/no-go)
1. Does the shot telegraph the theme in <1s?
2. Is every visible surface on the same palette + corner/opacity language? (zero unstyled windows)
3. One hero accent (mauve), used sparingly?
4. Wallpaper shares palette + matches lore?
5. Bar/panels uncluttered, uniform spacing, grouped modules?
6. Is there a motion beat (GIF) — panel/workspace/visualizer?
7. Themed fetch + real (non-clutter) window content?
8. Consistent fonts + clean rendering?
9. Final image framed (padding/shadow), correct aspect crop?
10. Title uses `[MangoWC] <lore theme name>` with a hook?

## Disposition
- This research feeds task_002 (polish) and item_077 (README/demo assets). No auto-created follow-ons beyond A1/A2 already promoted (item_078/079). Candidate net-new items if the user wants them tracked: **"signature wallpaper + themed fastfetch preset"**, **"standardized capture/demo flow (grim+wf-recorder)"**, and **"motion language pass"** (item_042 A4). Left pending the user's call.

# Decision framing
- Product framing: Not needed
- Architecture framing: Not needed

# Links
- Product brief(s): `prod_001_archeotech_shell`
- Architecture decision(s): (none yet)
- Request: `req_000_archeotech_shell_dotfiles`
- Primary task(s): `task_001_orchestrate_archeotech_shell_delivery`

# Priority
- Priority: High
- Rationale: Directly de-risks the 1.0 launch/showcase; presentation determines whether the build gets any traction at all.

# Notes
- Generated locally by logics-manager.
