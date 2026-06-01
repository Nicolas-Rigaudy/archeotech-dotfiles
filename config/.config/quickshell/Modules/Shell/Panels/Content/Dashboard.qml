pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import "../../../../Commons" as Commons
import "../../../Dashboard/panels"

// Dashboard UI — bottom-edge panel (PanelRegistry side="bottom"). Panel.qml
// provides chrome + slide anim + Esc + click-outside; this file is the inner
// content only. `panelRoot` is injected by Loader.onLoaded.
//
// Auto-dismiss timer (4s) fires when `Commons.State.dashboardAutoOpen` is
// true and closes via `panelRoot.close()`.
Item {
    id: root
    anchors.fill: parent

    property var panelRoot

    // Auto-dismiss when opened via autostart (openAuto IPC call)
    Timer {
        id: autoDismiss
        interval: 4000
        repeat: false
        running: false
        onTriggered: {
            if (root.panelRoot) root.panelRoot.close()
            Commons.State.dashboardAutoOpen = false
        }
    }

    Connections {
        target: root.panelRoot
        enabled: root.panelRoot !== null
        function onPanelOpenChanged() {
            if (root.panelRoot.panelOpen && Commons.State.dashboardAutoOpen)
                autoDismiss.restart()
            else
                autoDismiss.stop()
        }
    }

    // Content container — fills Panel's Loader bounds. Panel.qml owns chrome
    // (color/border/radius) + slide-from-bottom anim.
    Item {
        id: panel
        anchors.fill: parent
        clip: true

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
                    running: root.panelRoot ? root.panelRoot.panelOpen : false
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
                TapHandler { onTapped: if (root.panelRoot) root.panelRoot.close() }
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
