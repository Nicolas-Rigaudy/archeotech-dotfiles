import QtQuick
import QtQuick.Controls

// Animated toggle switch
Item {
    property bool checked: false
    signal toggled(bool state)

    implicitWidth: 40
    implicitHeight: 22

    Rectangle {
        id: track
        anchors.fill: parent
        radius: height / 2
        color: parent.checked ? "#c6a0f6" : "#363a4f"

        Behavior on color { ColorAnimation { duration: 150 } }

        Rectangle {
            id: thumb
            width: 16
            height: 16
            radius: 8
            anchors.verticalCenter: parent.verticalCenter
            x: parent.checked ? parent.width - width - 3 : 3
            color: parent.parent.checked ? "#24273a" : "#a5adcb"

            Behavior on x { NumberAnimation { duration: 150; easing.type: Easing.InOutQuad } }
            Behavior on color { ColorAnimation { duration: 150 } }
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            parent.checked = !parent.checked
            parent.toggled(parent.checked)
        }
    }
}
