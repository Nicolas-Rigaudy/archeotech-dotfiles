import QtQuick
import QtQuick.Controls
import "../../" as Root

Item {
    property bool checked: false
    signal toggled(bool state)

    implicitWidth: 40
    implicitHeight: 22

    Rectangle {
        id: track
        anchors.fill: parent
        radius: height / 2
        antialiasing: true
        color: parent.checked ? Root.Appearance.colors.accent : Root.Appearance.colors.surface0

        Behavior on color { ColorAnimation { duration: Root.Appearance.anim.fast } }

        Rectangle {
            width: 16; height: 16; radius: 8
            antialiasing: true
            anchors.verticalCenter: parent.verticalCenter
            x: parent.parent.checked ? parent.width - width - 3 : 3
            color: parent.parent.checked ? Root.Appearance.colors.base : Root.Appearance.colors.subtext0

            Behavior on x     { NumberAnimation { duration: Root.Appearance.anim.fast; easing.type: Easing.InOutQuad } }
            Behavior on color { ColorAnimation   { duration: Root.Appearance.anim.fast } }
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: { parent.checked = !parent.checked; parent.toggled(parent.checked) }
    }
}
