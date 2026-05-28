import QtQuick
import QtQuick.Layouts
import Quickshell
import "../../Commons" as Commons
import "../../Services/Persistence" as Persistence

FloatingWindow {
    id: settingsWindow
    visible: Commons.State.settingsVisible
    title: "Archeotech Settings"
    implicitWidth: 900
    implicitHeight: 800
    color: Commons.Appearance.colors.base

    Connections {
        target: Commons.State
        function onSettingsOpenPaneChanged() {
            if (Commons.State.settingsOpenPane !== "") {
                sidebar.activeIndex = PaneRegistry.indexFor(Commons.State.settingsOpenPane)
                Commons.State.settingsOpenPane = ""
            }
        }
        function onSettingsVisibleChanged() {
            if (Commons.State.settingsVisible)
                sidebar.activeIndex = Persistence.Persistent.settingsActivePaneIndex
        }
    }

    Item {
        anchors.fill: parent
        focus: true
        Keys.onEscapePressed: Commons.State.settingsVisible = false

        RowLayout {
            anchors.fill: parent
            spacing: 0

            SettingsSidebar {
                id: sidebar
                Layout.preferredWidth: 200
                Layout.fillHeight: true
                Component.onCompleted: activeIndex = Persistence.Persistent.settingsActivePaneIndex
                onActiveIndexChanged: Persistence.Persistent.settingsActivePaneIndex = activeIndex
            }

            Rectangle {
                Layout.preferredWidth: 1
                Layout.fillHeight: true
                color: Commons.Appearance.colors.surface0
            }

            SettingsContent {
                Layout.fillWidth: true
                Layout.fillHeight: true
                activeIndex: sidebar.activeIndex
            }
        }
    }
}
