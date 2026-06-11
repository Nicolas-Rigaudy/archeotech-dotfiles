import QtQuick
import QtQuick.Layouts
import Quickshell.Io
import "../../Commons" as Commons
import "../../Services/Persistence" as Persistence

// Shared theme-card grid (Sprint 24). Lives once here; hosted by both the
// Settings → Appearance pane and the bottom-strip Appearance quick switcher.
// Card grid (DMS-style): display name + 4-color accent swatch row. Active card
// gets an accent border + checkmark; hover scales 1.03×. Selecting a card
// writes theme.variant and runs theme-switch.py via Process.
Item {
    id: root

    // Auto-grid: as many ~168px columns as fit; height follows content.
    implicitHeight: grid.implicitHeight

    readonly property var _themes: [
        { value: "archeotech-macchiato", label: "Macchiato",   accents: ["#c6a0f6", "#8aadf4", "#a6da95", "#eed49f"] },
        { value: "archeotech-mocha",     label: "Mocha",       accents: ["#cba6f7", "#89b4fa", "#a6e3a1", "#f9e2af"] },
        { value: "dracula",              label: "Dracula",     accents: ["#bd93f9", "#8be9fd", "#50fa7b", "#ff79c6"] },
        { value: "nord",                 label: "Nord",        accents: ["#88c0d0", "#5e81ac", "#a3be8c", "#ebcb8b"] },
        { value: "gruvbox",              label: "Gruvbox",     accents: ["#fabd2f", "#83a598", "#b8bb26", "#fb4934"] },
        { value: "tokyo-night",          label: "Tokyo Night", accents: ["#bb9af7", "#7aa2f7", "#9ece6a", "#e0af68"] },
        { value: "monochrome",           label: "Monochrome",  accents: ["#d8d8d8", "#c8c8c8", "#a8a8a8", "#888888"] }
    ]
    readonly property string _currentTheme: Persistence.Config.get("theme.variant", "archeotech-macchiato")

    Process { id: themeProc; command: []; running: false }

    GridLayout {
        id: grid
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        columns: Math.max(1, Math.floor(width / 168))
        rowSpacing: 10
        columnSpacing: 10

        Repeater {
            model: root._themes
            delegate: Rectangle {
                id: themeCard
                required property var modelData
                required property int index

                readonly property bool _active: root._currentTheme === modelData.value
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

                Behavior on color        { ColorAnimation  { duration: Commons.Appearance.anim.fast } }
                Behavior on border.color { ColorAnimation  { duration: Commons.Appearance.anim.fast } }
                Behavior on scale        { NumberAnimation { duration: Commons.Appearance.anim.fast; easing.type: Easing.OutCubic } }

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
                            elide: Text.ElideRight
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
