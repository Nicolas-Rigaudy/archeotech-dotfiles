import QtQuick
import "../../Commons" as Commons
import "../../Services/Shell" as ShellServices

// Panel opener for a bar (Sprint 26-C) — the bar analogue of StripIconBase.
// A strip icon hover-reveals its card; a bar opener is always visible and drops
// its panel from the bar edge. The panel is the widget's own id (so "dashboard"
// on a bar IS the dashboard opener — placed directly, no config step); each
// opener panel id resolves to this one component via WidgetRegistry. Icon-only
// vertical via BarPill.
BarPill {
    id: root
    property var config: ({})

    // Panel = the widget id ("dashboard", "launcher", …); config.panelId is a
    // legacy fallback for any old generic entries.
    readonly property string _panelId: (config && config.panelId) ? config.panelId
                                       : (widgetId ? widgetId : "dashboard")
    readonly property var    _meta:    ShellServices.WidgetRegistry.stripIconMeta(_panelId)
    readonly property bool   _open:    ShellServices.ShellState.isOpenAnywhere(_panelId)

    icon: (_meta && _meta.icon) ? _meta.icon : "󰏗"
    iconColor: _open ? Commons.Appearance.colors.accent : Commons.Appearance.colors.subtext1

    // No hover popup — just open the panel on click, like a strip icon does.
    onClicked: {
        if (barRoot) {
            barRoot._wifiPopupVisible = false; barRoot._btPopupVisible = false
            // Record where the panel should drop from (this opener's center).
            var c = mapToItem(barRoot, width / 2, height / 2)
            barRoot._panelAnchor = barRoot.horizontal ? c.x : c.y
        }
        // Pass this bar's side so the panel drops from THIS bar (not a strip).
        ShellServices.ShellState.toggleGlobal(_panelId, barRoot ? barRoot.side : "")
    }
}
