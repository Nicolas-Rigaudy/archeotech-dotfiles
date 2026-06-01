import QtQuick
import QtQuick.Layouts
import "../../Commons" as Commons
import "../../Services/Shell" as ShellServices
import "../../Services/System" as SystemServices

// Notification bell + unread count badge. Click toggles the NC panel.
Item {
    id: root
    required property var barRoot
    property string widgetId

    visible: barRoot && barRoot.horizontal
    height: Commons.Appearance.bar.height
    width: bellIcon.implicitWidth + 10
    Layout.alignment: Qt.AlignVCenter

    Text {
        id: bellIcon
        anchors.centerIn: parent
        text: "󰂚"
        color: ShellServices.ShellState.isOpenAnywhere("nc")
            ? Commons.Appearance.colors.accent
            : SystemServices.Notifications.unreadCount > 0
            ? Commons.Appearance.colors.red
            : Commons.Appearance.colors.subtext1
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
            if (!ShellServices.ShellState.isOpenAnywhere("nc"))
                SystemServices.Notifications.unreadCount = 0
            ShellServices.ShellState.toggleGlobal("nc")
        }
        onEntered: {
            if (!ShellServices.ShellState.isOpenAnywhere("nc")) bellIcon.color = Commons.Appearance.colors.accent
            if (root.barRoot) root.barRoot.showPopup(root, "NOTIFICATIONS",
                SystemServices.Notifications.unreadCount > 0
                    ? "󰂚  " + SystemServices.Notifications.unreadCount + " unread"
                    : "󰂜  All caught up",
                SystemServices.Notifications.dndEnabled ? "󰂛  Do not disturb on" : "",
                "Click to toggle")
        }
        onExited: {
            if (!ShellServices.ShellState.isOpenAnywhere("nc"))
                bellIcon.color = SystemServices.Notifications.unreadCount > 0
                    ? Commons.Appearance.colors.red : Commons.Appearance.colors.subtext1
            if (root.barRoot) root.barRoot.hidePopup(root)
        }
    }
}
