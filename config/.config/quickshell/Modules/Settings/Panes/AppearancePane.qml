import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell.Io
import "../../../Commons" as Commons
import "../../../Services/Persistence" as Persistence
import "../Widgets"

Item {
    id: root

    Process {
        id: themeProc
        command: []
        running: false
    }

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

                // Card-grid metadata. Display name + 4-color accent swatch per theme.
                property var _themes: [
                    { value: "archeotech-macchiato", label: "Macchiato",   accents: ["#c6a0f6", "#8aadf4", "#a6da95", "#eed49f"] },
                    { value: "archeotech-mocha",     label: "Mocha",       accents: ["#cba6f7", "#89b4fa", "#a6e3a1", "#f9e2af"] },
                    { value: "dracula",              label: "Dracula",     accents: ["#bd93f9", "#8be9fd", "#50fa7b", "#ff79c6"] },
                    { value: "nord",                 label: "Nord",        accents: ["#88c0d0", "#5e81ac", "#a3be8c", "#ebcb8b"] },
                    { value: "gruvbox",              label: "Gruvbox",     accents: ["#fabd2f", "#83a598", "#b8bb26", "#fb4934"] },
                    { value: "tokyo-night",          label: "Tokyo Night", accents: ["#bb9af7", "#7aa2f7", "#9ece6a", "#e0af68"] },
                    { value: "monochrome",           label: "Monochrome",  accents: ["#d8d8d8", "#c8c8c8", "#a8a8a8", "#888888"] }
                ]
                readonly property string _currentTheme: Persistence.Config.get("theme.variant", "archeotech-macchiato")

                // ── Theme ─────────────────────────────────────────────────────
                // Card grid (DMS-style) — each card shows the theme's display
                // name + 4-color accent swatch row. Active card gets an accent
                // border + checkmark badge. Hover scales 1.03×.
                SectionLabel { text: "THEME" }

                Item {
                    Layout.fillWidth: true
                    implicitHeight: themeGrid.implicitHeight + 16

                    GridLayout {
                        id: themeGrid
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.top: parent.top
                        anchors.topMargin: 8
                        columns: Math.max(1, Math.floor(width / 168))
                        rowSpacing: 10
                        columnSpacing: 10

                        Repeater {
                            model: col._themes
                            delegate: Rectangle {
                                id: themeCard
                                required property var modelData
                                required property int index

                                readonly property bool _active: col._currentTheme === modelData.value
                                property bool _hovered: false

                                Layout.fillWidth: true
                                Layout.preferredHeight: 88
                                radius: Commons.Appearance.radius.md
                                color: _active
                                    ? Commons.Appearance.colors.surface1
                                    : (_hovered ? Commons.Appearance.colors.surface0 : Commons.Appearance.colors.base)
                                border.width: _active ? 2 : 1
                                border.color: _active
                                    ? Commons.Appearance.colors.accent
                                    : Commons.Appearance.colors.surface0
                                scale: _hovered && !_active ? 1.03 : 1.0

                                Behavior on color       { ColorAnimation  { duration: Commons.Appearance.anim.fast } }
                                Behavior on border.color{ ColorAnimation  { duration: Commons.Appearance.anim.fast } }
                                Behavior on scale       { NumberAnimation { duration: Commons.Appearance.anim.fast; easing.type: Easing.OutCubic } }

                                ColumnLayout {
                                    anchors.fill: parent
                                    anchors.margins: 12
                                    spacing: 8

                                    RowLayout {
                                        Layout.fillWidth: true
                                        spacing: 6
                                        Text {
                                            text: themeCard.modelData.label
                                            color: Commons.Appearance.colors.text
                                            font.pixelSize: Commons.Appearance.font.sizeBase
                                            font.family: Commons.Appearance.font.family
                                            font.weight: Font.Medium
                                            Layout.fillWidth: true
                                        }
                                        Text {
                                            visible: themeCard._active
                                            text: "✓"
                                            color: Commons.Appearance.colors.accent
                                            font.pixelSize: 14
                                            font.bold: true
                                        }
                                    }

                                    RowLayout {
                                        Layout.fillWidth: true
                                        spacing: 6
                                        Repeater {
                                            model: themeCard.modelData.accents
                                            delegate: Rectangle {
                                                required property string modelData
                                                Layout.fillWidth: true
                                                Layout.preferredHeight: 16
                                                radius: 4
                                                color: modelData
                                            }
                                        }
                                    }
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    cursorShape: Qt.PointingHandCursor
                                    onEntered: themeCard._hovered = true
                                    onExited:  themeCard._hovered = false
                                    onClicked: {
                                        Persistence.Config.set("theme.variant", themeCard.modelData.value)
                                        themeProc.command = [Commons.Paths.themeSwitch, themeCard.modelData.value]
                                        themeProc.running = true
                                    }
                                }
                            }
                        }
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
