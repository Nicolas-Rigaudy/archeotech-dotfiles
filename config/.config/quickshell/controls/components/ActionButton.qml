import QtQuick
import QtQuick.Controls

Button {
    property string iconName: ""
    property string label: ""

    implicitWidth: 68
    implicitHeight: 56

    background: Rectangle {
        radius: 10
        color: parent.hovered ? "#363a4f" : "#2a2d3e"  // surface0 hover : surface0 dark
        border.color: parent.hovered ? "#c6a0f6" : "transparent"
        border.width: 1

        Behavior on color { ColorAnimation { duration: 120 } }
        Behavior on border.color { ColorAnimation { duration: 120 } }
    }

    contentItem: Column {
        anchors.centerIn: parent
        spacing: 4

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: parent.parent.iconName
            color: "#cad3f5"  // text
            font.pixelSize: 18
            font.family: "FiraCode Nerd Font"
        }

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: parent.parent.label
            color: "#a5adcb"  // subtext1
            font.pixelSize: 10
            font.family: "FiraCode Nerd Font"
        }
    }
}
