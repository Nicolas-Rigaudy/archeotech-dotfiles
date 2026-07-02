import QtQuick
import "../../Commons" as Commons
import "../../Services/Shell" as ShellServices

// Generic panel opener for a bar (Sprint 26-C) — the bar analogue of
// StripIconBase. Whereas a strip icon hover-reveals its card, a bar opener is
// always visible and toggles its panel globally (like the settings/bell
// widgets already do). Config picks which panel: `panelId` ∈ dashboard / media /
// wallpaper / settings / nc / launcher. This is what lets panel-openers live on
// a bar, not just a strip. Icon-only vertical via BarPill.
BarPill {
    id: root
    property var config: ({})

    readonly property string _panelId: (config && config.panelId) ? config.panelId : "dashboard"
    readonly property var    _meta:    ShellServices.WidgetRegistry.stripIconMeta(_panelId)
    readonly property bool   _open:    ShellServices.ShellState.isOpenAnywhere(_panelId)

    icon: (_meta && _meta.icon) ? _meta.icon : "󰏗"
    iconColor: _open ? Commons.Appearance.colors.accent : Commons.Appearance.colors.subtext1

    onClicked: {
        if (barRoot) { barRoot._wifiPopupVisible = false; barRoot._btPopupVisible = false }
        // Wildcard side "" — a bar opener doesn't belong to a strip; each strip
        // resolves the wildcard to a single primary host (S26 follow-up B).
        ShellServices.ShellState.toggleGlobal(_panelId, "")
    }
    onEntered: if (barRoot && barRoot.horizontal) barRoot.showPopup(root,
        (_meta && _meta.name ? _meta.name : _panelId).toUpperCase(),
        (_meta && _meta.icon ? _meta.icon + "  " : "") + (_meta && _meta.name ? _meta.name : _panelId),
        "", "Click to toggle")
    onExited: if (barRoot) barRoot.hidePopup(root)
}
