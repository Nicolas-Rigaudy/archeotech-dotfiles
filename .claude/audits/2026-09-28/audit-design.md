# Archeotech design-system and visual-design audit

Scope: `~/Projects/archeotech-shell` (123 QML files, ~13.5k lines in Modules/Widgets), docs, packs, and the ADRs and STYLE_GUIDE in the dotfiles repo. Read-only. Counts come from grep over `Modules/ Widgets/ Commons/` unless stated otherwise. Date: 2026-09-28.

---

## 0. Verdict

The **engine** is good for a hobby shell. It has a reactive singleton overlay (pack › theme.json › fallback), pack settings driven by dotted token paths, versioned style delegates, and FX layers. The **design system on top of it is thin**, and the **visual identity has split into two looks**:

1. **No semantic or component token layer.** `Appearance` is one flat bag that mixes palette primitives, a few ad-hoc semantic aliases (`surfaceCard`, `stateHover`), and pack-specific material (`steel`, `copperLit`). Components reach straight for primitives (`colors.overlay0`, `colors.surface0`) and literal pixels. Across Modules/Widgets, spacing tokens are used **28×** and literal spacing/margins **226×**.
2. **The flagship pack is written into the base components.** `Appearance.frameChamfer` (a *shape* flag) has become the "am I Grimdark?" switch. There are **72 references across 20 files**, including 10 in each of the four bar popups. Base primitives contain copper, steel and teal branches (`SegmentedControl.qml:33-88`, `GlassButton.qml:97-110`). This contradicts adr_026/027: packs are meant to be additive, and the base is meant not to know about them.
3. **The "glass" is not glass.** Quickshell layers run with `noblur` (adr_008; `mango/config.conf:593`) and panels are mantle at **0.93–0.96 alpha** (`Appearance.qml:356-357`). What ships is a dark satin slab with a top-lit gradient. "Glass + 3D/metal console" is an aspiration, not what renders.
4. **Motion has two vocabularies.** The M3 curve tokens exist, but 46 call sites use `Easing.OutCubic` against 35 that use `Commons.Anim/ColorAnim`. 7 of the 12 duration tokens are never used, and 29 durations are literals.
5. **Accessibility is essentially absent.** There is no focus ring, no disabled state, no reduced-motion setting and no UI-scale control. `overlay0` is the second most common text colour (44 sites) at 2.1–3.4:1 contrast, and light themes fall below AA for secondary text.

The fastest route to "a whole other level" is not more ornament. It is (a) a semantic role layer with **surface recipes**, which pull the Grimdark branches back out of base code, (b) about 8 missing primitives, and (c) one motion grammar and one type scale applied everywhere. Those three make the base look expensive and let a pack be a true reskin.

---

## 1. Token architecture

### 1.1 Layering (primitive → semantic → component)

| Layer | What exists | Assessment |
|---|---|---|
| Primitive | 26 Catppuccin-shaped palette keys (`Appearance.qml:294-327`); radius 6/8/10/14/18/999; spacing 4/6/8/10/12/16; font 11/12/13/14/16/16; 12 durations; 12 bezier curves | Present, but the scales are too tightly stepped (see 1.2) |
| Semantic | `accent`, `error/warning/success/info`, `recessedTrack`, `glassBg*`, `glassBorder`, `glassSheenTop/Bot`, `surfaceWarm`, `surfaceCard`, `stateHover/Pressed`, `accentAlpha/Border` | Partial and inconsistent. There are **no text roles** (`textPrimary/Secondary/Muted/Disabled/OnAccent`), **no border roles**, **no elevation roles** and **no focus colour**. Components choose raw palette steps instead |
| Component | None. `bar{}` is the only component group; `sheen{surface,control,knob}` (adr_031) is the right idea but covers only one attribute | Missing |
| Pack material | `steel{hi,md,lo,edge,lip}` and `copperLit` sit in the *base* singleton (`Appearance.qml:250-256, 321`) | Pack-specific concepts leaking into the base API |

Evidence that components bypass semantics. These are the text colour roles actually used (`color: Commons.Appearance.colors.X`):
`text` 44, **`overlay0` 44**, `subtext0` 28, `accent` 27, `subtext1` 19, `overlay1` 12, `base` 11, … `surface1` 2 (as icon or text colour, e.g. `EmptyState.qml:26`).

adr_026 lists "colour, radius, spacing, **opacity, blur, elevation**, type scale" as the pack token tree. **Opacity, blur and elevation tokens do not exist.** Alphas are hardcoded in `_rgba(...)` calls (0.15/0.40/0.20/0.30/0.58/0.85/0.93/0.96) and in shadow literals.

**Dead tokens** (0 uses outside Appearance): `glassBg`, `glassBgLight` (only read internally), `baseAlpha`, `mantleAlpha`, `font.sizeXl`, `font.sizeIcon`, `anim.effectsFast`, `anim.effectsSlow`, `anim.spatialFast/Default/Slow`, `curve.standard/standardAccel/emphasized/expressiveFast/Slow/Effects`. `anim.enter` and `anim.exit` have 1 use each. Packs retune these tokens (grimdark `anim.spatialDefault: 560`, `effectsMed: 240`) with **no visible effect**. THEME_PACK.md's claim that "every component reads these tokens" is false.

### 1.2 Scales

- **Type:** 11/12/13/14/16. That is five steps within 5px and there is **no display or headline tier**. Components hardcode the large sizes instead: 18, 20, 22, 24, 30, 34, 36, 40 (e.g. `PaneHeader.qml:20` 30, `AboutPane.qml:52` 36, `Dashboard.qml:77` 40, `MediaFull.qml:71` 40, `Launcher.qml:780` 34), and the small ones too: 9 and 10 (`ConnectionsPane.qml:120,363,539,544`, `MediaFull.qml:131,137`, `ColorSchemeBody.qml:125,256`). **There are no weight tokens.** Weights in use: Medium 21, `bold:true` 9, DemiBold 3, Bold 2, Light 1. **There are no tracking tokens.** letterSpacing 1.5/1.2/1.0 is ad-hoc in 7 files, used for caps labels.
- **Font sizes:** 171 tokenised against **82 literals**. Worst offenders: `ConnectionsPane.qml` 20, `Launcher.qml` 7, `MediaFull.qml` 6, `NotificationCenter.qml` 5, `WifiPopup.qml`/`BtPopup.qml`/`MediaCompact.qml`/`SettingsSidebar.qml`/`AboutPane.qml` 4 each. Literal histogram: 16×14, 14×13, 13×11, 11×9, 12×6, 20×5, 9×4, 10×4 …
- **Spacing:** 4/6/8/10/12/16 is not a grid (6 and 10 break a 4-pt rhythm) and **tops out at 16**. Literal usage: 8 (57), 6 (39), **24 (29, with no token)**, 0 (25), 4 (22), 10 (21), 12 (17), 2 (15), 16 (14), 5 (9), 20 (7), 14 (6), 3, 9, 1. Only 28 of 254 spacing/margin assignments use a token.
- **Radius:** 71 tokenised against 22 literals, which is the best-adopted scale. The steps 6/8/10 are only 2px apart and hard to tell apart visually. Components also compute `track.radius - 3` (`SegmentedControl.qml:78,109`) and `radius: 4` (`SliderRow.qml:66`).
- **Elevation / shadow:** there is no token. Blur literals across 29 `RectangularShadow` sites: 6, 7, 8, 10, 12, 14, 16, 20, 32. Alpha multipliers: 0.30, 0.33, 0.35, 0.4, **0.45 (10)**, **0.5 (8)**, 0.55 (4). Offsets vary from 1.5 to 5. That is effectively 9 elevations with no names.
- **Sheen:** adr_031 scale (`Appearance.qml:41-54`) is well done, but it does not cover steel (`SegmentedControl.qml:83` `Qt.lighter(steel.hi, 1.18)`) or the 19 other `Qt.lighter/darker` literals in Modules/Widgets (1.08–2.3).

### 1.3 Hardcoded colour counts

| Kind | Modules | Widgets | Commons | Services | packs |
|---|---|---|---|---|---|
| `"#hex"` literals | 9 | 0 | 53 (fallbacks, OK) | 25 | 10 |
| `Qt.rgba(` | 24 | 14 | 25 | – | 2 |

`Qt.rgba(0|1,0|1,0|1,α)` black/white overlays: **43**. Worst spots:
- `Modules/Shell/FrameFx.qml:122-126, 172-176`: **9 hex literals that duplicate `Appearance.steel`** (`#333f4d/#28313d/#1c232d`, the same as `packs/grimdark/tokens.json` `panels.steel`). The consequence is a real bug: **the Ordos and Forge registers override `panels.steel`, but the frame bands and corner plates do not follow.** Popups re-livery and the bezel does not. The in-code comment "Grimdark armour is always this cool steel" (FrameFx ~168) contradicts `_register_note` in tokens.json.
- `Modules/Shell/Sides/Bar.qml:378-379`: seam groove `Qt.rgba(0,0,0,0.55)` / `Qt.rgba(1,1,1,0.06)`.
- `Commons/Primitives/ToggleSwitch.qml:34-36`: off-track gradient in black/white rgba, which breaks on light themes.
- `Commons/Primitives/SegmentedControl.qml:44,53`: `Qt.rgba(0,0,0,0.5)` and `0.55` steel track.
- `EditOverlay.qml` (5), `WorkspacesWidget.qml` (3), `ColorSchemeBody.qml` (3).
- Pack delegates repeat fallback hexes (`packs/hud/styles/GlassButton.qml:22,33`; `packs/grimdark/styles/GlassButton.qml:16-22`), which is acceptable.

### 1.4 Engine-level token issues

- `_mergedPack` (`Appearance.qml:158-166`) deep-clones the pack through `JSON.parse(JSON.stringify())` on every packData or packSettings change. It is cached as a property, so it is fine for now, but every token getter depends on it, so **any pack-setting slider drag re-evaluates every token binding in the shell**. adr_027 itself listed "cache merged token set" as a mitigation. Consider splitting it into per-group merged objects.
- `inherits` is documented but not resolved (`Appearance.qml:124-125`). Every pack is single-level.
- `theme.json` `mode` is **never read by Appearance**. Nothing adapts to light mode (see 2.4).
- Token lookups fail silently. There is no lint or schema for `tokens.json`, and a misspelled key simply falls back (adr_027 "document + lint it" was never done).

---

## 2. Primitive library

### 2.1 Inventory (`Commons/Primitives`, 10 files, 897 lines)

| Primitive | Files using | Notes |
|---|---|---|
| StateLayer | 12 | The right idea. Hover/press only; no focus or disabled state; `layer.enabled` is mentioned only in a comment |
| SegmentedControl | 7 | Hand-rolls its own hover (`MouseArea` + `_hov`, `:100-143`) instead of using StateLayer; literal `Easing.OutCubic` (`:89-90`); glyph `pixelSize: 14` (`:121`); **Grimdark branch inside the base primitive** |
| ConsoleChrome | 6 | Grimdark-only ornament living in base Commons |
| PanelShadow | 6 | Good single-light-source rule; blur 16 / α 0.45 literal |
| BarSegment | 5 | Grimdark-only; builds its rivet path from `panels/rivet.png` by convention (`:17`) |
| GlassButton | 5 | Only 5 files. There is no icon-button, ghost or danger variant; label hardcoded to `sizeSm`; `implicitHeight: 30` literal |
| MetalSurface | 2 | Good consolidation (plain / 9-slice / steel), but only DashCard and SettingsCard use it. Popups, toasts, OSD and launcher rows hand-roll their surfaces |
| EmptyState | 2 | icon `surface1` on glass = **1.5–1.9:1** contrast (invisible) |
| ToggleSwitch | 2 | **Fake-toggle bug**: `onClicked: { root.checked = !root.checked; … }` (`ToggleSwitch.qml:75`) overwrites the consumer binding `checked: root.checked` (`ToggleRow.qml:51`). After the first click the switch stops following real state. This breaks design rule 6 ("no fake toggles") |
| StyleDelegate | 1 (GlassButton) | adr_027 promised about 6 curated seams (GlassButton, DashCard, SegmentedControl, BarPill, PanelShadow, a form row). **1 shipped** |

### 2.2 Components hand-rolled repeatedly (the gaps)

1. **PopupCard / NeckPanel.** `WifiPopup`, `BtPopup`, `CalendarPopup` and `HoverCard` each carry an almost identical ~75-line block: screen-space sheen `_winY` hack, scale 0.85 + opacity 150ms OutCubic, PanelShadow, a hand-built `Shape` path with `PathArc` neck, steel vs glass ternaries (**10 `frameChamfer` refs per file**), and a ConsoleChrome collar. A `diff` of Wifi against Bt shows only id and anchor names differ. This is the single largest duplication, and it is why popups can't be restyled by a pack without code.
2. **IconButton** (28×28 box, glyph, hover wash). 17 literal `width: 2x; height: 2x` boxes (Launcher 5, WallpaperPicker 2, ThemeCarousel 2, Wifi/Bt/Calendar/Tray/ColorScheme/Dashboard/SliderRow). 32 hand-rolled `hoverEnabled: true` MouseAreas and 30 `containsMouse ? … : …` ternaries remain alongside the 12 StateLayer users.
3. **ListRow / MenuItem** (icon + title + subtitle + trailing, with hover and selected states): network rows, BT device rows, launcher results, notification rows, plugin rows, audio sinks. Each has its own padding, selection colour and radius.
4. **Spinner / BusyIndicator**: 7 copies of `RotationAnimator … duration: 900` (`ConnectionsPane.qml:171,298,329,406,499`, `WifiPopup.qml:179`, `BtPopup.qml:191`).
5. **TextField**: 5 raw `TextInput`/`TextField` instances with three different focus treatments (`SettingsSidebar.qml:47-49` border 2px, `Launcher.qml:551-562`, `TextFieldRow.qml:56-57`, `AudioPane.qml:179`, `ConnectionsPane.qml:589` accentBorder).
6. **Slider**: Qt Controls `Slider` restyled only in `SliderRow.qml:51-77`. **ComboBox (2), ToolTip (1, `ConnectionsPane.qml:547`) and ScrollBar (11 `ScrollBar.vertical`) use the unstyled Qt Basic/Fusion look**, which is off-identity on every theme.
7. **Heading / Label / Caption text**: 248 `Text {}` elements, each repeating `font.family` + `pixelSize` + `color`. There are no `StyledText`/`Heading`/`Caption`/`Mono` wrappers, which is why the type scale drifts.
8. **Badge / Chip / Tag / ProgressBar / Gauge**: hand-rolled in Dashboard (stat bars), OSD (`Osd.qml:113`), MediaFull progress (`:115`, 950ms linear) and ColorScheme swatches.

### 2.3 States coverage

- **Hover:** mostly present, in three different idioms (StateLayer wash, colour ternary, `_hov` flag).
- **Pressed:** three press depths: GlassButton 0.96, StateLayer 0.98, ToggleSwitch thumb 0.92.
- **Focus:** only text fields show `activeFocus`. **No primitive has a focus ring.** Keyboard handling exists only in Launcher (7), LayoutPicker (7), SettingsSidebar (3), Strip/BarPanel (Esc). GlassButton, SegmentedControl, ToggleSwitch and list rows are unreachable by keyboard.
- **Disabled:** 15 scattered `enabled ?` refs and **no disabled token or treatment in any primitive**.
- **Selected/active:** "accent fill + base-coloured text" (GlassButton, SegmentedControl, Wifi toggle) competes with "accentBorder outline" (10 uses) and "accentAlpha wash" (3 uses) for what should be one meaning.

### 2.4 Accessibility and contrast (computed; glass ≈ mantle, since alpha 0.96 and no blur)

| Theme | text/glass | subtext0/card | overlay1/card | **overlay0/card** | base-on-accent |
|---|---|---|---|---|---|
| macchiato | 10.9 | 5.6 | 3.5 | **2.7** | 6.8 |
| latte | 6.6 | 3.4 | 2.2 | **1.8** | 4.8 |
| nord-light | 10.3 | 6.5 | 3.6 | **2.3** | **3.5** |
| gruvbox-light | 9.2 | 4.8 | 2.7 | **2.0** | **3.3** |
| tokyo-night-day | **4.0** | **2.9** | 1.6 | **1.35** | **3.3** |

- `overlay0` is used as text 44 times (hints, secondary labels, EmptyState title) and fails 3:1 on every theme on cards. `EmptyState` hint is `overlay0` at opacity 0.7 (`EmptyState.qml:41-45`), roughly 1.9:1 on Macchiato.
- In **tokyo-night-day, body text fails AA** (4.0 on glass, 3.6 on cards).
- **Light themes are not designed, only recoloured.** `glassSheenBot` blends mantle 22% toward `#000000` (`Appearance.qml:375`), which greys light panels. Every shadow is black at 0.45–0.55. `recessedTrack` is black at 0.22. The ToggleSwitch off-track is black rgba. `base` on accent drops to 3.3–3.5. The palette also has hacks: nord-light maps `mauve` → `#5e81ac` (blue) and `rosewater` → text colour.
- **Reduced motion:** there is none (0 matches for reducedMotion, animScale or animationsEnabled). The expressive overshoot curves (`expressiveFastSpatial` y=1.67) have no opt-out.
- **Scaling / HiDPI:** no UI-scale token (0 matches for devicePixelRatio, scaleFactor or uiScale). Pixel sizes are logical px, so Wayland fractional scaling works, but there is no in-shell text or UI scale the way top shells offer. 1px and 1.4px hairlines (`ConsoleChrome.qml:50`, popup `strokeWidth: 1.4`) will smear at 1.25/1.5 scale. `renderType` is never set.

---

## 3. Visual-language coherence

### 3.1 Five materials in one shell
1. **Base "glass"**: 96% opaque mantle, top-lit screen-space gradient, no blur (adr_008). It reads as *satin plastic*.
2. **Skeuo 3D controls**: gradient knobs, recessed grooves, drop shadows (ToggleSwitch, Slider, SegmentedControl, workspace pills in `e94770f`).
3. **Flat mode**: glass without depth (adr_029). A reasonable axis.
4. **HUD**: `hud` pack with grid texture, accent glow, window brackets and a sharp GlassButton delegate. It is a demo, not a system.
5. **Grimdark NMM steel + copper**: matte slabs, rivets, gussets, bolted collars, seams, chamfers, Cinzel display. It is the most developed and the most invasive.

In base mode, 1 + 2 + 3 hang together acceptably, but the "3D" is applied unevenly. Controls are very dimensional (knob sheen 1.22), while panels are nearly flat and nothing on the screen justifies the light source. In Grimdark mode, 5 takes over via `frameChamfer` branches while structures that ignore it (OSD, toasts, launcher rows, settings panes, Qt Controls widgets) stay glass-styled. **The pack is only partly applied.**

### 3.2 Identity drift from the brief
STYLE_GUIDE (Corvus / Shadow Spears / Raven Guard) asks for: **stealth, shadow, mauve/violet accent, minimal sigils, "never chaotic", subtle neon, HUD separators, ritual lexicon.** The flagship pack went **aged copper + teal on gunmetal with rivets and gussets** (`packs/grimdark/tokens.json` `accent: "peach"`, mauve demoted to `#7c5ba6`). That is Mechanicus/Legion, a different faction mood, and "rivets, gussets, collars, seams, bevels, ornaments" is the ornament density the guide warns against. The lexicon layer (adr_026 cat. 8, "codex/rite") was the cheapest identity lever and is unbuilt. The FLAGSHIP_HANDOFF stencil labels (CHRON/STATVS/VOX) are blocked on a font.

### 3.3 Typography
Everything is **FiraCode Nerd Font** (224 of 240 `font.family` refs), including paragraphs, settings descriptions and notification bodies. Mono-everywhere reads "terminal rice", not "designed console". Every top-tier shell pairs a proportional UI face with mono for data. The display hook (`font.display`) is used in only 11 places. Hierarchy comes almost entirely from colour (text vs subtext vs overlay), because sizes differ by 1px and there are no weight tokens.

### 3.4 Iconography
Good news: all 229 in-code glyphs are **nf-md (Material Design Icons via Nerd Font)**, one consistent set. App icons use `Image` or theme lookups (Papirus via system). Issues:
- Icon size is not tokenised (`sizeIcon` has 0 uses; literal 13/14/16/18/20/22/24/34).
- Nerd-font MDI has no weight or fill axis, so active/inactive icons can't do the Material Symbols fill-on-select trick that caelestia and end-4 use.
- Glyph baselines inside FiraCode metrics need per-site nudging.
- STYLE_GUIDE's "Papirus everywhere" is out of date. Document "nf-md for UI, Papirus for apps" as the rule.
- No custom sigil or iconography exists for the identity (ravens, spears, aquila-free geometric marks). `packs/grimdark/ornaments/` has only a filigree and a gothic corner.

---

## 4. Motion

**Tokens** (`Appearance.qml:477-518`): 12 durations and 12 M3 curves, plus `Anim.qml` and `ColorAnim.qml` wrappers. The design is good (enter-decel/exit-accel, and overshoot only on spatial properties).

**Reality:**
- Easing: `OutCubic` ×46, `OutQuad` ×3, `OutBack` ×2, `Linear` ×1, BezierSpline via the wrappers ×35. Of the curve tokens, only `expressiveDefaultSpatial` (17), `standardDecel` (3) and emphasized accel/decel (1 each) are used.
- Durations: `anim.fast` 68, `base` 19, `panel` 16, `enter`/`exit`/`effectsMed` 1 each, **literal 29** (150 ×10, 900 ×7 spinners, 90/70/120 in EditOverlay, 950 in MediaFull, 200 in Strip).
- **Per surface:**
  - Bar popups: scale 0.85 + fade, 150ms literal OutCubic (`WifiPopup.qml:39-40`, `BtPopup.qml:34-35`, `CalendarPopup.qml:37-38`, `HoverCard.qml:37-38`).
  - Strip panels: `anim.panel` (240) OutCubic on perp and axis (`Strip.qml:169,182`).
  - Toasts: `Commons.Anim` enter/exit (400/200) emphasized.
  - OSD: `anim.base` OutCubic.
  - FaceHost: `anim.base` OutCubic.
  - Result: **five surfaces with five motion signatures**, and packs cannot retune the popup ones.
- **Interruptibility:** almost everything is a `Behavior` on a bound property, so it retargets mid-flight. That part is good. There are no state machines. `Transition`/`states` appear once.
- **Missing compared with top shells:**
  - Shared-element / container-transform (bar pill → panel morph). caelestia's signature is the bar and panels being one continuous shape that grows. Archeotech already has the unified `FrameBackground` shape, so it is structurally positioned to do this and doesn't.
  - Staggered list entry (launcher results, notifications, dashboard cards).
  - `ListView add/remove/displaced` transitions (0 uses): notification dismiss, BT device appear, workspace add.
  - Spring physics (`SpringAnimation` 0 uses). DMS and caelestia use springs for pills and indicators.
  - A sliding highlight on list selection. The launcher colour-fades per row instead of moving one highlight.
  - Reduced-motion or global animation-scale token.
  - Number-tick and value-morph animations on readouts (the dataslate should count and scan).
  - Ambient motion for the identity: scanline sweep, phosphor flicker on update, and a sweep-on-open reveal for the HUD or dataslate.

---

## 5. Theme / pack engine: real capability compared with the docs

**Works as documented:** colour and palette overlay; accent by palette name; radius, spacing and font overrides; `frame.cornerRadius`; `window.cornerRadius/borderWidth` → mango; `material flat|matte`; `fx.texture/glow/brackets/bevel/rails/seams/rivets/ornaments`; `font.displayFile` via FontLoader; pack settings (`configSchema` → ConfigForm → dotted-path override); registers (deep-merge colours and steel); style delegates, filename-discovered and `minShellVersion`-gated.

**What a pack author will hit:**
1. **Tokens that do nothing**: `anim.spatial*/effectsFast/effectsSlow`, most `curve.*`, `font.sizeXl/sizeIcon`. More than half the motion tokens are dead, and 29 literal durations ignore the pack entirely.
2. **About 226 literal spacings and 82 literal font sizes.** A pack that changes `spacing` or `font.size*` gets only partial effect, and the layout goes uneven.
3. **Only one style seam (GlassButton).** Popups, cards, list rows, sliders, toggles, segmented controls, toasts and OSD cannot be structurally restyled. Worse, the base already contains Grimdark's structural choices, so a *second* identity pack (Gundam HUD, cyberdeck) needing chamfers would inherit copper and steel branches, because `frameChamfer` means "grimdark". The `hud` pack sets no `frame.corners`, so none of the "pack-aware" popup code benefits it.
4. **Grimdark-only concepts in the base API**: `steel{}`, `copperLit`, `panelPlate`, `bar.dividers`, `BarSegment`/`ConsoleChrome` rivet PNG by convention (`panels/rivet.png` hardcoded in `BarSegment.qml:17`, `Bar.qml:369`). A new pack must reverse-engineer these from Grimdark.
5. **The StyleDelegate `api` contract differs from its docs.** `STYLE_API.md` documents `colors {accent, surface, border, text, base}`, while the code passes `teal`, `steelHi/Md/Lo/Edge/Lip` and `chamfer` too (`GlassButton.qml:76-91`). The contract is already growing pack-specific fields. It should pass the semantic token set, not a Grimdark palette.
6. Delegates cannot own hover or press (the base StateLayer wash always draws on top), so a pack cannot restyle hover language.
7. `inherits` is unresolved, so there is no pack composition.
8. Cross-app theming for GTK, VSCode, Obsidian and Zen does not follow pack palettes (FLAGSHIP_HANDOFF TODO). A pack reskins the shell and kitty only.
9. `pack.json` edits need a full reload (PackRegistry scans at startup), with no error surface for bad JSON (`printErrors: false`, silent `catch (_) {}` at `Appearance.qml:70,141`).
10. **Docs rot:**
    - THEME_PACK.md still says style delegates and pack settings "arrive in later waves". Both have shipped.
    - `material`, `panels.steel`, `registers`, `frame.corners`, `bar.dividers` and the `fx.bevel/rails/seams/rivets` keys are undocumented in THEME_PACK.md.
    - FLAGSHIP_HANDOFF, FRAME_CORNER_HANDOFF and SHELL_VISUAL_DEV all point at `packs/shadow-spears/`, which does not exist (it is `packs/grimdark/`).
    - SHELL_VISUAL_DEV.md recommends `qs ipc call … open` + `grim` against the live session, **which directly contradicts the owner's standing "never touch the live shell" rule**. Fix or remove that section.
    - FLAGSHIP_HANDOFF says "Delete once merged".

---

## 6. Recommendations: prioritised design-upgrade plan

### P0: foundations (do before any more pack ornament)

| # | Item | Effort |
|---|---|---|
| P0.1 | **Semantic token layer** in `Appearance`: `text.{primary,secondary,muted,disabled,onAccent,link}`, `surface.{window,panel,card,raised,sunken,overlay}`, `border.{subtle,default,strong,focus}`, `state.{hover,pressed,selected,focus,disabled}`, `elevation.{0..4}` (blur, offset, alpha as one object), `opacity.{…}`. Derive each role from the palette **with mode awareness** (read `theme.json.mode`: light mode swaps the sheen direction, uses tinted rather than black shadows, and pins `onAccent` by contrast). Raise `muted` to at least 4.5:1 by blending, not by `overlay0`. Keep the primitives as they are. | M |
| P0.2 | **Surface recipes (Ambxst `StyledRect` model, already endorsed in adr_027).** One `Surface { role: "popup" \| "card" \| "control" \| "track" \| "chip" … }` primitive whose look comes from a per-role recipe `{fill gradient stops, border, radius, chamfer, shadow tier, sheen tier, ornament}` in tokens.json. Move MetalSurface's steel path into Grimdark's recipes. **Retire `frameChamfer` as an identity switch.** Base code should read `recipe.corners`, and copper, steel and teal should move into the pack's `tokens.json` recipes. This is the fix for the most important structural problem in the codebase. | L |
| P0.3 | **PopupCard primitive**: extract the ~75-line neck-popup chrome shared by Wifi, Bt, Calendar and HoverCard (shape, sheen, shadow, collar, enter/exit) with `attachSide` and `anchorX`. That removes about 40 `frameChamfer` refs and roughly 300 lines. | M |
| P0.4 | **Fix ToggleSwitch fake-toggle** (`ToggleSwitch.qml:75`): emit `toggled(!checked)` only and let the owner write the state. Audit other `x = !x` patterns in primitives. | S |
| P0.5 | **Focus and disabled states in StateLayer**: add a focus ring (`border.focus`, 2px, offset), a `disabled` opacity/desaturate treatment, and `Keys` Space/Enter activation. That gives keyboard reach to GlassButton, SegmentedControl, ToggleSwitch and rows for free. | M |
| P0.6 | **One motion grammar**: route every `NumberAnimation/ColorAnimation` through `Commons.Anim/ColorAnim` with semantic presets (`Motion.popupIn/Out`, `panelGrow`, `stateChange`, `listItemIn`), delete the dead tokens or wire them up, and add `anim.scale` (0 = reduced motion; also disables overshoot curves). The 46 OutCubic sites can mostly be mechanical replacements. | M |
| P0.7 | **Doc truth pass**: THEME_PACK (all keys actually supported), STYLE_API (actual `api`), rename shadow-spears → grimdark, delete the live-IPC/grim guidance in SHELL_VISUAL_DEV. Add a `tokens.json` JSON-Schema and a lint step (`logics`/CI) that fails on unknown keys. | S |

### P1: make the base look expensive

| # | Item | Effort |
|---|---|---|
| P1.1 | **Type system**: add a proportional UI face (e.g. Inter, Geist or IBM Plex Sans; Plex pairs with Plex Mono for a "technical" read) for body and labels, with mono reserved for data, readouts and code. Scale: 10 caption-caps (tracked +1.2, weight 600) / 12 body-sm / 13 body / 15 title-sm / 18 title / 24 headline / 34 display, with `weight.{regular,medium,semibold}` and `tracking.{caps,tight}` tokens. Add `Heading`/`Label`/`Caption`/`Readout` text primitives and replace the 82 literals. | M |
| P1.2 | **Spacing on a 4-pt grid**: 2/4/8/12/16/24/32 (add 24, which has 29 literal uses; drop 6 and 10). Add `padding.{control,card,panel}` component tokens. Codemod the 226 literals. | M |
| P1.3 | **Missing primitives**: IconButton, ListRow (leading/title/subtitle/trailing/selected), TextField, Slider, Dropdown (styled, to replace the 2 bare ComboBox), Tooltip, ScrollBar, Spinner, Badge/Chip, ProgressBar/Gauge. Each should take its look from a surface recipe (P0.2), and the curated StyleDelegate set grows through recipes rather than whole-QML delegates. | L |
| P1.4 | **Decide what "glass" means.** Either (a) enable layer blur for panels only (revisit adr_008 with mango's current SceneFX; `blur_layer=0` today) and drop alpha to about 0.78 with a 1px inner highlight and a noise layer, so it becomes real glass; or (b) rename the base material to **"satin / smoked slab"** and design for it: stronger inner-edge highlights, tighter elevation, subtle grain. Don't keep calling it glass. | M |
| P1.5 | **Elevation discipline**: 4 named tiers mapped onto the 9 blur/alpha combinations, with one light source (PanelShadow's rule applied everywhere). Tone down skeuo on tiny controls (knob sheen 1.22 is louder than the panels). Depth should grow with surface size, not shrink. | S |
| P1.6 | **Selection language**: one rule. Selected = accent-tinted fill plus a leading accent bar or indicator. Hover = neutral wash, not accent-hued: `stateHover` at 20% accent makes every hover look like a selection. Focus = ring. | S |
| P1.7 | **Signature motion**: container transform from bar or strip into panel using the existing unified `FrameBackground` path (grow the shape, crossfade content), a sliding selection highlight in the launcher and lists, staggered entry (30ms × index, capped at 6), `ListView` add/remove/displaced transitions for notifications and devices, and springs for workspace and segmented indicators. | L |
| P1.8 | Fix the FrameFx hardcoded steel → `Appearance.steel` (or a recipe) so registers re-livery the bezel. | S |

### P2: the "next-level" identity

**Concrete target, "Corvus Dataslate"** (reconciled with STYLE_GUIDE: stealth, violet, ritual, HUD precision):
- **Base look = "Obsidian console"**: smoked near-black slab (optionally real blur), cool violet-grey neutrals, **mauve as a single live signal** (active, focus, live readouts), hairline 1px dividers rather than boxes, generous 24/32 spacing, a proportional UI face plus mono readouts. Restrained, like a cockpit at night. This *is* the persona; today's base is generic Catppuccin rice.
- **Structure through typography and rules, not hardware**: tracked small caps section labels (`STATUS`, `COMMS`, `CHRONO`), index numerals (`01 / 04`), thin corner ticks on focused surfaces (HUD brackets already exist, so reuse them at component scale), and a segmented bar with seam dividers, but without rivets in the base.
- **Lexicon layer** (adr_026 cat. 8, unbuilt and the cheapest high-impact lever): a pack `lexicon.json` mapping display strings ("Settings" → "Codex", "Notifications" → "Vox", "Power" → "Rites of Shutdown", toast "Connected" → "Link sanctified"). Display-only and never config keys, as the ADR requires.
- **Ambient identity motion**: one scanline sweep on panel open (120ms, alpha 0.06), readout numerals that tick, a phosphor bloom on value change, all gated by `anim.scale`.
- **Sigil set**: 6–10 custom SVG marks (raven, spear, wing, geometric seals) for about-pane, lockscreen, empty states and pack badges, rendered in `text.muted` at low opacity.
- **Grimdark becomes one register of a pack family, driven by recipes**, not the base's hidden second personality. Legion (copper), Ordos and Forge stay as registers. Add a **Shadow Spears register** (violet on obsidian, bone accents, no copper) so the flagship matches the persona.

| # | Item | Effort |
|---|---|---|
| P2.1 | Lexicon layer + Settings toggle | M |
| P2.2 | Obsidian base redesign on the new tokens (P0/P1 prerequisites) | L |
| P2.3 | Section-label and HUD-tick component vocabulary (`SectionHeader`, `CornerTicks`, `Readout`) | M |
| P2.4 | Sigil asset set + EmptyState/About/Lock integration | M |
| P2.5 | Shadow Spears register; resolve `inherits` so registers and packs compose | M |
| P2.6 | Cross-app pack appliers (GTK/VSCode/Zen via palette templates) | L |
| P2.7 | Visual regression: `shot.sh` harness matrix (base/flat/hud/grimdark × dark/light) + contrast checker script run in CI (the Python contrast calc above is 20 lines) | M |

### Kill or consolidate

- **Kill `frameChamfer` as an identity flag.** Replace it with recipe fields. (72 refs.)
- **Move `ConsoleChrome`, `BarSegment` and `steel`/`copperLit`/`panelPlate`** out of base Commons into pack-provided recipes and ornament slots.
- **Retire the legacy 9-slice plate path** (`MetalSurface.qml:52-57`, `packs/grimdark/panels/plate.png`). The steel Shape path superseded it, and Grimdark ships both.
- **`angular` pack**: fold it into a base "shape: sharp" setting (it is only a radius override plus accent) or delete it.
- **`hud` pack**: either promote it to a real identity on recipes (the Gundam direction from STYLE_GUIDE §3.2) or demote it to an example in `examples/`. Right now it demonstrates fx, but on-screen it reads as an experiment.
- **`surfaceWarm` vs `surfaceCard` vs `surface0Alpha`**: three card fills. Consolidate them into the `surface.*` roles.
- Remove the dead tokens (§1.1) or wire them.
- Grimdark's unused ornaments and textures (`fx.ornaments: []`, `texture.source: ""`, while `brushed.png`, `brushed-metal.png`, `parchment.png` and `filigree.svg` still ship). Prune them or move them to the future Ordos and Forge registers.
- The four duplicated popup chromes → PopupCard (P0.3).

### Suggested sequencing
P0.4 + P0.7 (S, this week) → P0.1 + P0.6 (tokens, motion) → P0.3 + P0.5 → P0.2 recipes (move Grimdark onto them and prove there is no visual regression with shot.sh) → P1.1 / P1.2 codemods → P1.3 primitives → P1.4 glass decision → P1.7 signature motion → P2 identity.
