import QtQuick
import QtQuick.Layouts
import "../../../Commons" as Commons
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
// Sprint 26 — per-instance config. `config` is the instance's saved config
// (schema defaults filled in by _resolvedConfig). Optional props are set in
// onLoaded only if the widget declares them (the `'x' in item` guard) — so
// setSource stays strict-safe and config-less widgets are untouched. External
// plugin widgets that declare `property var appearance` get the theme tokens
// injected (they can't `import Commons` from outside the config tree).
//
// See docs/WIDGET_API.md for the widget contract.
Loader {
    id: loader

    required property string widgetId
    required property var    barRoot
    property var  config: ({})
    property bool isFirst: false
    property bool isLast:  false

    // Instance config with schema defaults merged underneath (built-in schema
    // from WidgetRegistry; plugin schema from its module.json).
    function _resolvedConfig() {
        if (ShellServices.WidgetRegistry.isPlugin(widgetId)) {
            var m = ShellServices.ModuleRegistry.moduleFor(widgetId)
            var defs = ShellServices.WidgetRegistry.schemaDefaults(m ? m.configSchema : null)
            if (config) for (var k in config) defs[k] = config[k]
            return defs
        }
        return ShellServices.WidgetRegistry.resolveConfig(widgetId, config)
    }

    // Push optional props onto an already-loaded widget without failing on
    // widgets that don't declare them. Also the config hot-update path: editing
    // an instance's config re-runs this, keeping the live widget instance.
    function _applyOptional() {
        if (!item) return
        if ('config' in item) item.config = _resolvedConfig()
        if (ShellServices.WidgetRegistry.isPlugin(widgetId) && ('appearance' in item))
            item.appearance = Commons.Appearance
    }
    onLoaded: _applyOptional()
    onConfigChanged: _applyOptional()

    // Caelestia first/last padding — matches the pill's inner horizontal
    // padding so the leftmost/rightmost widget doesn't sit flush with the
    // pill's edge. Inner gap between widgets stays at 0 (RowLayout spacing).
    Layout.leftMargin:  isFirst ? 2 : 0
    Layout.rightMargin: isLast  ? 2 : 0
    // Center on the cross axis: vertical bars stack in a ColumnLayout, so the
    // widget must center horizontally instead (S26-C).
    Layout.alignment:   (barRoot && barRoot.horizontal) ? Qt.AlignVCenter : Qt.AlignHCenter

    asynchronous: true
    visible: status === Loader.Ready

    function _resolve() {
        // Plugin module (Sprint 21 Chunk 2): entry QML lives outside the
        // convention dir — load it by absolute file:// URL from ModuleRegistry.
        if (ShellServices.WidgetRegistry.isPlugin(widgetId)) {
            var url = ShellServices.ModuleRegistry.entryUrl(widgetId)
            if (!url) { source = ""; return }
            loader.setSource(url, { barRoot: loader.barRoot, widgetId: loader.widgetId })
            return
        }
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
