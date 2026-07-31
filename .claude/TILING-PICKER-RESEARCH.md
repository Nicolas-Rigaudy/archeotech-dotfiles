# Tiling-layout picker — research + design

Sibling to `TESTING-PIPELINE-RESEARCH.md`. Spec: `ROADMAP.md` → "Tiling-layout
picker with visual previews". Built against **mangowm 0.15** (mmsg JSON IPC, see
`DECISIONS.md [2026-07-30]`).

## Phase 1 — prior art (targeted, not deep-research)

**How other tiling WMs/shells let you pick a layout, and what reads best.**

| System | Representation | Interaction |
|---|---|---|
| **awesome** `awful.widget.layoutlist` | Tiny **glyph icon per layout** (the classic dwm-lineage pictograms: master bar + stack lines). Icon-only or icon+name. | Click to set; also the taglist keybind cycle. Layoutbox in the bar shows current. |
| **qtile** `CurrentLayout`/`CurrentLayoutIcon` | Single **icon of the *current* layout** only (PNG per layout, e.g. `layout-monadtall.png`). Not a picker grid. | Bar widget; click cycles next/prev. No visual menu of all layouts. |
| **i3/sway** | **No visual picker.** Text: `layout tabbed|stacking|splith|splitv`. Some bars show a small mode indicator. | Keybind only. |
| **Hyprland `hyprexpo`** | **Live workspace thumbnails** (real framebuffer snapshots) in a grid — an *exposé*, not a layout-arrangement diagram. | Click / gesture / keyboard. Proves the "grid of tiles, click to pick" interaction, but it previews *workspaces*, not *layout shapes*. |
| **KDE / GNOME / macOS Mission Control** | Live window/workspace thumbnails. Overview, not layout-shape selection. | Click / arrows. |
| **PaperWM** | Concept only (scrollable strip) — no picker. Informs the `scroller` diagram. |

**Two distinct visual idioms, and the one that reads best:**
1. **Live thumbnails** (hyprexpo/KDE/Mission Control) — expensive, previews *content*,
   answers "which window/workspace," not "which arrangement." Wrong tool for us.
2. **Schematic mini-diagram** (awesome/qtile dwm-lineage icons) — a handful of
   rectangles in the layout's arrangement. Cheap, instantly legible, scales to any
   number of layouts, doesn't need real windows. **This is what the spec asks for and
   what reads best for choosing an *arrangement*.**

**Design conclusions carried into Phase 2:**
- **Schematic rectangles, not thumbnails.** Each card = a fixed set of `Rectangle`s laid
  out the way that layout tiles windows (dwm/awesome idiom, modernised to our tokens).
- **Grid of cards + name + hover description**, current layout highlighted — matches our
  own `ThemeGridBody`/`WallpaperPickerBody` and the awesome layoutlist mental model.
- **Interaction, richest-that's-cheap:** click to set (primary), arrow-key move +
  Enter, and — since these all map to a mango dispatch — **show each layout's keybind on
  the card** so the picker doubles as the quicksheet the user asked for.
- **Accent the master/primary region** in the mauve accent, the rest in a muted glass
  fill — so the *shape* of each layout reads at a glance without labels.

## mango 0.15 — the ground truth for the diagrams

`setlayout <name>` (dispatch) sets the current tag's layout. Full layout set
(from the mango wiki + this machine's `config.conf`):

| name | shape to draw | notes |
|---|---|---|
| `scroller` | 1 centred tall rect, slivers peeking L/R | horizontal PaperWM strip; our daily default |
| `vertical_scroller` | 1 centred wide rect, slivers peeking top/bottom | vertical strip |
| `tile` | left master (~55%) + right stack of 2–3 | classic master-stack (Hyprland master) |
| `center_tile` | centre master + stack split to both sides | master-stack, master centred |
| `right_tile` | master on right + stack on left | mirror of tile |
| `vertical_tile` | master on top + stack row below | master-stack rotated |
| `dwindle` | recursive BSP: big, then half, then quarter… | spiral split |
| `grid` | even N×M cells | balanced grid |
| `vertical_grid` | even grid, column-major | |
| `monocle` | 1 full-bleed rect | one window fullscreen |
| `deck` | master + a fanned/stacked pile on the side | others overlap in the stack slot |
| `vertical_deck` | master + stacked pile below | |
| `fair` | near-equal tiles, balanced rows/cols | like grid but fills fairly |
| `vertical_fair` | fair, vertical bias | |

**Cards to show (spec set + a couple extra), in order:**
`scroller, tile, dwindle, grid, monocle, fair, deck, center_tile, vertical_scroller`.
The rest stay reachable by keybind/`setlayout`.

**Current wiring (`config/.config/mango/config.conf`):**
- `Super+T` = `switch_layout` → cycles **`circle_layout`**, currently only
  `scroller,tile,dwindle,fair,grid,monocle` (6 of 14).
- Direct binds: `Super+Space`=scroller, `Super+Alt+Space`=tile, `+G`=grid, `+M`=monocle,
  `+V`=vertical_scroller, `+D`=deck, `+S`=dwindle.
- **User asks:** make `Super+T` cycle *all* layouts, and expose the per-layout keybind in
  the picker as a quicksheet. → extend `circle_layout` to the full set; the picker reads
  the same bind map.

## Answer: "grid where the focused window auto-becomes master, others small on the side"

**No mango layout does focus→master automatically.** The master-stack layouts
(`tile`, `center_tile`, `right_tile`, `vertical_tile`) give you exactly the *shape* you
want — one big master + smaller windows stacked to the side — but the master slot is the
first window in the list, not "whatever I'm focused on." mango's `new_is_master=1`
promotes *newly opened* windows to master, not on focus.

Practical options:
- **`tile`** (or `center_tile` if you want the big one centred) + press **zoom** to
  promote the focused window to master when you want it. That's the manual version of
  what you described — one keypress, not automatic.
- **`deck`** keeps a master pane and *decks* (overlaps) the rest in the stack slot — the
  focused stack window comes to the front of the pile. Closest to "big one + the others
  tucked small on the side," still not auto-promote.
- If you genuinely want **automatic** focus→master, it's not a layout — it's a tiny
  `mmsg watch focusing-client` → `mmsg dispatch zoom` daemon (~15 lines). Not built here;
  say the word and I'll add it as a script. `ponytail:` deferred, add only if the manual
  zoom proves annoying in daily use.

Recommendation: run **`tile`** and bind zoom; reach for `deck` when you have many stack
windows. Both are in the picker so you can feel them without memorising names.

## Phase 2 — design

**Files (mirrors the wallpaper/theme pickers exactly):**
- `Widgets/Appearance/LayoutPickerBody.qml` — the grid of cards + the layout data table
  (diagram recipe, name, description, keybind). All the logic lives here.
- `Modules/Shell/Panels/Content/LayoutPicker.qml` — thin panel wrapper (injects
  `panelRoot`, exposes `implicitAxis`), same as `Content/WallpaperPicker.qml`.
- `Services/Shell/PanelRegistry.qml` — add `layout: { content, side:"bottom", size, axisSize:"auto" }`.
- `shell.qml` — add `IpcHandler { target:"layout"; toggle()/open()/close() }`.
- mango `config.conf` (private repo) — (a) extend `circle_layout` to all shown layouts so
  **Super+T cycles everything**; (b) add **Super+Shift+T** → `qs ipc call layout toggle`
  for the picker. Super+T stays the blind cycle; Shift+T is the visual pick.

**Card = static QML mini-diagram.** A JS table drives everything — no per-layout QML:
```
{ name:"tile", label:"Tile", key:"Super+Alt+Space", desc:"Master + side stack",
  rects:[ {x,y,w,h,master:true}, ... ] }   // coords normalised 0..1 in the diagram box
```
A `Repeater` draws each rect as a rounded `Rectangle`; `master:true` → mauve `accent`
fill, others → muted `surface`/glass fill. So the *shape* reads instantly. Diagram box
~4:3, name below, keybind in a small chip (the quicksheet), one-line `desc` on hover.

**Diagram recipes (the arrangement each card shows):**
- `scroller` — centre tall master + thin peek slivers L/R
- `tile` — left master (55%) + 2 stacked right
- `dwindle` — big left, then halves recursively (spiral)
- `grid` — even 2×2
- `monocle` — one full-bleed rect
- `fair` — 3 near-equal (2 top, 1 wide bottom)
- `deck` — left master + offset overlapping pile on the right
- `center_tile` — centre master + stack split to both sides
- `vertical_scroller` — centre wide master + peek slivers top/bottom

**Active highlight (robust to the symbol problem):** the picker highlights the layout it
last set (authoritative — the whole point is you just picked it). On open it seeds from
`MangoWC.layoutFor(screen)`, which is the terse `layout_symbol` (`T`,`S`,… — confirmed
live, no name in the JSON) via a small symbol→name map (`T`→tile, `S`→scroller confirmed;
others best-effort, unknown → no seed). No brittle `layout_index` reverse-engineering.

**Selection:** click a card → `CompositorServices.MangoWC.dispatch("setlayout " + name)`
(→ `mmsg dispatch setlayout,<name>`, the confirmed dispatch shape) + set local highlight.
No new service method needed — one-line dispatch. Arrow-key move + Enter as a cheap add.

**Styling/motion:** `Commons.Appearance.colors.{glassBg,accent,accentBorder,surface1,
subtext0}`; borders animate on `anim.fast` (100ms), OutCubic. Active card = 3px accent
border + faint `accentAlpha` fill; hover = 2px border + `desc` reveal.

**Verify (Phase 3):** `HOME=/home/corvus scripts/shot.sh --qml
Modules/Shell/Panels/Content/LayoutPicker.qml /tmp/layout-picker.png` — iterate on the PNG.
