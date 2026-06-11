pragma Singleton
import QtQuick

// Sprint 18 — convention-based widget id → filename resolution.
//
//   Built-in bar widget id   "clock"        → "ClockWidget.qml"
//   Built-in strip icon  id  "nc"           → "NcIcon.qml"
//   Plugin widget id         "plugin:foo"   → "" (S20 work)
//
// The loader (BarWidgetLoader / StripWidgetLoader) owns the directory
// path prefix because Loader.source resolves relative to the calling
// file — keeping it relative avoids Qt URL handling pitfalls (it would
// double-prefix file:// URLs treated as relative strings).
QtObject {
    id: root

    // ── Palette catalogue (Sprint 21) ──────────────────────────────────────────
    // The edit-mode palette lists these as assignable. For now this is the
    // hand-maintained built-in set; Sprint 22 (Module Builder) replaces these
    // arrays with manifest discovery (module.json under Modules/ + user dir),
    // keeping the same { id, name, icon } shape so the palette UI is unchanged.
    readonly property var availableBarWidgets: [
        { id: "workspaces",    name: "Workspaces",    icon: "󰧨" },
        { id: "title",         name: "Window Title",  icon: "󰖯" },
        { id: "media",         name: "Media",         icon: "󰝚" },
        { id: "clock",         name: "Clock",         icon: "󰥔" },
        { id: "mic",           name: "Microphone",    icon: "󰍬" },
        { id: "volume",        name: "Volume",        icon: "󰕾" },
        { id: "brightness",    name: "Brightness",    icon: "󰃟" },
        { id: "network",       name: "Network",       icon: "󰤨" },
        { id: "bluetooth",     name: "Bluetooth",     icon: "󰂯" },
        { id: "battery",       name: "Battery",       icon: "󰁹" },
        { id: "notifications", name: "Notifications", icon: "󰂚" },
        { id: "settings",      name: "Settings",      icon: "󰒓" },
        { id: "power",         name: "Power",         icon: "󰐥" }
    ]

    readonly property var availableStripIcons: [
        { id: "nc",        name: "Notification Center", icon: "󰂚" },
        { id: "dashboard", name: "Dashboard",           icon: "󰨇" },
        { id: "media",     name: "Media",               icon: "󰝚" },
        { id: "launcher",  name: "Launcher",            icon: "󱓞" },
        { id: "wallpaper", name: "Appearance",           icon: "󰏘" },
        { id: "settings",  name: "Settings",            icon: "󰒓" }
    ]

    function _metaFor(list, id) {
        for (var i = 0; i < list.length; i++) if (list[i].id === id) return list[i]
        return { id: id, name: id, icon: "" }
    }
    function barWidgetMeta(id) { return _metaFor(availableBarWidgets, id) }
    function stripIconMeta(id) { return _metaFor(availableStripIcons, id) }

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
    // Public alias — loaders branch on this to route plugin ids to ModuleRegistry.
    function isPlugin(id) { return _isPlugin(id) }

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

    // Strip icon filename: <PascalId>Icon.qml ("nc" → "NcIcon.qml")
    function stripWidgetFile(id) {
        if (!id) return ""
        if (_isPlugin(id)) return ""
        return _pascalCase(id) + "Icon.qml"
    }
}
