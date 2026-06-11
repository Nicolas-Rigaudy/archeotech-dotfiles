import QtQuick
import QtQuick.Layouts
import "../../../../Commons" as Commons
import "../../../../Services/Persistence" as Persistence
import "../../../Settings" as Stg

// Sprint 24 — Settings as a unified shell panel (replaces the standalone
// FloatingWindow). Mounted inside the bottom-strip card via PanelRegistry,
// so it shares the glass chrome + popup→panel animation + ShellState
// single-open exclusion with every other panel.
//
// Layout mirrors the old Settings.qml: vertical nav sidebar | divider |
// pane carousel. Deep-linking (Commons.State.settingsOpenPane) and last-pane
// memory (Persistent.settingsActivePaneIndex) are preserved.
Item {
    id: root
    anchors.fill: parent

    property var panelRoot: null

    function _applyDeepLink() {
        if (Commons.State.settingsOpenPane !== "") {
            sidebar.activeIndex = Stg.PaneRegistry.indexFor(Commons.State.settingsOpenPane)
            Commons.State.settingsOpenPane = ""
            return true
        }
        return false
    }

    Component.onCompleted: {
        if (!_applyDeepLink())
            sidebar.activeIndex = Persistence.Persistent.settingsActivePaneIndex
    }

    // Deep-link request arriving while the panel is already mounted.
    Connections {
        target: Commons.State
        function onSettingsOpenPaneChanged() { root._applyDeepLink() }
    }

    // Re-sync to the last-used pane each time the panel reopens (unless a
    // deep-link is pending).
    Connections {
        target: root.panelRoot
        ignoreUnknownSignals: true
        function onPanelOpenChanged() {
            if (root.panelRoot && root.panelRoot.panelOpen && !root._applyDeepLink())
                sidebar.activeIndex = Persistence.Persistent.settingsActivePaneIndex
        }
    }

    RowLayout {
        anchors.fill: parent
        spacing: 0

        Stg.SettingsSidebar {
            id: sidebar
            Layout.preferredWidth: 200
            Layout.fillHeight: true
            onActiveIndexChanged: Persistence.Persistent.settingsActivePaneIndex = activeIndex
        }

        Rectangle {
            Layout.preferredWidth: 1
            Layout.fillHeight: true
            color: Commons.Appearance.colors.surface0
        }

        Stg.SettingsContent {
            Layout.fillWidth: true
            Layout.fillHeight: true
            activeIndex: sidebar.activeIndex
        }
    }
}
