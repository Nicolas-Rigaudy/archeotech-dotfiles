import QtQuick
import Quickshell
import Quickshell._Window
import ".." as Root

// Floating info popup shown on bar icon hover.
// Anchored to the hovered icon item via anchor.item.

PopupWindow {
    id: popupWindow

    property var    anchorItem: null
    property string label:      ""
    property string primary:    ""
    property string secondary:  ""
    property string hint:       ""

    visible: false

    anchor.item:    anchorItem
    anchor.edges:   Edges.Bottom
    anchor.gravity: Edges.Bottom

    implicitWidth:  card.implicitWidth
    implicitHeight: card.implicitHeight
    color: "transparent"

    Rectangle {
        id: card
        implicitWidth:  col.implicitWidth  + 24
        implicitHeight: col.implicitHeight + 20
        anchors.fill: parent
        radius: Root.Appearance.radius.md
        color: Root.Appearance.colors.glassBgLight
        border.color: Root.Appearance.colors.glassBorder
        border.width: 1

        Rectangle {
            anchors { top: parent.top; left: parent.left; right: parent.right; topMargin: 1; leftMargin: 2; rightMargin: 2 }
            height: 1; radius: parent.radius
            color: Qt.rgba(1, 1, 1, 0.08)
        }

        Column {
            id: col
            anchors { left: parent.left; top: parent.top; margins: 12 }
            spacing: 5

            Text {
                visible: popupWindow.label.length > 0
                text: popupWindow.label
                color: Root.Appearance.colors.overlay0
                font.pixelSize: Root.Appearance.font.sizeSm - 1
                font.family: Root.Appearance.font.family
                font.letterSpacing: 0.8
            }
            Text {
                text: popupWindow.primary
                color: Root.Appearance.colors.text
                font.pixelSize: Root.Appearance.font.sizeMd
                font.family: Root.Appearance.font.family
                font.weight: Font.Medium
            }
            Text {
                visible: popupWindow.secondary.length > 0
                text: popupWindow.secondary
                color: Root.Appearance.colors.subtext0
                font.pixelSize: Root.Appearance.font.sizeSm
                font.family: Root.Appearance.font.family
            }
            Text {
                visible: popupWindow.hint.length > 0
                text: popupWindow.hint
                color: Root.Appearance.colors.overlay0
                font.pixelSize: Root.Appearance.font.sizeSm - 1
                font.family: Root.Appearance.font.family
            }
        }
    }
}
