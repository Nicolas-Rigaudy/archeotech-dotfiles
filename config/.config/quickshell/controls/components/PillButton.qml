import QtQuick
import QtQuick.Controls

// Mutually exclusive option button — used for Display layout, Power Profile, Night Light
Button {
    property bool active: false
    property string label: ""

    implicitHeight: 28
    implicitWidth: labelText.implicitWidth + 24

    background: Rectangle {
        radius: 8
        color: parent.active ? "#c6a0f6" : (parent.hovered ? "#363a4f" : "#2a2d3e")
        border.color: parent.active ? "#c6a0f6" : "transparent"
        border.width: 1

        Behavior on color { ColorAnimation { duration: 120 } }
    }

    contentItem: Text {
        id: labelText
        text: parent.label
        color: parent.active ? "#24273a" : "#cad3f5"
        font.pixelSize: 11
        font.family: "FiraCode Nerd Font"
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter

        Behavior on color { ColorAnimation { duration: 120 } }
    }
}
