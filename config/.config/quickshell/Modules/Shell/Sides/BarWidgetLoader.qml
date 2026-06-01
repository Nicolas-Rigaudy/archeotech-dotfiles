import QtQuick
import QtQuick.Layouts
import "../../../Services/Shell" as ShellServices

// Async loader for a single bar widget. Caelestia's WrappedLoader pattern:
//   - resolves QML source via WidgetRegistry (filename convention)
//   - asynchronous mount so heavy widgets don't hitch the bar's first paint
//   - injects the bar's barRoot API into the widget (showPopup, side, ...)
//   - adaptive left/right margins on first/last in zone
//
// barRoot contract (Sprint 18) — every bar widget can read these from its
// injected `barRoot` property:
//
//   readonly property string side          // "top" | "bottom" | "left" | "right"
//   readonly property bool   horizontal    // shorthand: side ∈ { top, bottom }
//   readonly property var    screen        // QtScreen
//   function showPopup(item, label, primary, secondary, hint)
//   function hidePopup(caller)
//
// Widgets may declare optional properties consumed by Bar.qml chrome
// (visibility, layout hints, …) — see docs/WIDGET_API.md.
Loader {
    id: loader

    required property string widgetId
    required property var    barRoot
    property bool isFirst: false
    property bool isLast:  false

    // Caelestia first/last padding — matches the pill's inner horizontal
    // padding so the leftmost/rightmost widget doesn't sit flush with the
    // pill's edge. Inner gap between widgets stays at 0 (RowLayout spacing).
    Layout.leftMargin:  isFirst ? 2 : 0
    Layout.rightMargin: isLast  ? 2 : 0
    Layout.alignment:   Qt.AlignVCenter

    asynchronous: true
    visible: status === Loader.Ready
    source: ShellServices.WidgetRegistry.barWidgetSource(widgetId)

    onStatusChanged: {
        if (status === Loader.Error)
            console.warn("[BarWidgetLoader] failed to load", widgetId, "from", source)
    }

    onLoaded: {
        if (!item) return
        if ("barRoot" in item)  item.barRoot  = loader.barRoot
        if ("widgetId" in item) item.widgetId = loader.widgetId
    }
}
