# Module API

Archeotech's community-extension system. A **module** is a self-describing folder
you drop into a modules directory; the shell discovers it, lists it in edit mode,
and mounts it where you assign it — no QML edits, no shell restart.

> Built-in bar widgets, strip icons and panels are **not** modules — they live in
> `WidgetRegistry` / `PanelRegistry`. Modules are strictly the third-party layer.
> For the built-in widget contract see [WIDGET_API.md](WIDGET_API.md).

## Where modules live

Both roots are scanned (by `Services/Shell/ModuleRegistry.qml`, via a `jq` sweep):

| Path | Use |
|------|-----|
| `~/.config/quickshell/modules/<id>/` | bundled / repo-tracked modules (stowed) |
| `~/.local/share/archeotech/modules/<id>/` | user-installed modules |

Each module is a folder containing a `module.json` manifest and at least one
QML entry file. Discovery re-runs whenever edit mode opens, so a freshly-dropped
folder appears in the palette immediately.

## `module.json`

```json
{
  "id": "weather",
  "name": "Weather",
  "author": "you",
  "version": "1.0.0",
  "canLiveIn": ["panel-content"],
  "entry": "Weather.qml",
  "icon": "󰖐",
  "defaultSize": { "width": 340, "height": 0 },
  "panel": { "size": 360, "axisSize": "auto" },
  "configSchema": {}
}
```

| Field | Required | Meaning |
|-------|----------|---------|
| `id` | yes | Unique slug. Referenced in `shell-config.json` as `plugin:<id>`. |
| `name` | yes | Display name (palette tile, etc.). |
| `entry` | yes | QML file (relative to the module folder) that is the module's content. |
| `canLiveIn` | yes | Placement targets — see below. |
| `icon` | rec. | Nerd-font glyph; used for the palette tile and the auto-generated panel opener. |
| `author`, `version` | rec. | Metadata. |
| `defaultSize` | opt. | `{ width, height }` hint. `width` is the panel fallback `size` if `panel` is absent. |
| `panel` | opt. | `{ size, axisSize }` for `panel-content` modules — see Panel sizing. |
| `configSchema` | opt. | Reserved for per-module settings UI (future). |

### `canLiveIn` targets

| Target | Behaviour | Status |
|--------|-----------|--------|
| `bar-zone` | `entry` mounts inline as a bar widget in a Left/Center/Right zone. | ✅ Chunk 2 |
| `strip-icon` | `entry` mounts directly as a strip icon (small, self-contained). | ✅ Chunk 2 |
| `panel-content` | the strip auto-generates an opener icon (the `icon` glyph); clicking it toggles a panel whose content is `entry`. | ✅ Chunk 2 |
| `desktop-widget` | placed free-floating on the desktop layer. | ⏳ Sprint 21 Chunk 3 |

A module may list several. When placed on a strip, `panel-content` wins over
`strip-icon` (the richer behaviour); on a bar zone, `bar-zone` is used.

## The entry QML contract

**`bar-zone` / `strip-icon`** — same contract as a built-in widget. Declare the
injected properties; use the context API:

```qml
Item {
    required property var    barRoot     // (strip icons get `stripRoot` instead)
    required property string widgetId
    implicitWidth: /* your content width */
    implicitHeight: 22
    // barRoot.showPopup(item, label, primary, secondary, hint) / hidePopup(item)
}
```

**`panel-content`** — declare `property var panelRoot` (call `panelRoot.close()`
to dismiss). The panel mounts inside the strip card; its size comes from the
manifest `panel` block:

```qml
Item {
    property var panelRoot
    // optional: property real implicitAxis   // drives axisSize:"auto"
}
```

### Panel sizing

`panel.size` = perpendicular depth (away from the strip edge). `panel.axisSize` =
extent along the strip: a number (px), `"auto"` (the entry exposes a numeric
`implicitAxis` the strip reads), or `"full"` (whole screen edge). If `panel` is
omitted, `size` falls back to `defaultSize.width` (or 360) and `axisSize` to
`"auto"`. See [PANEL_API.md](PANEL_API.md) for the underlying model.

## Theming

Modules bundled under `~/.config/quickshell/modules/` may import the shell's
tokens by relative path — `import "../../Commons" as Commons` — and use
`Commons.Appearance.colors / font / radius / spacing / anim`. Fully external
modules under `~/.local/share` can't resolve that relative path, so they should
be self-styled (or wait for `configSchema`-driven theming). The two bundled
examples (`hello`, `notes`) import Commons.

## Worked example

`~/.config/quickshell/modules/notes/` →

- `module.json` with `"canLiveIn": ["panel-content"]`, `"entry": "Notes.qml"`,
  `"icon": "󰎞"`, `"panel": { "size": 360, "axisSize": 420 }`.
- `Notes.qml` — an `Item` with `property var panelRoot` rendering the content.

Then: `Super+Shift+E` → click a strip's `+` → pick **Quick Notes** → an opener
icon appears on that strip; click it → the Notes panel slides out. The
assignment persists in `shell-config.json` as `plugin:notes` in that strip's
`icons` list.
