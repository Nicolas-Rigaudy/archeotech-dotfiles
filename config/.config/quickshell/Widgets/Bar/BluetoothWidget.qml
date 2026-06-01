import QtQuick
import QtQuick.Layouts
import "../../Commons" as Commons
import "../../Services/Networking" as NetworkServices
import "../../Services/Persistence" as Persistence

// Bluetooth toggle + paired-device picker (popup hosted by Bar.qml).
Item {
    id: root
    required property var barRoot
    property string widgetId

    visible: Persistence.Config.get("bar.modules.bluetooth", true)
        && barRoot && barRoot.horizontal
    height: Commons.Appearance.bar.height
    width: btIcon.implicitWidth + 10
    Layout.alignment: Qt.AlignVCenter

    Text {
        id: btIcon
        anchors.centerIn: parent
        text: NetworkServices.Bluetooth.icon()
        color: NetworkServices.Bluetooth.connected ? Commons.Appearance.colors.mauve
             : NetworkServices.Bluetooth.enabled   ? Commons.Appearance.colors.subtext1
             :                                        Commons.Appearance.colors.overlay0
        font.pixelSize: 18; font.family: Commons.Appearance.font.family
        Behavior on color { ColorAnimation { duration: Commons.Appearance.anim.fast } }
    }
    MouseArea {
        anchors.fill: parent; hoverEnabled: true
        onClicked: {
            if (!root.barRoot) return
            if (root.barRoot._btPopupVisible) {
                root.barRoot._btPopupVisible = false
            } else {
                var pt = root.mapToItem(root.barRoot, root.width / 2, 0)
                root.barRoot._btAnchorX        = pt.x
                root.barRoot._btPopupVisible   = true
                root.barRoot._wifiPopupVisible = false
                root.barRoot._calendarVisible  = false
                root.barRoot._popupVisible     = false
            }
        }
        onEntered: {
            btIcon.color = Commons.Appearance.colors.accent
            if (root.barRoot && !root.barRoot._btPopupVisible)
                root.barRoot.showPopup(root, "BLUETOOTH",
                    NetworkServices.Bluetooth.connected ? "󰂱  " + NetworkServices.Bluetooth.device
                        : NetworkServices.Bluetooth.enabled ? "󰂯  On — no device" : "󰂲  Off",
                    "", "Click to manage Bluetooth")
        }
        onExited: {
            btIcon.color = NetworkServices.Bluetooth.connected ? Commons.Appearance.colors.mauve
                : NetworkServices.Bluetooth.enabled ? Commons.Appearance.colors.subtext1 : Commons.Appearance.colors.overlay0
            if (root.barRoot) root.barRoot.hidePopup(root)
        }
    }
}
