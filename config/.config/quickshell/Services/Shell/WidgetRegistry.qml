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
        { id: "power",         name: "Power",         icon: "󰐥" },
        // Panel openers — placed directly (like the strip icons); each drops its
        // own panel from the bar edge. Resolved to PanelOpenerWidget by id.
        { id: "dashboard",     name: "Dashboard",     icon: "󰕮" },
        { id: "launcher",      name: "Launcher",      icon: "󱓞" },
        { id: "wallpaper",     name: "Appearance",    icon: "󰏘" }
    ]

    // Bar-widget ids that are panel openers → all resolve to PanelOpenerWidget
    // (the panel is the id itself). Keeps them out of the *Widget.qml filename
    // convention. "nc"/"settings" already have dedicated bar widgets; "media" is
    // the marquee, which opens the media panel itself.
    readonly property var _panelOpenerIds: ["dashboard", "launcher", "wallpaper"]

    readonly property var availableStripIcons: [
        { id: "nc",        name: "Notification Center", icon: "󰂚" },
        { id: "dashboard", name: "Dashboard",           icon: "󰕮" },
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

    // ── Per-instance config (Sprint 26) ─────────────────────────────────────────
    // configSchema for built-in widgets (plugins declare theirs in module.json,
    // read via ModuleRegistry). Field types map to Settings/Widgets rows in
    // ConfigForm.qml: bool→ToggleRow, int/real→SliderRow, enum→ButtonGroupRow /
    // DropdownRow, string→TextFieldRow. Add a widget's schema here to make it
    // per-instance configurable; widgets with no entry are config-less.
    readonly property var _builtinSchemas: ({
        clock: {
            format: {
                type: "enum", label: "Time format", "default": "24h",
                options: [{ value: "24h", label: "24-hour" }, { value: "12h", label: "12-hour" }]
            },
            showSeconds: { type: "bool", label: "Show seconds", "default": false }
        }
    })

    function configSchemaFor(id) {
        if (_isPlugin(id)) return {}   // plugin schema comes from ModuleRegistry
        return _builtinSchemas[id] || {}
    }

    // Default config object derived from a schema's declared defaults.
    // Loaders merge instance overrides on top of this.
    function schemaDefaults(schema) {
        var out = {}
        if (!schema) return out
        for (var k in schema) {
            if (schema[k] && schema[k]["default"] !== undefined) out[k] = schema[k]["default"]
        }
        return out
    }

    // Instance config with schema defaults filled in for any unset field.
    function resolveConfig(id, instanceConfig) {
        var out = schemaDefaults(configSchemaFor(id))
        if (instanceConfig) for (var k in instanceConfig) out[k] = instanceConfig[k]
        return out
    }

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
        // Panel-opener ids share one component (panel = the id itself).
        if (_panelOpenerIds.indexOf(id) !== -1) return "PanelOpenerWidget.qml"
        return _pascalCase(id) + "Widget.qml"
    }

    // Strip icon filename: <PascalId>Icon.qml ("nc" → "NcIcon.qml")
    function stripWidgetFile(id) {
        if (!id) return ""
        if (_isPlugin(id)) return ""
        return _pascalCase(id) + "Icon.qml"
    }
}
