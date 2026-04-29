import QtQuick
import QtQuick.Controls
import "../../" as Root

Button {
    property string iconName: ""
    property string label: ""

    implicitWidth: 68
    implicitHeight: 56

    background: Rectangle {
        radius: Root.Appearance.radius.md
        color: parent.hovered ? Root.Appearance.colors.surface0 : Root.Appearance.colors.surface0Alpha
        border.color: parent.hovered ? Root.Appearance.colors.accent : "transparent"
        border.width: 1

        Behavior on color        { ColorAnimation { duration: Root.Appearance.anim.fast } }
        Behavior on border.color { ColorAnimation { duration: Root.Appearance.anim.fast } }
    }

    contentItem: Column {
        anchors.centerIn: parent
        spacing: 4

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: parent.parent.iconName
            color: Root.Appearance.colors.text
            font.pixelSize: 18
            font.family: Root.Appearance.font.family
        }

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: parent.parent.label
            color: Root.Appearance.colors.subtext0
            font.pixelSize: 10
            font.family: Root.Appearance.font.family
        }
    }
}
