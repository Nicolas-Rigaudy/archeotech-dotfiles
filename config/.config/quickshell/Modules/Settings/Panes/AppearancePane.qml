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
            icon: "󰔯"
            title: "Appearance"
            description: "Customize the visual style and typography of the shell"
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

                // ── Theme ─────────────────────────────────────────────────────
                SectionLabel { text: "THEME" }

                Rectangle {
                    Layout.fillWidth: true
                    color: Commons.Appearance.colors.surface0
                    radius: Commons.Appearance.radius.md
                    implicitHeight: themeCol.implicitHeight

                    ColumnLayout {
                        id: themeCol
                        anchors { left: parent.left; right: parent.right; top: parent.top; leftMargin: 16; rightMargin: 16 }
                        spacing: 0

                        Item { implicitHeight: 12; Layout.fillWidth: true }
                        Text {
                            text: "Full theme switching coming in Sprint 12. The palette, MangoWC blur/shadow colours, and per-app theme files will all be wired together."
                            color: Commons.Appearance.colors.subtext0
                            font.pixelSize: Commons.Appearance.font.sizeBase
                            font.family: Commons.Appearance.font.family
                            wrapMode: Text.WordWrap
                            Layout.fillWidth: true
                        }
                        Item { implicitHeight: 12; Layout.fillWidth: true }
                    }
                }

                Item { implicitHeight: 10; Layout.fillWidth: true }

                // ── Typography ────────────────────────────────────────────────
                SectionLabel { text: "TYPOGRAPHY" }

                Rectangle {
                    Layout.fillWidth: true
                    color: Commons.Appearance.colors.surface0
                    radius: Commons.Appearance.radius.md
                    implicitHeight: typoCol.implicitHeight

                    ColumnLayout {
                        id: typoCol
                        anchors { left: parent.left; right: parent.right; top: parent.top; leftMargin: 16; rightMargin: 16 }
                        spacing: 0

                        Item { implicitHeight: 4; Layout.fillWidth: true }
                        SliderRow {
                            label: "Font Size Scale"
                            description: "Scales all text relative to the base size"
                            from: 0.8; to: 1.4; stepSize: 0.05
                            value: Persistence.Config.get("appearance.fontScale", 1.0)
                            valueDisplay: Math.round(value * 100) + "%"
                            onMoved: Persistence.Config.set("appearance.fontScale", value)
                        }
                        Item { implicitHeight: 4; Layout.fillWidth: true }
                    }
                }

                Item { implicitHeight: 10; Layout.fillWidth: true }

                // ── Geometry ──────────────────────────────────────────────────
                SectionLabel { text: "GEOMETRY" }

                Rectangle {
                    Layout.fillWidth: true
                    color: Commons.Appearance.colors.surface0
                    radius: Commons.Appearance.radius.md
                    implicitHeight: geoCol.implicitHeight

                    ColumnLayout {
                        id: geoCol
                        anchors { left: parent.left; right: parent.right; top: parent.top; leftMargin: 16; rightMargin: 16 }
                        spacing: 0

                        Item { implicitHeight: 4; Layout.fillWidth: true }
                        SliderRow {
                            label: "Corner Rounding"
                            description: "Scales all border radii"
                            from: 0.5; to: 2.0; stepSize: 0.1
                            value: Persistence.Config.get("appearance.radiusScale", 1.0)
                            valueDisplay: value.toFixed(1) + "×"
                            onMoved: Persistence.Config.set("appearance.radiusScale", value)
                        }
                        Rectangle { Layout.fillWidth: true; height: 1; color: Commons.Appearance.colors.base }
                        SliderRow {
                            label: "Padding Scale"
                            description: "Scales spacing inside panels"
                            from: 0.5; to: 2.0; stepSize: 0.1
                            value: Persistence.Config.get("appearance.paddingScale", 1.0)
                            valueDisplay: value.toFixed(1) + "×"
                            onMoved: Persistence.Config.set("appearance.paddingScale", value)
                        }
                        Item { implicitHeight: 4; Layout.fillWidth: true }
                    }
                }
            }
        }
    }

    // Private section label — inline component so it can be used directly
    component SectionLabel: Text {
        Layout.fillWidth: true
        color: Commons.Appearance.colors.overlay0
        font.pixelSize: 10
        font.family: Commons.Appearance.font.family
        font.weight: Font.Medium
        font.letterSpacing: 1.5
    }
}
