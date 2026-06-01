import QtQuick
import QtQuick.Layouts
import Quickshell.Io
import "../../Commons" as Commons

// Power button — launches wlogout.
Item {
    id: root
    required property var barRoot
    property string widgetId

    visible: barRoot && barRoot.horizontal
    height: Commons.Appearance.bar.height
    width: powerIcon.implicitWidth + 10
    Layout.alignment: Qt.AlignVCenter

    Process { id: powerCmd; command: ["bash", "-c", "wlogout-launch.sh &"]; running: false }

    Text {
        id: powerIcon
        anchors.centerIn: parent
        text: "󰐥"
        color: Commons.Appearance.colors.subtext1
        font.pixelSize: 18; font.family: Commons.Appearance.font.family
        Behavior on color { ColorAnimation { duration: Commons.Appearance.anim.fast } }
    }
    MouseArea {
        anchors.fill: parent; hoverEnabled: true
        onClicked: powerCmd.running = true
        onEntered: {
            powerIcon.color = Commons.Appearance.colors.red
            if (root.barRoot) root.barRoot.showPopup(root, "POWER", "󰐥  Power menu", "", "Click to open")
        }
        onExited: {
            powerIcon.color = Commons.Appearance.colors.subtext1
            if (root.barRoot) root.barRoot.hidePopup(root)
        }
    }
}
