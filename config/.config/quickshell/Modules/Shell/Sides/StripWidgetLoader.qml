import QtQuick
import "../../../Services/Shell" as ShellServices

// Async loader for a single strip icon. Mirrors BarWidgetLoader but routes
// through WidgetRegistry.stripWidgetSource and injects the strip's stripRoot
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
    source: ShellServices.WidgetRegistry.stripWidgetSource(widgetId)

    onStatusChanged: {
        if (status === Loader.Error)
            console.warn("[StripWidgetLoader] failed to load", widgetId, "from", source)
    }

    onLoaded: {
        if (!item) return
        if ("stripRoot" in item) item.stripRoot = loader.stripRoot
        if ("widgetId"  in item) item.widgetId  = loader.widgetId
    }
}
