pragma Singleton
import QtQuick
import QtCore
import Quickshell.Io

QtObject {
    id: root

    readonly property var _defaults: ({
        sides: {
            top: {
                type: "bar",
                size: 30,
                zones: {
                    left:   ["workspaces", "title", "media"],
                    center: ["clock"],
                    right:  ["mic", "volume", "brightness", "network", "bluetooth", "battery", "notifications", "settings", "power"]
                }
            },
            right:  { type: "strip", size: 10, expanded: 44, icons: ["settings", "nc"] },
            bottom: { type: "strip", size: 10, expanded: 44, icons: ["dashboard", "media", "wallpaper"] },
            left:   { type: "strip", size: 10, expanded: 44, icons: ["launcher"] }
        },
        corners: { radius: 12, pillMode: false, pillGap: 6 },
        outerGap: 6,
        perScreen: {}
    })

    property var data: _defaults
    property bool ready: false

    // Captured from the loaded file so edit-mode writes preserve the
    // self-documenting "$schema" comment line.
    property string _schemaNote: ""

    function side(name, screenName) {
        var base = (data.sides && data.sides[name]) || _defaults.sides[name] || { type: "none" }
        if (screenName && data.perScreen && data.perScreen[screenName] && data.perScreen[screenName].sides && data.perScreen[screenName].sides[name]) {
            var override = data.perScreen[screenName].sides[name]
            var merged = {}
            for (var k in base) merged[k] = base[k]
            for (var k2 in override) merged[k2] = override[k2]
            return merged
        }
        return base
    }

    function sideType(name, screenName) {
        return side(name, screenName).type
    }

    // Sprint 26 — per-instance config. Zone/strip entries are now { id, config }
    // objects; a bare string id is the legacy form (pre-S26 shell-config.json).
    // Normalize on read so both forms load and old files keep working untouched.
    function _normEntry(e) {
        if (typeof e === "string") return { id: e, config: {} }
        if (e && typeof e === "object") return { id: e.id, config: e.config || {} }
        return { id: "", config: {} }
    }

    // Normalized [{ id, config }] — config-aware consumers (loaders, edit mode).
    function zoneEntries(sideName, zone, screenName) {
        var s = side(sideName, screenName)
        if (!s.zones || !s.zones[zone]) return []
        return s.zones[zone].map(function(e) { return root._normEntry(e) })
    }

    function stripEntries(sideName, screenName) {
        var s = side(sideName, screenName)
        if (!s.icons) return []
        return s.icons.map(function(e) { return root._normEntry(e) })
    }

    // Ids only — legacy id-consumers keep working regardless of file format.
    function zoneWidgets(sideName, zone, screenName) {
        return zoneEntries(sideName, zone, screenName).map(function(e) { return e.id })
    }

    function stripIcons(sideName, screenName) {
        return stripEntries(sideName, screenName).map(function(e) { return e.id })
    }

    function sideSize(sideName, screenName) {
        var s = side(sideName, screenName)
        return s.size !== undefined ? s.size : 10
    }

    function sideExpanded(sideName, screenName) {
        var s = side(sideName, screenName)
        return s.expanded !== undefined ? s.expanded : 56
    }

    // 0 for "none" sides, collapsed size otherwise. Drives ShellSurface side
    // margins, Panel cross-axis offsets, FrameBackground band geometry — anywhere
    // we need "how much room does this side reserve when at rest".
    //
    // A "holder" (Sprint 21) is hidden at rest — it reserves no space and
    // shows no chrome until revealed on hover/shortcut — so it reports 0 too.
    function sideGap(sideName, screenName) {
        var t = sideType(sideName, screenName)
        if (t === "none" || t === "holder") return 0
        return sideSize(sideName, screenName)
    }

    function cornerRadius() {
        return (data.corners && data.corners.radius !== undefined) ? data.corners.radius : _defaults.corners.radius
    }

    // Sprint 22 — global frame style. false = framed (sides hug the screen
    // edges; an end with no active neighbour rounds only its content-facing
    // corner; active neighbours join via concave blend). true = pill (every
    // side floats off the edge by a small gap and fully rounds all four corners;
    // no blends).
    function pillMode() {
        return (data.corners && data.corners.pillMode !== undefined)
            ? data.corners.pillMode : _defaults.corners.pillMode
    }

    // Gap between a floating pill-mode side and its screen edge. Also added to
    // the exclusion zone in pill mode so tiled windows keep matching clearance
    // on the side's inner edge.
    function pillGap() {
        return (data.corners && data.corners.pillGap !== undefined)
            ? data.corners.pillGap : _defaults.corners.pillGap
    }

    function outerGap() {
        return (data.outerGap !== undefined) ? data.outerGap : _defaults.outerGap
    }

    // ── Mutators (Sprint 21 — edit mode writes config back to disk) ─────────────
    // Every edit deep-clones `data`, reassigns it (fires onDataChanged → the
    // live Bar/Strip re-sync from config), then serializes to shell-config.json.
    // The FileView watch re-reads the same data and rebuilds `data`; it never
    // calls _save(), so there is no write loop (same pattern as Persistence/Config).
    function _save() {
        var out = {
            sides:     data.sides,
            corners:   data.corners,
            outerGap:  data.outerGap,
            perScreen: data.perScreen
        }
        if (_schemaNote) out["$schema"] = _schemaNote
        _file.setText(JSON.stringify(out, null, 2))
    }

    function _mutate(fn) {
        var d = JSON.parse(JSON.stringify(data))
        if (!d.sides) d.sides = {}
        fn(d)
        data = d
        _save()
    }

    // Strip↔bar entry compatibility (Sprint 26-C). A strip hosts panel-opener
    // icons; a bar hosts widgets. Panel-openers map both ways: a strip icon
    // becomes a bar entry (a dedicated widget where one exists, else the generic
    // `panel-opener` carrying the panelId), and vice-versa. Bar widgets with no
    // strip form (clock, volume, …) map to null and are dropped on the way to a
    // strip. Used to seed the target container on a type switch so the side
    // isn't empty after flipping.
    readonly property var _stripToBarWidget: ({ settings: "settings", nc: "notifications" })
    readonly property var _barToStripPanel:  ({ settings: "settings", notifications: "nc" })
    function _stripEntryToBar(e) {
        var n = _normEntry(e)
        if (_stripToBarWidget[n.id]) return { id: _stripToBarWidget[n.id], config: {} }
        if (n.id && n.id.indexOf("plugin:") !== 0) return { id: "panel-opener", config: { panelId: n.id } }
        return null
    }
    function _barEntryToStrip(e) {
        var n = _normEntry(e)
        if (n.id === "panel-opener") return n.config && n.config.panelId ? { id: n.config.panelId, config: {} } : null
        if (_barToStripPanel[n.id])  return { id: _barToStripPanel[n.id], config: {} }
        return null
    }
    function _compact(list) { return list.filter(function(x) { return !!x }) }

    // Switch a side's type (bar | strip | holder | none). Seeds an empty
    // container for the new type when absent; if the target container is empty
    // it's seeded by converting the *other* container's compatible entries
    // (panel-openers carry across, incompatible widgets are dropped), so a
    // strip↔bar flip isn't left blank. A non-empty target is left untouched, so
    // toggling back and forth is non-destructive and never duplicates.
    function setSideType(sideName, type) {
        _mutate(function(d) {
            var s = d.sides[sideName] || {}
            s.type = type
            if (type === "bar") {
                if (!s.zones) s.zones = { left: [], center: [], right: [] }
                s.size = 30
                var zonesEmpty = !s.zones.left.length && !s.zones.center.length && !s.zones.right.length
                if (zonesEmpty && s.icons && s.icons.length)
                    s.zones.right = root._compact(s.icons.map(root._stripEntryToBar))
            } else if (type === "strip" || type === "holder") {
                if (!s.icons) s.icons = []
                s.size = 10
                if (s.expanded === undefined) s.expanded = 240
                if (!s.icons.length && s.zones) {
                    var all = (s.zones.left || []).concat(s.zones.center || [], s.zones.right || [])
                    s.icons = root._compact(all.map(root._barEntryToStrip))
                }
            }
            d.sides[sideName] = s
        })
    }

    // Assign / reorder / clear a bar zone (left | center | right). Accepts
    // { id, config } entries or bare id strings (normalized either way), so
    // callers can pass entries to preserve per-instance config through reorder.
    function setZoneWidgets(sideName, zone, entries) {
        _mutate(function(d) {
            var s = d.sides[sideName] || { type: "bar" }
            if (!s.zones) s.zones = { left: [], center: [], right: [] }
            s.zones[zone] = entries.map(function(e) { return root._normEntry(e) })
            d.sides[sideName] = s
        })
    }

    // Toggle the global pill/framed frame style (S22).
    function setPillMode(v) {
        _mutate(function(d) {
            if (!d.corners) d.corners = { radius: _defaults.corners.radius }
            d.corners.pillMode = v
        })
    }

    // Inner-corner radius of the frame (S24 — Shell settings). Routes through
    // shell-config so FrameBackground re-reads it and redraws consistently.
    function setCornerRadius(r) {
        _mutate(function(d) {
            if (!d.corners) d.corners = {}
            d.corners.radius = Math.round(r)
        })
    }

    // Breathing gap between the shell and tiled windows (drives exclusionZone).
    function setOuterGap(g) {
        _mutate(function(d) { d.outerGap = Math.round(g) })
    }

    // Assign / reorder / clear the icon list of a strip or holder side.
    // Same { id, config } | bare-string normalization as setZoneWidgets.
    function setStripIcons(sideName, entries) {
        _mutate(function(d) {
            var s = d.sides[sideName] || { type: "strip" }
            s.icons = entries.map(function(e) { return root._normEntry(e) })
            d.sides[sideName] = s
        })
    }

    // Write per-instance config onto one entry, addressed by position.
    // zone === "" (or null) targets a strip/holder icon list; otherwise a bar zone.
    function setEntryConfig(sideName, zone, index, config) {
        _mutate(function(d) {
            var s = d.sides[sideName]
            if (!s) return
            var list = zone ? (s.zones && s.zones[zone]) : s.icons
            if (!list || index < 0 || index >= list.length) return
            var e = root._normEntry(list[index])
            e.config = config || {}
            list[index] = e
        })
    }

    property FileView _file: FileView {
        path: StandardPaths.writableLocation(StandardPaths.HomeLocation) + "/.config/quickshell/shell-config.json"
        watchChanges: true
        preload: true
        printErrors: false
        onTextChanged: {
            var content = text()
            if (!content || !content.trim()) {
                root.data = root._defaults
                root.ready = true
                console.log("[ShellConfig] empty file, using defaults")
                return
            }
            try {
                var parsed = JSON.parse(content)
                root._schemaNote = parsed["$schema"] || ""
                root.data = {
                    sides:     parsed.sides     || root._defaults.sides,
                    corners:   parsed.corners   || root._defaults.corners,
                    outerGap:  parsed.outerGap  !== undefined ? parsed.outerGap : root._defaults.outerGap,
                    perScreen: parsed.perScreen || {}
                }
                root.ready = true
                console.log("[ShellConfig] loaded shell-config.json — sides:",
                    Object.keys(root.data.sides).map(function(k) { return k + "=" + root.data.sides[k].type }).join(" "))
            } catch (e) {
                console.warn("[ShellConfig] parse error, using defaults:", e)
                root.data = root._defaults
                root.ready = true
            }
        }
    }
}
