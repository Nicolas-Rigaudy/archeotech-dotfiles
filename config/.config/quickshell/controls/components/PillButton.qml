import QtQuick
import QtQuick.Controls
import "../../" as Root

Button {
    property bool   active: false
    property string label: ""

    implicitHeight: 28
    implicitWidth: labelText.implicitWidth + 24

    background: Rectangle {
        radius: Root.Appearance.radius.base
        color: parent.active ? Root.Appearance.colors.accent
                             : (parent.hovered ? Root.Appearance.colors.surface0 : Root.Appearance.colors.surface0Alpha)
        border.color: parent.active ? Root.Appearance.colors.accent : "transparent"
        border.width: 1

        Behavior on color { ColorAnimation { duration: Root.Appearance.anim.fast } }
    }

    contentItem: Text {
        id: labelText
        text: parent.label
        color: parent.active ? Root.Appearance.colors.base : Root.Appearance.colors.text
        font.pixelSize: Root.Appearance.font.sizeSm
        font.family: Root.Appearance.font.family
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter

        Behavior on color { ColorAnimation { duration: Root.Appearance.anim.fast } }
    }
}
