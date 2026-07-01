import QtQuick
import "../../../Commons" as Commons
import "../../../Services/Shell" as ShellServices

// Async loader for a single strip icon. Mirrors BarWidgetLoader but routes
// through WidgetRegistry.stripWidgetFile and injects the strip's stripRoot
// API into the icon.
//
// stripRoot contract (Sprint 18) — every strip icon can read these from
// its injected `stripRoot` property:
//
//   readonly property string side                 // "left" | "right" | "bottom" | "top"
//   readonly property bool   horizontal           // side ∈ { top, bottom }
//   readonly property var    screen               // QtScreen
//   readonly property string screenName
//   function isOpen(panelId)                      // delegates to ShellState
//   function toggle(panelId)                      // delegates to ShellState
//
// Strip icons typically toggle a panel id matching their own widget id,
// but the contract is flexible — a future media-strip icon could fire
// a different action.
Loader {
    id: loader

    required property string widgetId
    required property var    stripRoot
    property var config: ({})   // Sprint 26 — per-instance config

    asynchronous: true
    visible: status === Loader.Ready

    // See BarWidgetLoader for the rationale (schema-default merge + strict-safe
    // optional-prop injection + config hot-update + plugin appearance token).
    function _resolvedConfig() {
        if (ShellServices.WidgetRegistry.isPlugin(widgetId)) {
            var m = ShellServices.ModuleRegistry.moduleFor(widgetId)
            var defs = ShellServices.WidgetRegistry.schemaDefaults(m ? m.configSchema : null)
            if (config) for (var k in config) defs[k] = config[k]
            return defs
        }
        return ShellServices.WidgetRegistry.resolveConfig(widgetId, config)
    }
    function _applyOptional() {
        if (!item) return
        if ('config' in item) item.config = _resolvedConfig()
        if (ShellServices.WidgetRegistry.isPlugin(widgetId) && ('appearance' in item))
            item.appearance = Commons.Appearance
    }
    onLoaded: _applyOptional()
    onConfigChanged: _applyOptional()

    function _resolve() {
        // Plugin module (Sprint 21 Chunk 2):
        //   panel-content → render a generic opener icon (StripIconBase with
        //     the module's glyph) that toggles a panel id == widgetId;
        //     PanelRegistry resolves the panel content from ModuleRegistry.
        //   strip-icon    → load the module's entry QML directly as the icon.
        if (ShellServices.WidgetRegistry.isPlugin(widgetId)) {
            var m = ShellServices.ModuleRegistry.moduleFor(widgetId)
            if (!m) { source = ""; return }
            var cl = m.canLiveIn || []
            if (cl.indexOf("panel-content") !== -1) {
                loader.setSource("../../../Widgets/Strip/StripIconBase.qml", {
                    stripRoot: loader.stripRoot,
                    widgetId:  loader.widgetId,
                    glyph:     m.icon || "󰏗"
                })
            } else {
                var url = ShellServices.ModuleRegistry.entryUrl(widgetId)
                if (!url) { source = ""; return }
                loader.setSource(url, { stripRoot: loader.stripRoot, widgetId: loader.widgetId })
            }
            return
        }
        var file = ShellServices.WidgetRegistry.stripWidgetFile(widgetId)
        if (!file) {
            source = ""
            return
        }
        loader.setSource("../../../Widgets/Strip/" + file, {
            stripRoot: loader.stripRoot,
            widgetId:  loader.widgetId
        })
    }

    onWidgetIdChanged: _resolve()
    Component.onCompleted: _resolve()

    onStatusChanged: {
        if (status === Loader.Error)
            console.warn("[StripWidgetLoader] failed to load", widgetId)
    }
}
