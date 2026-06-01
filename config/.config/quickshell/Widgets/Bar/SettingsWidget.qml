import QtQuick
import QtQuick.Layouts
import "../../Commons" as Commons
import "../../Services/Shell" as ShellServices

// Settings gear — toggles the Control Center panel.
Item {
    id: root
    required property var barRoot
    property string widgetId

    visible: barRoot && barRoot.horizontal
    height: Commons.Appearance.bar.height
    width: settingsIcon.implicitWidth + 10
    Layout.alignment: Qt.AlignVCenter

    Text {
        id: settingsIcon
        anchors.centerIn: parent
        text: "󰒓"
        color: Commons.Appearance.colors.subtext1
        font.pixelSize: 18; font.family: Commons.Appearance.font.family
        Behavior on color { ColorAnimation { duration: Commons.Appearance.anim.fast } }
    }
    MouseArea {
        anchors.fill: parent; hoverEnabled: true
        onClicked: {
            if (root.barRoot) {
                root.barRoot._wifiPopupVisible = false
                root.barRoot._btPopupVisible   = false
            }
            ShellServices.ShellState.toggleGlobal("cc")
        }
        onEntered: {
            settingsIcon.color = Commons.Appearance.colors.accent
            if (root.barRoot) root.barRoot.showPopup(root, "SETTINGS", "󰒓  Control Center", "", "Click to toggle")
        }
        onExited: {
            settingsIcon.color = Commons.Appearance.colors.subtext1
            if (root.barRoot) root.barRoot.hidePopup(root)
        }
    }
}
