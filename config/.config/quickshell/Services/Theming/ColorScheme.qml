pragma Singleton
import QtQuick
import Quickshell.Io
import "../../Commons" as Commons
import "../Persistence" as Persistence

// Sprint 25 — resolves the user's colour-scheme choices (family + flavor +
// light/dark mode + day-night schedule) into a concrete on-disk variant and
// applies it via theme-switch.py. All state lives in Persistence.Config so the
// UI just calls the setters; this singleton reacts and re-themes.
//
//   mode: "dark" | "light" | "auto"
//     dark/light → use flavorDark / flavorLight of the chosen family.
//     auto       → pick by the manual day-night schedule (lightStart..darkStart).
QtObject {
    id: root

    // ── Persisted state (reactive via Config) ───────────────────────────────────
    // Defaults seed from the currently-applied theme.variant so first boot is a
    // no-op (no surprise switch). Once the UI writes colorScheme.* these win.
    readonly property string _applied: Persistence.Config.get("theme.variant", "archeotech-macchiato")
    readonly property string family:      Persistence.Config.get("colorScheme.family", ThemeCatalog.familyOfVariant(_applied))
    readonly property string mode:        Persistence.Config.get("colorScheme.mode", ThemeCatalog.modeOfVariant(_applied))
    readonly property string flavorDark:  Persistence.Config.get("colorScheme.flavorDark",
        ThemeCatalog.modeOfVariant(_applied) === "dark" ? ThemeCatalog.flavorOfVariant(_applied) : ThemeCatalog.defaultFlavor(family, "dark"))
    readonly property string flavorLight: Persistence.Config.get("colorScheme.flavorLight",
        ThemeCatalog.modeOfVariant(_applied) === "light" ? ThemeCatalog.flavorOfVariant(_applied) : ThemeCatalog.defaultFlavor(family, "light"))
    readonly property string lightStart:  Persistence.Config.get("colorScheme.lightStart", "07:00")
    readonly property string darkStart:   Persistence.Config.get("colorScheme.darkStart",  "19:00")

    // ── Clock for auto mode ──────────────────────────────────────────────────────
    property string _now: Qt.formatDateTime(new Date(), "HH:mm")
    property var _clock: Timer {
        interval: 60000; repeat: true; triggeredOnStart: true
        running: root.mode === "auto"
        onTriggered: root._now = Qt.formatDateTime(new Date(), "HH:mm")
    }

    // True when the current time is within the light window [lightStart, darkStart).
    readonly property bool isDaytime:
        mode === "auto" ? (_now >= lightStart && _now < darkStart) : (mode === "light")

    // Effective dark/light after resolving auto + falling back when a family has
    // no light flavor.
    readonly property string effectiveMode: {
        var want = (mode === "auto") ? (isDaytime ? "light" : "dark") : mode
        if (want === "light" && !ThemeCatalog.hasLight(family)) return "dark"
        return want
    }

    readonly property string activeFlavor: effectiveMode === "light" ? flavorLight : flavorDark
    readonly property string activeVariant: ThemeCatalog.variantFor(family, activeFlavor)

    // ── Apply ────────────────────────────────────────────────────────────────────
    property string _lastApplied: ""
    property var _applyProc: Process { command: []; running: false }

    function _apply() {
        var v = root.activeVariant
        if (!v || v === root._lastApplied) return
        root._lastApplied = v
        Persistence.Config.set("theme.variant", v)
        _applyProc.command = [Commons.Paths.themeSwitch, v]
        _applyProc.running = true
    }

    onActiveVariantChanged: _apply()

    Component.onCompleted: {
        // Seed to the already-applied variant so we don't re-switch on boot
        // unless auto/mode resolves to a different one (e.g. it's night).
        root._lastApplied = Persistence.Config.get("theme.variant", "")
        if (root.activeVariant && root.activeVariant !== root._lastApplied) _apply()
    }

    // ── Setters (the UI calls these) ──────────────────────────────────────────────
    function setFamily(id) {
        Persistence.Config.set("colorScheme.family", id)
        // Keep the chosen flavors valid for the new family.
        var fd = ThemeCatalog.flavorById(id, root.flavorDark)
        if (!fd || fd.mode !== "dark")
            Persistence.Config.set("colorScheme.flavorDark", ThemeCatalog.defaultFlavor(id, "dark"))
        if (ThemeCatalog.hasLight(id)) {
            var fl = ThemeCatalog.flavorById(id, root.flavorLight)
            if (!fl || fl.mode !== "light")
                Persistence.Config.set("colorScheme.flavorLight", ThemeCatalog.defaultFlavor(id, "light"))
        }
    }
    function setMode(m)        { Persistence.Config.set("colorScheme.mode", m) }
    function setFlavorDark(f)  { Persistence.Config.set("colorScheme.flavorDark", f) }
    function setFlavorLight(f) { Persistence.Config.set("colorScheme.flavorLight", f) }
    function setLightStart(t)  { Persistence.Config.set("colorScheme.lightStart", t) }
    function setDarkStart(t)   { Persistence.Config.set("colorScheme.darkStart", t) }
}
