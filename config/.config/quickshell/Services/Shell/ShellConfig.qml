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

    function zoneWidgets(sideName, zone, screenName) {
        var s = side(sideName, screenName)
        if (!s.zones || !s.zones[zone]) return []
        return s.zones[zone]
    }

    function stripIcons(sideName, screenName) {
        var s = side(sideName, screenName)
        return s.icons || []
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

    // Switch a side's type (bar | strip | holder | none). Seeds an empty
    // container for the new type when absent, but preserves any existing
    // zones/icons so toggling types back and forth is non-destructive.
    function setSideType(sideName, type) {
        _mutate(function(d) {
            var s = d.sides[sideName] || {}
            s.type = type
            // Reset thickness to the new type's default so a strip↔bar switch
            // actually changes geometry (a bar must be bar-height thick, a strip
            // thin). Zones/icons are preserved so toggling back is non-destructive.
            if (type === "bar") {
                if (!s.zones) s.zones = { left: [], center: [], right: [] }
                s.size = 30
            } else if (type === "strip" || type === "holder") {
                if (!s.icons) s.icons = []
                s.size = 10
                if (s.expanded === undefined) s.expanded = 240
            }
            d.sides[sideName] = s
        })
    }

    // Assign / reorder / clear a bar zone (left | center | right).
    function setZoneWidgets(sideName, zone, ids) {
        _mutate(function(d) {
            var s = d.sides[sideName] || { type: "bar" }
            if (!s.zones) s.zones = { left: [], center: [], right: [] }
            s.zones[zone] = ids.slice()
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
    function setStripIcons(sideName, ids) {
        _mutate(function(d) {
            var s = d.sides[sideName] || { type: "strip" }
            s.icons = ids.slice()
            d.sides[sideName] = s
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
