import QtQuick
import "../../Commons" as Commons
import "../../Services/Networking" as NetworkServices
import "../../Services/Persistence" as Persistence

// Bluetooth toggle + paired-device picker (popup hosted by Bar.qml). Icon-only.
// ponytail: popup anchors on a horizontal X coord (see NetworkWidget note).
BarPill {
    id: root
    visible: Persistence.Config.get("bar.modules.bluetooth", true)
    icon: NetworkServices.Bluetooth.icon()
    iconColor: NetworkServices.Bluetooth.connected ? Commons.Appearance.colors.mauve
             : NetworkServices.Bluetooth.enabled   ? Commons.Appearance.colors.subtext1
             :                                        Commons.Appearance.colors.overlay0

    onClicked: {
        if (!barRoot) return
        if (barRoot._btPopupVisible) {
            barRoot._btPopupVisible = false
        } else {
            var pt = root.mapToItem(barRoot, root.width / 2, 0)
            barRoot._btAnchorX        = pt.x
            barRoot._btPopupVisible   = true
            barRoot._wifiPopupVisible = false
            barRoot._calendarVisible  = false
            barRoot._popupVisible     = false
        }
    }
    onEntered: if (barRoot && barRoot.horizontal && !barRoot._btPopupVisible)
        barRoot.showPopup(root, "BLUETOOTH",
            NetworkServices.Bluetooth.connected ? "󰂱  " + NetworkServices.Bluetooth.device
                : NetworkServices.Bluetooth.enabled ? "󰂯  On — no device" : "󰂲  Off",
            "", "Click to manage Bluetooth")
    onExited: if (barRoot) barRoot.hidePopup(root)
}
