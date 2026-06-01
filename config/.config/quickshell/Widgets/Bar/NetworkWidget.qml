import QtQuick
import QtQuick.Layouts
import "../../Commons" as Commons
import "../../Services/Networking" as NetworkServices
import "../../Services/Persistence" as Persistence

// WiFi/ethernet status. Click opens the WiFi popup hosted by Bar.qml
// (state in barRoot._wifiPopupVisible / _wifiAnchorX). The popup itself
// gets extracted in S18 step 5 as WifiPopup.qml — for now it stays in
// Bar.qml and this widget triggers it via barRoot state.
Item {
    id: root
    required property var barRoot
    property string widgetId

    visible: Persistence.Config.get("bar.modules.wifi", true)
        && barRoot && barRoot.horizontal
    height: Commons.Appearance.bar.height
    width: netIcon.implicitWidth + 10
    Layout.alignment: Qt.AlignVCenter

    Text {
        id: netIcon
        anchors.centerIn: parent
        text: NetworkServices.Network.icon()
        color: NetworkServices.Network.connected ? Commons.Appearance.colors.blue : Commons.Appearance.colors.overlay0
        font.pixelSize: 18; font.family: Commons.Appearance.font.family
        Behavior on color { ColorAnimation { duration: Commons.Appearance.anim.fast } }
    }
    MouseArea {
        anchors.fill: parent; hoverEnabled: true
        onClicked: {
            if (!root.barRoot) return
            if (root.barRoot._wifiPopupVisible) {
                root.barRoot._wifiPopupVisible = false
            } else {
                var pt = root.mapToItem(root.barRoot, root.width / 2, 0)
                root.barRoot._wifiAnchorX      = pt.x
                root.barRoot._wifiPopupVisible = true
                root.barRoot._btPopupVisible   = false
                root.barRoot._calendarVisible  = false
                root.barRoot._popupVisible     = false
            }
        }
        onEntered: {
            netIcon.color = Commons.Appearance.colors.accent
            if (root.barRoot && !root.barRoot._wifiPopupVisible)
                root.barRoot.showPopup(root, "NETWORK",
                    NetworkServices.Network.connected
                        ? "󰖩  " + NetworkServices.Network.ssid + "   ·   " + NetworkServices.Network.signal + "%  ·  " + NetworkServices.Network.band
                        : "󰖪  Disconnected",
                    "", "Click to manage WiFi")
        }
        onExited: {
            netIcon.color = NetworkServices.Network.connected ? Commons.Appearance.colors.blue : Commons.Appearance.colors.overlay0
            if (root.barRoot) root.barRoot.hidePopup(root)
        }
    }
}
