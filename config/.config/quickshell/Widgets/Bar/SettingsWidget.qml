import QtQuick
import "../../Commons" as Commons
import "../../Services/Shell" as ShellServices

// Settings gear — toggles the Settings panel. Icon-only vertical (BarPill).
BarPill {
    id: root
    icon: "󰒓"
    iconColor: Commons.Appearance.colors.subtext1

    onClicked: {
        if (barRoot) { barRoot._wifiPopupVisible = false; barRoot._btPopupVisible = false }
        ShellServices.ShellState.toggleGlobal("settings")
    }
    onEntered: if (barRoot && barRoot.horizontal) barRoot.showPopup(root, "SETTINGS", "󰒓  Settings", "", "Click to toggle")
    onExited:  if (barRoot) barRoot.hidePopup(root)
}
