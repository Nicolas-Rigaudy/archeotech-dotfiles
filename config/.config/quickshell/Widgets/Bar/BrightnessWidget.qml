import QtQuick
import "../../Commons" as Commons
import "../../Services/Hardware" as HardwareServices

// Screen brightness indicator with scroll-to-adjust. Icon+value / icon-only (BarPill).
BarPill {
    id: root
    icon: HardwareServices.Brightness.percent >= 75 ? "󰃠"
        : HardwareServices.Brightness.percent >= 40 ? "󰃟"
        :                                              "󰃞"
    iconColor:  Commons.Appearance.colors.yellow
    hoverColor: Commons.Appearance.colors.accent
    text: HardwareServices.Brightness.percent + "%"

    onWheel: d => HardwareServices.Brightness.adjust(d * 5)
    onEntered: if (barRoot && barRoot.horizontal) barRoot.showPopup(root, "BRIGHTNESS",
        "󰃠  " + HardwareServices.Brightness.percent + "%", "", "Scroll to adjust")
    onExited: if (barRoot) barRoot.hidePopup(root)

    Connections {
        target: HardwareServices.Brightness
        function onPercentChanged() {
            if (root.hovered && root.barRoot && root.barRoot._popupVisible)
                root.barRoot._popupPrimary = "󰃠  " + HardwareServices.Brightness.percent + "%"
        }
    }
}
