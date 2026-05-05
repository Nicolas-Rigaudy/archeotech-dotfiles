# Quickshell Reference Patterns

Patterns collected from [caelestia-dots/shell](https://github.com/caelestia-dots/shell) and [noctalia-dev/noctalia-shell](https://github.com/noctalia-dev/noctalia-shell).

---

## 1. MPRIS Reactive Detection

### caelestia

```qml
readonly property list<MprisPlayer> list: Mpris.players.values
readonly property MprisPlayer active: props.manualActive ?? list.find(p => ...) ?? list[0] ?? null
```

- `Mpris.players.values` typed as `list<MprisPlayer>` — reactive because it is a list property binding
- No explicit change handler needed — QML re-evaluates the binding when list contents change

### noctalia

```qml
Connections {
    target: Mpris.players
    function onValuesChanged() { updateCurrentPlayer() }
}
```

- `Mpris.players` is an ObjectModel that emits `valuesChanged` when players are added or removed
- `getAvailablePlayers()` iterates `Mpris.players.values` as an array
- A `playerStateMonitor` Timer polls every 2 s as a fallback

---

## 2. Panel Slide Animations

### caelestia — single `offsetScale` property

```qml
// Sidebar (right slide-in):
property real offsetScale: 1
anchors.rightMargin: (-implicitWidth - 5) * offsetScale
opacity: 1 - offsetScale
Behavior on offsetScale { Anim { type: Anim.DefaultSpatial } }
```

- One property drives both position and opacity simultaneously
- `Anim` is a custom component wrapping `NumberAnimation` with Material Design 3 tokens
- Value 0 = fully visible, 1 = fully hidden

### noctalia — opacity fade only

```qml
opacity: 0
Component.onCompleted: { opacity = 1 }
Behavior on opacity { NumberAnimation { duration: Style.animationNormal; easing.type: Easing.OutCubic } }
```

- The layer shell window is always present; entrance is a pure opacity fade
- No x/y translation needed because the window is always in the compositor layer

---

## 3. Animation Token System

### caelestia — `Tokens` singleton

- Duration keys: `Tokens.anim.durations.{small|normal|large|extraLarge}`
- Easing keys: `standard`, `emphasized`, `expressiveFastSpatial`, `expressiveDefaultSpatial`, `expressiveSlowSpatial`
- Consumed through a custom `Anim {}` component with a `type` enum that selects the appropriate `NumberAnimation` parameters

### noctalia — `Style` singleton

- Duration keys: `Style.animationFastest` / `Faster` / `Fast` / `Normal` / `Slow` / `Slower` / `Slowest`
- Can be disabled globally via a performance mode flag
- `Easing.OutCubic` used consistently across all animated properties

---

## 4. Key Architectural Differences vs Our Shell

| Topic | caelestia / noctalia | Notes |
|---|---|---|
| Window visibility | Overlay window **always visible**; show/hide via opacity or transform | Avoids window geometry timing issues that arise from toggling `visible` |
| Slide axis | caelestia uses `anchors.rightMargin` instead of `x` | Anchors recalculate automatically on window resize |
| Width reference | Neither uses `parent.width` directly | Use anchors or implicit sizing instead |
