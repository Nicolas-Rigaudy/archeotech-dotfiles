pragma Singleton
import QtQuick

// Sprint 18 — convention-based widget id → filename resolution.
//
//   Built-in bar widget id   "clock"        → "ClockWidget.qml"
//   Built-in strip icon  id  "cc"           → "CcIcon.qml"
//   Plugin widget id         "plugin:foo"   → "" (S20 work)
//
// The loader (BarWidgetLoader / StripWidgetLoader) owns the directory
// path prefix because Loader.source resolves relative to the calling
// file — keeping it relative avoids Qt URL handling pitfalls (it would
// double-prefix file:// URLs treated as relative strings).
QtObject {
    id: root

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
    function barWidgetFile(id) {
        if (!id) return ""
        if (_isPlugin(id)) {
            // Sprint 20 — plugin manifest scanning lands here. Branch
            // reserved now so callers don't change in S20.
            return ""
        }
        return _pascalCase(id) + "Widget.qml"
    }

    // Strip icon filename: <PascalId>Icon.qml ("cc" → "CcIcon.qml")
    function stripWidgetFile(id) {
        if (!id) return ""
        if (_isPlugin(id)) return ""
        return _pascalCase(id) + "Icon.qml"
    }
}
