import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../../../Commons" as Commons
import "../../../Services/Persistence" as Persistence
import "../Widgets"

Item {
    id: root

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        PaneHeader {
            icon: "󰘧"
            title: "Bar"
            description: "Configure the top bar height, clock format and which modules are shown"
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

                SectionLabel { text: "LAYOUT" }

                Rectangle {
                    Layout.fillWidth: true
                    color: Commons.Appearance.colors.surface0
                    radius: Commons.Appearance.radius.md
                    implicitHeight: layoutCol.implicitHeight

                    ColumnLayout {
                        id: layoutCol
                        anchors { left: parent.left; right: parent.right; top: parent.top; leftMargin: 16; rightMargin: 16 }
                        spacing: 0

                        Item { implicitHeight: 4; Layout.fillWidth: true }
                        SliderRow {
                            label: "Bar Height"
                            description: "Takes effect after reloading the shell"
                            from: 28; to: 52; stepSize: 2
                            value: Persistence.Config.get("bar.height", 36)
                            valueDisplay: Math.round(value) + "px"
                            onMoved: Persistence.Config.set("bar.height", Math.round(value))
                        }
                        Item { implicitHeight: 4; Layout.fillWidth: true }
                    }
                }

                Item { implicitHeight: 10; Layout.fillWidth: true }
                SectionLabel { text: "CLOCK" }

                Rectangle {
                    Layout.fillWidth: true
                    color: Commons.Appearance.colors.surface0
                    radius: Commons.Appearance.radius.md
                    implicitHeight: clockCol.implicitHeight

                    ColumnLayout {
                        id: clockCol
                        anchors { left: parent.left; right: parent.right; top: parent.top; leftMargin: 16; rightMargin: 16 }
                        spacing: 0
                        Item { implicitHeight: 8; Layout.fillWidth: true }
                        ButtonGroupRow {
                            label: "Format"
                            options: [
                                { value: "HH:mm",    label: "24h"   },
                                { value: "HH:mm:ss", label: "24h+s" },
                                { value: "h:mm ap",  label: "12h"   },
                            ]
                            currentValue: Persistence.Config.get("bar.clockFormat", "HH:mm")
                            onSelected: value => Persistence.Config.set("bar.clockFormat", value)
                        }
                        Item { implicitHeight: 8; Layout.fillWidth: true }
                    }
                }

                Item { implicitHeight: 10; Layout.fillWidth: true }
                SectionLabel { text: "MODULES" }

                Rectangle {
                    Layout.fillWidth: true
                    color: Commons.Appearance.colors.surface0
                    radius: Commons.Appearance.radius.md
                    implicitHeight: modCol.implicitHeight

                    ColumnLayout {
                        id: modCol
                        anchors { left: parent.left; right: parent.right; top: parent.top; leftMargin: 16; rightMargin: 16 }
                        spacing: 0

                        Item { implicitHeight: 4; Layout.fillWidth: true }
                        ToggleRow {
                            label: "Music (MPRIS)"
                            checked: Persistence.Config.get("bar.modules.music", true)
                            onToggled: value => Persistence.Config.set("bar.modules.music", value)
                        }
                        Rectangle { Layout.fillWidth: true; height: 1; color: Commons.Appearance.colors.base }
                        ToggleRow {
                            label: "WiFi"
                            checked: Persistence.Config.get("bar.modules.wifi", true)
                            onToggled: value => Persistence.Config.set("bar.modules.wifi", value)
                        }
                        Rectangle { Layout.fillWidth: true; height: 1; color: Commons.Appearance.colors.base }
                        ToggleRow {
                            label: "Bluetooth"
                            checked: Persistence.Config.get("bar.modules.bluetooth", true)
                            onToggled: value => Persistence.Config.set("bar.modules.bluetooth", value)
                        }
                        Rectangle { Layout.fillWidth: true; height: 1; color: Commons.Appearance.colors.base }
                        ToggleRow {
                            label: "Battery"
                            checked: Persistence.Config.get("bar.modules.battery", true)
                            onToggled: value => Persistence.Config.set("bar.modules.battery", value)
                        }
                        Item { implicitHeight: 4; Layout.fillWidth: true }
                    }
                }

                Item { implicitHeight: 10; Layout.fillWidth: true }

                Rectangle {
                    Layout.fillWidth: true
                    color: Commons.Appearance.colors.surface0
                    radius: Commons.Appearance.radius.md
                    implicitHeight: noteCol.implicitHeight

                    ColumnLayout {
                        id: noteCol
                        anchors { left: parent.left; right: parent.right; top: parent.top; leftMargin: 16; rightMargin: 16 }
                        spacing: 0
                        Item { implicitHeight: 10; Layout.fillWidth: true }
                        Text {
                            text: "󰋽  Module visibility takes effect immediately. Bar height requires reloading Quickshell."
                            color: Commons.Appearance.colors.overlay0
                            font.pixelSize: Commons.Appearance.font.sizeSm
                            font.family: Commons.Appearance.font.family
                            wrapMode: Text.WordWrap
                            Layout.fillWidth: true
                        }
                        Item { implicitHeight: 10; Layout.fillWidth: true }
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
