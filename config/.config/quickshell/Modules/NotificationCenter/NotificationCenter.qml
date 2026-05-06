import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../../Commons" as Commons
import "../../Services/System" as SystemServices

Item {
    id: root
    anchors.fill: parent
    Keys.onEscapePressed: Commons.State.notificationCenterVisible = false

    property real panelHeight: panel.height

    Rectangle {
        id: panel
        width: 320
        anchors.top:       parent.top
        anchors.topMargin: 50

        height: Math.min(contentColumn.implicitHeight + 24, root.height - 60)
        radius: Commons.Appearance.radius.lg
        color:  Commons.Appearance.colors.glassBg
        border.color: Commons.Appearance.colors.accentBorder
        border.width: 1
        clip: true

        property real restX:   root.width - width - Commons.Appearance.spacing.base
        property real hiddenX: root.width + 8

        x: 9999
        opacity: 0

        Timer {
            id: slideInTimer
            interval: 50; repeat: false
            onTriggered: {
                panel.x = panel.hiddenX
                panel.opacity = 1
                slideAnim.from = panel.hiddenX
                slideAnim.to   = panel.restX
                slideAnim.start()
            }
        }

        Connections {
            target: root
            function onVisibleChanged() {
                if (root.visible) {
                    panel.opacity = 0
                    if (root.width > 0) slideInTimer.restart()
                } else {
                    slideInTimer.stop()
                }
            }
            function onWidthChanged() {
                if (root.visible && root.width > 0 && panel.opacity === 0
                        && !slideInTimer.running && !slideAnim.running)
                    slideInTimer.restart()
            }
        }

        NumberAnimation {
            id: slideAnim
            target: panel; property: "x"
            duration: Commons.Appearance.anim.base; easing.type: Easing.OutQuart
        }

        Flickable {
            id: flick
            anchors.fill: parent
            contentWidth: width
            contentHeight: contentColumn.implicitHeight + 24
            clip: true
            flickableDirection: Flickable.VerticalFlick
            boundsBehavior: Flickable.StopAtBounds
            ScrollBar.vertical: ScrollBar { policy: ScrollBar.AsNeeded }

            ColumnLayout {
                id: contentColumn
                anchors {
                    top: parent.top; left: parent.left; right: parent.right
                    margins: Commons.Appearance.spacing.xl
                    topMargin: 14
                }
                width: flick.width - Commons.Appearance.spacing.xl * 2
                spacing: Commons.Appearance.spacing.lg

                // ── Header ────────────────────────────────────────────────────
                RowLayout {
                    Layout.fillWidth: true
                    Text {
                        text: "󰂚  Notifications"
                        color: Commons.Appearance.colors.text
                        font.pixelSize: Commons.Appearance.font.sizeLg
                        font.family: Commons.Appearance.font.family
                        font.weight: Font.Medium
                        Layout.fillWidth: true
                    }
                    Rectangle {
                        visible: SystemServices.Notifications.count > 0
                        width:  _clearLabel.implicitWidth + 16; height: 28
                        radius: Commons.Appearance.radius.base
                        color:  _clearArea.containsMouse ? Commons.Appearance.colors.surface0 : Commons.Appearance.colors.base
                        Behavior on color { ColorAnimation { duration: Commons.Appearance.anim.fast } }
                        Text {
                            id: _clearLabel
                            anchors.centerIn: parent
                            text: "Clear all"
                            color: Commons.Appearance.colors.subtext0
                            font.pixelSize: Commons.Appearance.font.sizeSm
                            font.family: Commons.Appearance.font.family
                        }
                        MouseArea {
                            id: _clearArea; anchors.fill: parent; hoverEnabled: true
                            onClicked: SystemServices.Notifications.clearAll()
                        }
                    }
                    Rectangle {
                        width: 28; height: 28
                        radius: Commons.Appearance.radius.base
                        color: _closeArea.containsMouse ? Commons.Appearance.colors.surface0 : "transparent"
                        Behavior on color { ColorAnimation { duration: Commons.Appearance.anim.fast } }
                        Text {
                            anchors.centerIn: parent
                            text: "✕"
                            color: _closeArea.containsMouse ? Commons.Appearance.colors.text : Commons.Appearance.colors.overlay0
                            font.pixelSize: 14; font.family: Commons.Appearance.font.family
                            Behavior on color { ColorAnimation { duration: Commons.Appearance.anim.fast } }
                        }
                        MouseArea {
                            id: _closeArea; anchors.fill: parent; hoverEnabled: true
                            onClicked: Commons.State.notificationCenterVisible = false
                        }
                    }
                }

                Rectangle { Layout.fillWidth: true; height: 1; color: Commons.Appearance.colors.surface0 }

                // ── Empty state ───────────────────────────────────────────────
                Item {
                    Layout.fillWidth: true
                    visible: SystemServices.Notifications.count === 0
                    height: 90
                    ColumnLayout {
                        anchors.centerIn: parent
                        spacing: 8
                        Text {
                            Layout.alignment: Qt.AlignHCenter
                            text: "󰂚"
                            color: Commons.Appearance.colors.surface1
                            font.pixelSize: 30; font.family: Commons.Appearance.font.family
                        }
                        Text {
                            Layout.alignment: Qt.AlignHCenter
                            text: "No notifications"
                            color: Commons.Appearance.colors.overlay0
                            font.pixelSize: Commons.Appearance.font.sizeBase
                            font.family: Commons.Appearance.font.family
                        }
                    }
                }

                // ── Notification list ─────────────────────────────────────────
                Column {
                    Layout.fillWidth: true
                    spacing: 8
                    visible: SystemServices.Notifications.count > 0

                    Repeater {
                        model: SystemServices.Notifications.liveModel
                        delegate: Rectangle {
                            required property var modelData
                            width: parent.width
                            height: _itemContent.implicitHeight + 20
                            radius: Commons.Appearance.radius.md
                            color: Commons.Appearance.colors.base
                            border.color: modelData.urgency === 2
                                ? Commons.Appearance.colors.red
                                : Commons.Appearance.colors.surface0
                            border.width: 1

                            ColumnLayout {
                                id: _itemContent
                                anchors { left: parent.left; right: parent.right; top: parent.top; margins: 12 }
                                spacing: 4

                                RowLayout {
                                    Layout.fillWidth: true
                                    spacing: 6
                                    Text {
                                        text: modelData.appName || "Notification"
                                        color: Commons.Appearance.colors.overlay1
                                        font.pixelSize: Commons.Appearance.font.sizeSm
                                        font.family: Commons.Appearance.font.family
                                        Layout.fillWidth: true; elide: Text.ElideRight
                                    }
                                    Text {
                                        text: "󰅖"
                                        color: _dismissArea.containsMouse ? Commons.Appearance.colors.text : Commons.Appearance.colors.overlay0
                                        font.pixelSize: 13; font.family: Commons.Appearance.font.family
                                        Behavior on color { ColorAnimation { duration: Commons.Appearance.anim.fast } }
                                        MouseArea {
                                            id: _dismissArea
                                            anchors.fill: parent; anchors.margins: -4
                                            hoverEnabled: true
                                            onClicked: SystemServices.Notifications.dismiss(modelData)
                                        }
                                    }
                                }

                                Text {
                                    text: modelData.summary || ""
                                    visible: text.length > 0
                                    color: Commons.Appearance.colors.text
                                    font.pixelSize: Commons.Appearance.font.sizeMd
                                    font.family: Commons.Appearance.font.family
                                    font.weight: Font.Medium
                                    Layout.fillWidth: true
                                    wrapMode: Text.WordWrap
                                }

                                Text {
                                    text: modelData.body || ""
                                    visible: text.length > 0
                                    color: Commons.Appearance.colors.subtext1
                                    font.pixelSize: Commons.Appearance.font.sizeSm
                                    font.family: Commons.Appearance.font.family
                                    Layout.fillWidth: true
                                    wrapMode: Text.WordWrap
                                    maximumLineCount: 3
                                    elide: Text.ElideRight
                                }
                            }
                        }
                    }
                }

                Item { height: 2 }
            }
        }
    }
}
