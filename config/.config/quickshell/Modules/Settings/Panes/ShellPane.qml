import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../../../Commons" as Commons
import "../../../Services/Persistence" as Persistence
import "../../../Services/Shell" as ShellServices
import "../Widgets"

// Shell pane (Sprint 24) — hub for shell-structure customization: the visual
// builder (edit mode), bar layout, clock, module visibility. Renamed from the
// old "Bar" pane; designed to absorb widget/strip controls as settings grow.
Item {
    id: root

    // Enter the visual builder — close the open panel first so the editor owns
    // the surface (mirrors shell.qml _setEditMode).
    function _enterEditMode() {
        ShellServices.ShellState.closeAllAcross()
        Commons.State.editMode = true
    }

    // Frame sliders write to shell-config (the source the frame reads), but a
    // slider drag fires continuously — debounce so we don't thrash the file /
    // reload on every tick. Live values preview locally; commit on settle.
    property int  _pendingRadius: -1
    property int  _pendingGap:    -1
    Timer {
        id: _radiusTimer; interval: 250
        onTriggered: if (root._pendingRadius >= 0) { ShellServices.ShellConfig.setCornerRadius(root._pendingRadius); root._pendingRadius = -1 }
    }
    Timer {
        id: _gapTimer; interval: 250
        onTriggered: if (root._pendingGap >= 0) { ShellServices.ShellConfig.setOuterGap(root._pendingGap); root._pendingGap = -1 }
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        PaneHeader {
            icon: "󰍹"
            title: "Shell"
            description: "Customize the bar, edge strips and widgets — and open the visual builder"
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

                // ── Edit layout (visual builder entry) ─────────────────────────
                SectionLabel { text: "CUSTOMIZE" }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 64
                    radius: Commons.Appearance.radius.md
                    color: editMa.containsMouse ? Commons.Appearance.colors.surface1 : Commons.Appearance.colors.surface0
                    border.width: 1
                    border.color: editMa.containsMouse ? Commons.Appearance.colors.accentBorder : "transparent"
                    Behavior on color        { ColorAnimation { duration: Commons.Appearance.anim.fast } }
                    Behavior on border.color { ColorAnimation { duration: Commons.Appearance.anim.fast } }

                    RowLayout {
                        anchors { fill: parent; leftMargin: 16; rightMargin: 16 }
                        spacing: 14

                        Text {
                            text: "󰏬"
                            color: Commons.Appearance.colors.accent
                            font.pixelSize: 24; font.family: Commons.Appearance.font.family
                            Layout.alignment: Qt.AlignVCenter
                        }
                        ColumnLayout {
                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignVCenter
                            spacing: 2
                            Text {
                                text: "Edit Layout"
                                color: Commons.Appearance.colors.text
                                font.pixelSize: Commons.Appearance.font.sizeMd
                                font.family: Commons.Appearance.font.family
                                font.weight: Font.Medium
                            }
                            Text {
                                text: "Click-to-assign builder for the bar, strips & widgets  ·  Super+Shift+E"
                                color: Commons.Appearance.colors.subtext0
                                font.pixelSize: Commons.Appearance.font.sizeSm
                                font.family: Commons.Appearance.font.family
                                Layout.fillWidth: true
                                wrapMode: Text.WordWrap
                            }
                        }
                        Text {
                            text: "󰅂"
                            color: Commons.Appearance.colors.overlay1
                            font.pixelSize: 18; font.family: Commons.Appearance.font.family
                            Layout.alignment: Qt.AlignVCenter
                        }
                    }

                    MouseArea {
                        id: editMa
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: root._enterEditMode()
                    }
                }

                Item { implicitHeight: 10; Layout.fillWidth: true }
                SectionLabel { text: "FRAME" }

                Rectangle {
                    Layout.fillWidth: true
                    color: Commons.Appearance.colors.surface0
                    radius: Commons.Appearance.radius.md
                    implicitHeight: frameCol.implicitHeight

                    ColumnLayout {
                        id: frameCol
                        anchors { left: parent.left; right: parent.right; top: parent.top; leftMargin: 16; rightMargin: 16 }
                        spacing: 0

                        Item { implicitHeight: 4; Layout.fillWidth: true }
                        ToggleRow {
                            label: "Pill frame"
                            description: "Float the whole frame off the screen edges with rounded outer corners"
                            checked: ShellServices.ShellConfig.pillMode()
                            onToggled: value => ShellServices.ShellConfig.setPillMode(value)
                        }
                        Rectangle { Layout.fillWidth: true; height: 1; color: Commons.Appearance.colors.base }
                        SliderRow {
                            label: "Corner Radius"
                            description: "Roundness of the frame's inner corners"
                            from: 0; to: 24; stepSize: 1
                            value: ShellServices.ShellConfig.cornerRadius()
                            valueDisplay: Math.round(value) + "px"
                            onMoved: (v) => { root._pendingRadius = Math.round(v); _radiusTimer.restart() }
                        }
                        Rectangle { Layout.fillWidth: true; height: 1; color: Commons.Appearance.colors.base }
                        SliderRow {
                            label: "Outer Gap"
                            description: "Breathing space between the shell and tiled windows"
                            from: 0; to: 20; stepSize: 1
                            value: ShellServices.ShellConfig.outerGap()
                            valueDisplay: Math.round(value) + "px"
                            onMoved: (v) => { root._pendingGap = Math.round(v); _gapTimer.restart() }
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
                            text: "󰋽  Add, remove and arrange widgets in the bar and edge strips from Edit Layout above. Frame changes apply live."
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
}
