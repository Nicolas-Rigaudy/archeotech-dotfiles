pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import "../../Commons" as Commons
import "./panels"
import "../Drawer" as Drawer

Item {
    id: root
    anchors.fill: parent

    focus: Drawer.DrawerVisibilities.dashboardVisible
    Keys.onEscapePressed: Drawer.DrawerVisibilities.dashboardVisible = false
    Keys.priority: Keys.BeforeItem

    // Auto-dismiss when opened via autostart (openAuto IPC call)
    Timer {
        id: autoDismiss
        interval: 4000
        repeat: false
        running: false
        onTriggered: {
            Drawer.DrawerVisibilities.dashboardVisible = false
            Commons.State.dashboardAutoOpen = false
        }
    }

    Connections {
        target: Drawer.DrawerVisibilities
        function onDashboardVisibleChanged() {
            if (Drawer.DrawerVisibilities.dashboardVisible && Commons.State.dashboardAutoOpen)
                autoDismiss.restart()
            else
                autoDismiss.stop()
        }
    }

    // Click-outside-to-close backdrop (click on the dimmed area around the panel)
    TapHandler {
        enabled: Drawer.DrawerVisibilities.dashboardVisible
        onTapped: point => {
            var x = point.position.x, y = point.position.y
            if (x < panel.x || x > panel.x + panel.width ||
                y < panel.y || y > panel.y + panel.height)
                Drawer.DrawerVisibilities.dashboardVisible = false
        }
    }

    // Glass panel
    Rectangle {
        id: panel
        anchors.centerIn: parent
        width:  Math.min(root.width  - 120, 1040)
        height: Math.min(root.height - 120,
                         Math.max(leftCol.implicitHeight, rightCol.implicitHeight) + 96)
        clip: true

        color:  Commons.Appearance.colors.base
        border.color: Commons.Appearance.colors.accentBorder
        border.width: 2
        radius: Commons.Appearance.radius.lg

        opacity: Drawer.DrawerVisibilities.dashboardVisible ? 1 : 0
        scale:   Drawer.DrawerVisibilities.dashboardVisible ? 1 : 0.96
        Behavior on opacity { NumberAnimation { duration: Commons.Appearance.anim.base } }
        Behavior on scale   { NumberAnimation { duration: Commons.Appearance.anim.base; easing.type: Easing.OutCubic } }

        // ── Header ──────────────────────────────────────────────────────
        Item {
            id: header
            anchors { top: parent.top; topMargin: 20; left: parent.left; leftMargin: 24; right: parent.right; rightMargin: 24 }
            height: 28

            Text {
                text: "ARCHEOTECH-OS"
                color: Commons.Appearance.colors.accent
                font.family: Commons.Appearance.font.family
                font.pixelSize: Commons.Appearance.font.sizeMd
                font.letterSpacing: 3
                font.bold: true
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
            }

            Text {
                id: dateLbl
                color: Commons.Appearance.colors.subtext0
                font.family: Commons.Appearance.font.family
                font.pixelSize: Commons.Appearance.font.sizeMd
                anchors { right: closeBtn.left; rightMargin: 12; verticalCenter: parent.verticalCenter }

                property var _now: new Date()
                text: Qt.formatDateTime(_now, "ddd yyyy-MM-dd")

                Timer {
                    interval: 60000
                    repeat: true
                    running: Drawer.DrawerVisibilities.dashboardVisible
                    onTriggered: dateLbl._now = new Date()
                }
            }

            // Close button
            Rectangle {
                id: closeBtn
                width: 26; height: 26
                radius: Commons.Appearance.radius.sm
                color: closeBtnHov.containsMouse ? Commons.Appearance.colors.accentAlpha : "transparent"
                border.color: closeBtnHov.containsMouse ? Commons.Appearance.colors.accentBorder : "transparent"
                anchors { right: parent.right; verticalCenter: parent.verticalCenter }
                Behavior on color { ColorAnimation { duration: Commons.Appearance.anim.fast } }

                Text {
                    text: "✕"
                    color: closeBtnHov.containsMouse ? Commons.Appearance.colors.text : Commons.Appearance.colors.overlay1
                    font.family: Commons.Appearance.font.family
                    font.pixelSize: Commons.Appearance.font.sizeMd
                    anchors.centerIn: parent
                }
                HoverHandler { id: closeBtnHov }
                TapHandler { onTapped: Drawer.DrawerVisibilities.dashboardVisible = false }
            }
        }

        Rectangle {
            id: divider
            anchors { top: header.bottom; topMargin: 8; left: parent.left; leftMargin: 24; right: parent.right; rightMargin: 24 }
            height: 1
            color: Commons.Appearance.colors.surface0
        }

        // ── Left column ──────────────────────────────────────────────────
        ColumnLayout {
            id: leftCol
            anchors {
                top:  divider.bottom; topMargin:  16
                left: parent.left;    leftMargin: 24
            }
            width: 320
            spacing: 8

            SystemStatus { Layout.fillWidth: true }
            SystemNotes  { Layout.fillWidth: true }
        }

        // ── Right column ─────────────────────────────────────────────────
        ColumnLayout {
            id: rightCol
            anchors {
                top:   divider.bottom; topMargin:   16
                left:  leftCol.right;  leftMargin:  16
                right: parent.right;   rightMargin: 24
            }
            spacing: 8

            ActiveProjects { Layout.fillWidth: true }
            QuickLaunch    { Layout.fillWidth: true }
            TipOfSession   { Layout.fillWidth: true }
        }
    }
}
