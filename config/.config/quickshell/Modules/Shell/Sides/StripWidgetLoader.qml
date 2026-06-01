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
