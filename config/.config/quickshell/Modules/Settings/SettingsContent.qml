import QtQuick
import "./Panes"
import "../../Commons" as Commons

Item {
    id: root
    property int activeIndex: 0
    clip: true

    Column {
        id: carousel
        width: root.width
        y: -root.activeIndex * root.height

        Behavior on y {
            NumberAnimation { duration: Commons.Appearance.anim.base; easing.type: Easing.OutCubic }
        }

        AppearancePane    { width: root.width; height: root.height }
        BarPane           { width: root.width; height: root.height }
        NotificationsPane { width: root.width; height: root.height }
        ConnectionsPane   { width: root.width; height: root.height }
        AudioPane         { width: root.width; height: root.height }
        AboutPane         { width: root.width; height: root.height }
    }
}
