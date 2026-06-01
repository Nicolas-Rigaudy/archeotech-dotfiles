import QtQuick
import QtQuick.Layouts
import "../../../Services/Shell" as ShellServices

// Async loader for a single bar widget. Caelestia's WrappedLoader pattern:
//   - resolves QML filename via WidgetRegistry (filename convention)
//   - asynchronous mount so heavy widgets don't hitch the bar's first paint
//   - injects barRoot + widgetId via Loader.setSource properties map
//     (Noctalia pattern — required properties on the widget can't be set
//      via binding, must come in through setSource)
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
// See docs/WIDGET_API.md for the widget contract.
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

    function _resolve() {
        var file = ShellServices.WidgetRegistry.barWidgetFile(widgetId)
        if (!file) {
            source = ""
            return
        }
        // Path is relative to this file: Modules/Shell/Sides/ → repo root → Widgets/Bar/
        loader.setSource("../../../Widgets/Bar/" + file, {
            barRoot:  loader.barRoot,
            widgetId: loader.widgetId
        })
    }

    onWidgetIdChanged: _resolve()
    Component.onCompleted:  _resolve()

    onStatusChanged: {
        if (status === Loader.Error)
            console.warn("[BarWidgetLoader] failed to load", widgetId)
    }
}
