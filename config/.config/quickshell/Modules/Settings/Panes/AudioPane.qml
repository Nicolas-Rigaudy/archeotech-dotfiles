import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../../../Commons" as Commons
import "../../../Services/Media" as MediaServices
import "../../../Services/Persistence" as Persistence
import "../Widgets"

Item {
    id: root

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        PaneHeader {
            icon: "󰕾"
            title: "Audio"
            description: "Select the default output device and configure audio behaviour"
        }

        Rectangle { Layout.fillWidth: true; height: 1; color: Commons.Appearance.colors.surface0 }

        Flickable {
            Layout.fillWidth: true
            Layout.fillHeight: true
            contentWidth: width
            contentHeight: col.implicitHeight + 32
            clip: true
            flickableDirection: Flickable.VerticalFlick
            boundsBehavior: Flickable.StopAtBounds
            ScrollBar.vertical: ScrollBar { policy: ScrollBar.AsNeeded }

            ColumnLayout {
                id: col
                anchors { top: parent.top; left: parent.left; right: parent.right; topMargin: 24; leftMargin: 24; rightMargin: 24 }
                width: root.width - 48
                spacing: 6

                SectionLabel { text: "OUTPUT DEVICE" }

                Rectangle {
                    Layout.fillWidth: true
                    color: Commons.Appearance.colors.surface0
                    radius: Commons.Appearance.radius.md
                    implicitHeight: sinksCol.implicitHeight

                    ColumnLayout {
                        id: sinksCol
                        anchors { left: parent.left; right: parent.right; top: parent.top; leftMargin: 12; rightMargin: 12 }
                        spacing: 0

                        Item { implicitHeight: 6; Layout.fillWidth: true }

                        Text {
                            visible: MediaServices.Audio.sinks.length === 0
                            text: "No audio output devices found."
                            color: Commons.Appearance.colors.overlay0
                            font.pixelSize: Commons.Appearance.font.sizeBase
                            font.family: Commons.Appearance.font.family
                            Layout.fillWidth: true
                        }

                        Repeater {
                            model: MediaServices.Audio.sinks
                            delegate: Item {
                                required property var modelData
                                required property int index
                                Layout.fillWidth: true
                                implicitHeight: 44

                                readonly property bool isDefault: modelData.name === MediaServices.Audio.defaultSink

                                Rectangle {
                                    visible: index > 0
                                    anchors { left: parent.left; right: parent.right; top: parent.top }
                                    height: 1; color: Commons.Appearance.colors.base
                                }

                                Rectangle {
                                    anchors { fill: parent; topMargin: index > 0 ? 1 : 0 }
                                    radius: index === 0
                                        ? Commons.Appearance.radius.md
                                        : (index === MediaServices.Audio.sinks.length - 1 ? Commons.Appearance.radius.md : 0)
                                    color: isDefault
                                        ? Commons.Appearance.colors.accentAlpha
                                        : (sinkMa.containsMouse ? Commons.Appearance.colors.surface1 : "transparent")
                                    Behavior on color { ColorAnimation { duration: Commons.Appearance.anim.fast } }

                                    RowLayout {
                                        anchors { fill: parent; leftMargin: 12; rightMargin: 12 }
                                        spacing: 10

                                        Text {
                                            text: isDefault ? "󰕾" : "󰖁"
                                            color: isDefault ? Commons.Appearance.colors.accent : Commons.Appearance.colors.overlay0
                                            font.pixelSize: 16; font.family: Commons.Appearance.font.family
                                            Layout.alignment: Qt.AlignVCenter
                                            Behavior on color { ColorAnimation { duration: Commons.Appearance.anim.fast } }
                                        }

                                        Text {
                                            text: modelData.description || modelData.name
                                            color: isDefault ? Commons.Appearance.colors.text : Commons.Appearance.colors.subtext1
                                            font.pixelSize: Commons.Appearance.font.sizeBase
                                            font.family: Commons.Appearance.font.family
                                            elide: Text.ElideRight
                                            Layout.fillWidth: true
                                            Behavior on color { ColorAnimation { duration: Commons.Appearance.anim.fast } }
                                        }

                                        Text {
                                            visible: isDefault
                                            text: "default"
                                            color: Commons.Appearance.colors.accent
                                            font.pixelSize: Commons.Appearance.font.sizeSm
                                            font.family: Commons.Appearance.font.family
                                        }
                                    }

                                    MouseArea {
                                        id: sinkMa
                                        anchors.fill: parent
                                        hoverEnabled: true
                                        cursorShape: Qt.PointingHandCursor
                                        onClicked: if (!isDefault) MediaServices.Audio.setDefaultSink(modelData.name)
                                    }
                                }
                            }
                        }

                        Item { implicitHeight: 6; Layout.fillWidth: true }
                    }
                }

                Item { implicitHeight: 10; Layout.fillWidth: true }
                SectionLabel { text: "INPUT DEVICE" }

                Rectangle {
                    Layout.fillWidth: true
                    color: Commons.Appearance.colors.surface0
                    radius: Commons.Appearance.radius.md
                    implicitHeight: inputCol.implicitHeight

                    ColumnLayout {
                        id: inputCol
                        anchors { left: parent.left; right: parent.right; top: parent.top; leftMargin: 16; rightMargin: 16 }
                        spacing: 0
                        Item { implicitHeight: 10; Layout.fillWidth: true }
                        Text {
                            text: "󰋽  Full source management will be available once Quickshell.Services.Pipewire lands (QS 0.3.0)."
                            color: Commons.Appearance.colors.overlay0
                            font.pixelSize: Commons.Appearance.font.sizeSm
                            font.family: Commons.Appearance.font.family
                            wrapMode: Text.WordWrap
                            Layout.fillWidth: true
                        }
                        Item { implicitHeight: 10; Layout.fillWidth: true }
                    }
                }

                Item { implicitHeight: 10; Layout.fillWidth: true }
                SectionLabel { text: "BEHAVIOUR" }

                Rectangle {
                    Layout.fillWidth: true
                    color: Commons.Appearance.colors.surface0
                    radius: Commons.Appearance.radius.md
                    implicitHeight: behavCol.implicitHeight

                    ColumnLayout {
                        id: behavCol
                        anchors { left: parent.left; right: parent.right; top: parent.top; leftMargin: 16; rightMargin: 16 }
                        spacing: 0
                        Item { implicitHeight: 4; Layout.fillWidth: true }
                        ToggleRow {
                            label: "Remember volume on restart"
                            description: "Restore last volume level on login"
                            checked: Persistence.Config.get("audio.rememberVolume", true)
                            onToggled: value => Persistence.Config.set("audio.rememberVolume", value)
                        }
                        Item { implicitHeight: 4; Layout.fillWidth: true }
                    }
                }
            }
        }
    }

    component SectionLabel: Text {
        Layout.fillWidth: true
        color: Commons.Appearance.colors.overlay0
        font.pixelSize: 10
        font.family: Commons.Appearance.font.family
        font.weight: Font.Medium
        font.letterSpacing: 1.5
    }
}
