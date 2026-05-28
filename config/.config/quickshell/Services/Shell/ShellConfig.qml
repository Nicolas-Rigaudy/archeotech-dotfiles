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
                size: 36,
                zones: {
                    left:   ["workspaces", "title", "media"],
                    center: ["clock"],
                    right:  ["mic", "volume", "network", "bluetooth", "battery", "notifications", "settings", "power"]
                }
            },
            right:  { type: "strip", size: 10, expanded: 56, icons: ["cc", "nc"] },
            bottom: { type: "strip", size: 10, expanded: 56, icons: ["dashboard"] },
            left:   { type: "strip", size: 10, expanded: 56, icons: ["launcher"] }
        },
        corners: { radius: 14 },
        perScreen: {}
    })

    property var data: _defaults
    property bool ready: false

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
    // margins, Panel cross-axis offsets, CornerBlend gap geometry — anywhere
    // we need "how much room does this side reserve when at rest".
    function sideGap(sideName, screenName) {
        if (sideType(sideName, screenName) === "none") return 0
        return sideSize(sideName, screenName)
    }

    function cornerRadius() {
        return (data.corners && data.corners.radius !== undefined) ? data.corners.radius : _defaults.corners.radius
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
                root.data = {
                    sides:     parsed.sides     || root._defaults.sides,
                    corners:   parsed.corners   || root._defaults.corners,
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
