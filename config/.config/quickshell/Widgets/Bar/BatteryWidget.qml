import QtQuick
import QtQuick.Layouts
import "../../Commons" as Commons
import "../../Services/Hardware" as HardwareServices
import "../../Services/Persistence" as Persistence

// Battery percentage + charging state. Hidden when no battery present.
Item {
    id: root
    required property var barRoot
    property string widgetId

    visible: HardwareServices.Battery.present
        && Persistence.Config.get("bar.modules.battery", true)
        && barRoot && barRoot.horizontal
    height: Commons.Appearance.bar.height
    width: batRow.implicitWidth + 10
    Layout.alignment: Qt.AlignVCenter

    Row {
        id: batRow
        spacing: 4
        anchors.centerIn: parent
        Text {
            id: batIcon
            text: HardwareServices.Battery.icon()
            color: HardwareServices.Battery.percent <= 20 ? Commons.Appearance.colors.red : Commons.Appearance.colors.green
            font.pixelSize: 18; font.family: Commons.Appearance.font.family
            anchors.verticalCenter: parent.verticalCenter
        }
        Text {
            text: HardwareServices.Battery.percent + "%"
            color: HardwareServices.Battery.percent <= 20 ? Commons.Appearance.colors.red : Commons.Appearance.colors.overlay1
            font.pixelSize: Commons.Appearance.font.sizeSm; font.family: Commons.Appearance.font.family
            anchors.verticalCenter: parent.verticalCenter
        }
    }
    MouseArea {
        anchors.fill: parent; hoverEnabled: true
        onEntered: if (root.barRoot) root.barRoot.showPopup(root, "BATTERY",
            HardwareServices.Battery.icon() + "  " + HardwareServices.Battery.percent + "%",
            HardwareServices.Battery.charging ? "󰂄  Charging" : "󱉞  On battery", "")
        onExited: if (root.barRoot) root.barRoot.hidePopup(root)
    }
}
