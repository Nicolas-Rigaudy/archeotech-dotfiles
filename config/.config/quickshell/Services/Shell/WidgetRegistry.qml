pragma Singleton
import QtQuick
import "../../Commons" as Commons

// Sprint 18 — convention-based widget resolution (Noctalia pattern).
//
//   Built-in widget id "clock"        → Widgets/Bar/ClockWidget.qml
//   Built-in strip id  "cc"           → Widgets/Strip/CcIcon.qml
//   Plugin widget id   "plugin:foo"   → S20 work, returns "" for now
//
// Adding a built-in widget = drop one QML file under the right directory.
// No registry table edit, no enum to maintain. URLs are absolute (file://)
// so Loader.source resolves the same regardless of which file is calling.
QtObject {
    id: root

    readonly property string _root:     "file://" + Commons.Paths.quickshell
    readonly property string _barDir:   _root + "/Widgets/Bar/"
    readonly property string _stripDir: _root + "/Widgets/Strip/"

    // "active-window" → "ActiveWindow". PascalCase from kebab/snake input.
    function _pascalCase(id) {
        var parts = id.split(/[-_]/)
        var name = ""
        for (var i = 0; i < parts.length; i++) {
            if (!parts[i]) continue
            name += parts[i].charAt(0).toUpperCase() + parts[i].slice(1)
        }
        return name
    }

    function _isPlugin(id) { return typeof id === "string" && id.indexOf("plugin:") === 0 }

    // Bar widget filename: <PascalId>Widget.qml ("clock" → "ClockWidget.qml")
    function barWidgetSource(id) {
        if (!id) return ""
        if (_isPlugin(id)) {
            // Sprint 20 — plugin manifest scanning lands here. Branch
            // reserved now so callers don't change in S20.
            return ""
        }
        return _barDir + _pascalCase(id) + "Widget.qml"
    }

    // Strip icon filename: <PascalId>Icon.qml ("cc" → "CcIcon.qml")
    function stripWidgetSource(id) {
        if (!id) return ""
        if (_isPlugin(id)) return ""
        return _stripDir + _pascalCase(id) + "Icon.qml"
    }
}
