import QtQuick
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

    asynchronous: true
    visible: status === Loader.Ready

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
