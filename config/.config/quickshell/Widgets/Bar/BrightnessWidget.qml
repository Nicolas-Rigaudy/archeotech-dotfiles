import QtQuick
import QtQuick.Layouts
import "../../Commons" as Commons
import "../../Services/Hardware" as HardwareServices

// Screen brightness indicator with scroll-to-adjust.
Item {
    id: root
    required property var barRoot
    property string widgetId

    visible: barRoot && barRoot.horizontal
    height: Commons.Appearance.bar.height
    width: brightRow.implicitWidth + 10
    Layout.alignment: Qt.AlignVCenter

    property bool _hovered: false

    Row {
        id: brightRow
        spacing: 4
        anchors.centerIn: parent
        Text {
            id: brightIcon
            text: HardwareServices.Brightness.percent >= 75 ? "󰃠"
                : HardwareServices.Brightness.percent >= 40 ? "󰃟"
                :                                              "󰃞"
            color: Commons.Appearance.colors.yellow
            font.pixelSize: 18; font.family: Commons.Appearance.font.family
            anchors.verticalCenter: parent.verticalCenter
        }
        Text {
            text: HardwareServices.Brightness.percent + "%"
            color: Commons.Appearance.colors.overlay1
            font.pixelSize: Commons.Appearance.font.sizeSm; font.family: Commons.Appearance.font.family
            anchors.verticalCenter: parent.verticalCenter
        }
    }
    MouseArea {
        anchors.fill: parent; hoverEnabled: true
        onEntered: {
            root._hovered = true
            brightIcon.color = Commons.Appearance.colors.accent
            if (root.barRoot) root.barRoot.showPopup(root, "BRIGHTNESS",
                "󰃠  " + HardwareServices.Brightness.percent + "%",
                "", "Scroll to adjust")
        }
        onExited: {
            root._hovered = false
            brightIcon.color = Commons.Appearance.colors.yellow
            if (root.barRoot) root.barRoot.hidePopup(root)
        }
        onWheel: wheel => {
            var delta = wheel.angleDelta.y > 0 ? 5 : -5
            HardwareServices.Brightness.adjust(delta)
        }
    }
    Connections {
        target: HardwareServices.Brightness
        function onPercentChanged() {
            if (root._hovered && root.barRoot && root.barRoot._popupVisible)
                root.barRoot._popupPrimary = "󰃠  " + HardwareServices.Brightness.percent + "%"
        }
    }
}
