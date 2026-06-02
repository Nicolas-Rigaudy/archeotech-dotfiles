# Widget API

The shell composes its bar and edge strips from independent widget files. Add a built-in widget by dropping one QML file under the right directory. No central registry to edit, no enum to update.

This document is the contract every widget must follow.

---

## Quick start — add a bar widget

1. Create `config/.config/quickshell/Widgets/Bar/<PascalName>Widget.qml`.
2. Declare `required property var barRoot` (and optionally `property string widgetId`).
3. Render whatever you want; the file is mounted by `BarWidgetLoader` and gets injected with the barRoot API.
4. Add the id (kebab-case of `<PascalName>`) to a zone in `shell-config.json`.

```qml
// Widgets/Bar/UptimeWidget.qml
import QtQuick
import QtQuick.Layouts
import "../../Commons" as Commons

Text {
    required property var barRoot
    property string widgetId

    visible: barRoot && barRoot.horizontal
    Layout.alignment: Qt.AlignVCenter
    text: "up: …"
    color: Commons.Appearance.colors.subtext1
    font.family: Commons.Appearance.font.family
    font.pixelSize: Commons.Appearance.font.sizeSm
}
```

```json
// shell-config.json
"top": {
  "type": "bar",
  "zones": {
    "right": ["uptime", "battery", "power"]
  }
}
```

Save, watch the bar update — Quickshell hot-reloads.

---

## Filename convention

`Services/Shell/WidgetRegistry.qml` resolves widget ids to QML filenames:

| Widget kind | Id (kebab-case) | File path                                  |
|-------------|-----------------|--------------------------------------------|
| Bar widget  | `clock`         | `Widgets/Bar/ClockWidget.qml`              |
| Bar widget  | `active-window` | `Widgets/Bar/ActiveWindowWidget.qml`       |
| Strip icon  | `cc`            | `Widgets/Strip/CcIcon.qml`                 |
| Strip icon  | `dashboard`     | `Widgets/Strip/DashboardIcon.qml`          |
| Plugin      | `plugin:foo`    | reserved for Sprint 20 (manifest scanning) |

PascalCase the id (`-` and `_` are separators). Suffix is `Widget` for bar, `Icon` for strip.

---

## barRoot — bar widget context

Every bar widget receives a `barRoot` reference. Treat it as the only legitimate hook into the bar; reaching past it into Bar.qml internals will break with future refactors.

### Properties

| Name                    | Type    | What it tells you |
|-------------------------|---------|-------------------|
| `barRoot.side`          | string  | `"top"`, `"bottom"`, `"left"`, `"right"` |
| `barRoot.horizontal`    | bool    | `side === "top"` or `"bottom"` |
| `barRoot.screen`        | var     | The QtScreen the bar is on (use `.name` for IPC) |
| `barRoot.width`         | real    | Pill width — useful for popup positioning |

### Hover-popup API

The shared hover-info card (`Widgets/Bar/HoverCard.qml`) is owned by Bar.qml. Widgets trigger it via:

```qml
MouseArea {
    onEntered: barRoot.showPopup(this, "LABEL", "Primary", "Secondary", "Hint")
    onExited:  barRoot.hidePopup(this)
}
```

| Function                                            | Effect |
|-----------------------------------------------------|--------|
| `showPopup(item, label, primary, secondary, hint)`  | Anchors and shows the hover card above `item`. Pass `""` for unused slots. |
| `hidePopup(caller)`                                 | Starts the 250ms hide timer. Passing the same item that called `showPopup` prevents stale exit events from racing. |
| `hideCalendar(caller)`                              | Same shape, for the calendar popup. |
| `keepPopupsAlive()`                                 | Cancels pending hide timers — used by popup cards so the cursor can drift onto them. |

### Mutually-exclusive popup state (advanced)

`Widgets/Bar/NetworkWidget.qml` and `BluetoothWidget.qml` toggle their own popup cards (`WifiPopup.qml`, `BtPopup.qml`). The state lives on barRoot as plain properties so multiple components can synchronise:

| Property                   | Owner       |
|----------------------------|-------------|
| `_wifiPopupVisible` (bool) | NetworkWidget toggles, WifiPopup reads |
| `_wifiAnchorX`     (real)  | NetworkWidget sets, WifiPopup uses for positioning |
| `_btPopupVisible`  (bool)  | BluetoothWidget / BtPopup |
| `_btAnchorX`       (real)  | same |
| `_calendarVisible` (bool)  | ClockWidget / CalendarPopup |

Widgets that want to claim the popup channel should `false` the others (see `NetworkWidget.qml` onClicked for the pattern).

---

## stripRoot — strip icon context

Strip icons live in `Widgets/Strip/*Icon.qml` and receive `stripRoot`.

| Member                          | Use |
|---------------------------------|-----|
| `stripRoot.side`                | `"left" | "right" | "top" | "bottom"` |
| `stripRoot.horizontal`          | `side ∈ {top, bottom}` |
| `stripRoot.screen`              | QtScreen — `.name` for `ShellState` calls |
| `stripRoot._iconHoverEnter()`   | Call from icon's `MouseArea.onEntered` so the popup card stays open when the cursor crosses from the strip body onto the icon. |
| `stripRoot._iconHoverExit()`    | Mirror on `onExited`. |

State changes (open / close panels) go through `ShellServices.ShellState.toggle(screenName, panelId)`. Default `StripIconBase` already does this.

To add a new strip icon, subclass `StripIconBase`:

```qml
// Widgets/Strip/MediaIcon.qml
StripIconBase {
    glyph: "󰝚"
    panelId: "media"   // optional — defaults to widgetId
}
```

---

## Loader injection details

Bar widgets are loaded asynchronously by `Modules/Shell/Sides/BarWidgetLoader.qml`:

```qml
loader.setSource("../../../Widgets/Bar/<File>.qml", {
    barRoot:  bar,
    widgetId: id
})
```

This means `barRoot` is set at construction time — bindings on `barRoot.*` work from the first frame. Required properties on the widget are satisfied via the properties map; using a plain `barRoot: bar` declarative binding on a `Loader.source` does NOT work for required props.

Strip icons go through the same flow via `StripWidgetLoader.qml`.

---

## Visibility & orientation

`barRoot.horizontal` is `true` only for top/bottom bars. Vertical side bars currently render a fixed icon column (legacy Strip-vs-Bar split — see ROADMAP.md), so most widgets should gate themselves with:

```qml
visible: barRoot && barRoot.horizontal
```

Per-widget vertical layouts are out of scope for Sprint 18; a follow-up sprint will introduce orientation-aware widgets.

---

## Stable ListModel (preserve delegates)

`Bar.qml` syncs each zone's id list into a `ListModel` via `_syncZone()` (HyprPanel-style diff). When `shell-config.json` changes, only added/removed/moved widgets churn — unchanged widgets keep their state (MPRIS marquee position, transient hover state, etc.).

Widgets do not need to know about this. The takeaway: edits to `shell-config.json` hot-reload cleanly; you don't have to design defensively around delegate destruction.

---

## Plugin reservation

`WidgetRegistry.barWidgetFile("plugin:foo")` returns `""` and the loader leaves the slot empty. Sprint 20 will land:

- `~/.local/share/archeotech/plugins/<id>/` scanning via FolderListModel
- Manifest (`plugin.json`) with `entryPoints.barWidget`, `entryPoints.stripIcon`, etc.
- `?t=<timestamp>` cache-bust on hot-reload

See `.claude/ANALYSIS.md` §12 and the `reference_widget_registry_patterns` memory for the chosen pattern (Noctalia-style filesystem convention + `plugin:<id>` namespacing).
