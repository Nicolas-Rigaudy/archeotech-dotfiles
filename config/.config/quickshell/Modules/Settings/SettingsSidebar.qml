import QtQuick
import QtQuick.Layouts
import "../../Commons" as Commons

Item {
    id: root
    property int activeIndex: 0
    signal paneSelected(int index)

    Rectangle {
        anchors.fill: parent
        color: Commons.Appearance.colors.mantle

        ColumnLayout {
            anchors.fill: parent
            spacing: 0

            // ── Brand header ──────────────────────────────────────────────────
            Item {
                Layout.fillWidth: true
                implicitHeight: 70

                ColumnLayout {
                    anchors { left: parent.left; right: parent.right; verticalCenter: parent.verticalCenter; leftMargin: 20 }
                    spacing: 2

                    Text {
                        text: "ARCHEOTECH"
                        color: Commons.Appearance.colors.overlay0
                        font.pixelSize: 9
                        font.family: Commons.Appearance.font.family
                        font.weight: Font.Medium
                        font.letterSpacing: 2
                    }

                    Text {
                        text: "Settings"
                        color: Commons.Appearance.colors.accent
                        font.pixelSize: 18
                        font.family: Commons.Appearance.font.family
                        font.weight: Font.Bold
                    }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                height: 1
                color: Commons.Appearance.colors.surface0
            }

            Item { implicitHeight: 8; Layout.fillWidth: true }

            // ── Nav items ─────────────────────────────────────────────────────
            Repeater {
                model: PaneRegistry.panes
                delegate: Item {
                    id: navItem
                    required property var modelData
                    required property int index

                    Layout.fillWidth: true
                    implicitHeight: 44

                    Rectangle {
                        id: activeBg
                        anchors { fill: parent; leftMargin: 8; rightMargin: 8 }
                        radius: Commons.Appearance.radius.base
                        color: root.activeIndex === navItem.index
                            ? Commons.Appearance.colors.accentAlpha
                            : (navArea.containsMouse ? Commons.Appearance.colors.surface0 : "transparent")
                        Behavior on color { ColorAnimation { duration: Commons.Appearance.anim.fast } }
                    }

                    // Left accent bar for active state
                    Rectangle {
                        visible: root.activeIndex === navItem.index
                        anchors { left: parent.left; leftMargin: 10; verticalCenter: parent.verticalCenter }
                        width: 3; height: 20; radius: 2
                        color: Commons.Appearance.colors.accent
                        Behavior on opacity { NumberAnimation { duration: Commons.Appearance.anim.fast } }
                    }

                    RowLayout {
                        anchors { fill: parent; leftMargin: 20; rightMargin: 16 }
                        spacing: 12

                        Text {
                            text: navItem.modelData.icon
                            color: root.activeIndex === navItem.index
                                ? Commons.Appearance.colors.accent
                                : Commons.Appearance.colors.subtext0
                            font.pixelSize: 16
                            font.family: Commons.Appearance.font.family
                            Layout.alignment: Qt.AlignVCenter
                            Behavior on color { ColorAnimation { duration: Commons.Appearance.anim.fast } }
                        }

                        Text {
                            text: navItem.modelData.label
                            color: root.activeIndex === navItem.index
                                ? Commons.Appearance.colors.text
                                : Commons.Appearance.colors.subtext0
                            font.pixelSize: Commons.Appearance.font.sizeBase
                            font.family: Commons.Appearance.font.family
                            font.weight: root.activeIndex === navItem.index ? Font.Medium : Font.Normal
                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignVCenter
                            Behavior on color { ColorAnimation { duration: Commons.Appearance.anim.fast } }
                        }
                    }

                    MouseArea {
                        id: navArea
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: {
                            root.activeIndex = navItem.index
                            root.paneSelected(navItem.index)
                        }
                    }
                }
            }

            Item { Layout.fillWidth: true; Layout.fillHeight: true }

            // ── Version footer ────────────────────────────────────────────────
            Rectangle {
                Layout.fillWidth: true
                height: 1
                color: Commons.Appearance.colors.surface0
            }

            Item {
                Layout.fillWidth: true
                implicitHeight: 40

                Text {
                    anchors { left: parent.left; leftMargin: 20; verticalCenter: parent.verticalCenter }
                    text: "Quickshell 0.2.1"
                    color: Commons.Appearance.colors.overlay0
                    font.pixelSize: Commons.Appearance.font.sizeSm
                    font.family: Commons.Appearance.font.family
                }
            }
        }

        // Wheel scroll
        MouseArea {
            anchors.fill: parent
            acceptedButtons: Qt.NoButton
            onWheel: wheel => {
                if (wheel.angleDelta.y < 0)
                    root.activeIndex = Math.min(root.activeIndex + 1, PaneRegistry.panes.length - 1)
                else
                    root.activeIndex = Math.max(root.activeIndex - 1, 0)
            }
        }
    }
}
