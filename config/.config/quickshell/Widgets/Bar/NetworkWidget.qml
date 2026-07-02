import QtQuick
import "../../Commons" as Commons
import "../../Services/Networking" as NetworkServices
import "../../Services/Persistence" as Persistence

// WiFi/ethernet status. Click opens the WiFi popup hosted by Bar.qml
// (state in barRoot._wifiPopupVisible / _wifiAnchorX). Icon-only (BarPill).
// ponytail: the popup anchors on a horizontal-bar X coord — on a vertical bar
// it would misposition; vertical popup anchoring is a later pass (S26-C note).
BarPill {
    id: root
    visible: Persistence.Config.get("bar.modules.wifi", true)
    icon: NetworkServices.Network.icon()
    iconColor: NetworkServices.Network.connected ? Commons.Appearance.colors.blue : Commons.Appearance.colors.overlay0

    onClicked: {
        if (!barRoot) return
        if (barRoot._wifiPopupVisible) {
            barRoot._wifiPopupVisible = false
        } else {
            var pt = root.mapToItem(barRoot, root.width / 2, 0)
            barRoot._wifiAnchorX      = pt.x
            barRoot._wifiPopupVisible = true
            barRoot._btPopupVisible   = false
            barRoot._calendarVisible  = false
            barRoot._popupVisible     = false
        }
    }
    onEntered: if (barRoot && barRoot.horizontal && !barRoot._wifiPopupVisible)
        barRoot.showPopup(root, "NETWORK",
            NetworkServices.Network.connected
                ? "󰖩  " + NetworkServices.Network.ssid + "   ·   " + NetworkServices.Network.signal + "%  ·  " + NetworkServices.Network.band
                : "󰖪  Disconnected",
            "", "Click to manage WiFi")
    onExited: if (barRoot) barRoot.hidePopup(root)
}
