pragma Singleton
import QtQuick
import Quickshell.Services.Notifications

Item {
    id: root

    property bool dndEnabled:  false
    property int  unreadCount: 0
    property int  count:       0

    signal arrived(var notification)

    NotificationServer {
        id: server
        keepOnReload: true
        actionsSupported: false

        onNotification: notif => {
            root.count++
            root.unreadCount++
            root.arrived(notif)
        }
    }

    // C++ QAbstractListModel — Repeater connects to its row signals directly,
    // no JS-array full-reset on every addition.
    readonly property var liveModel: server.notifications

    function clearAll() {
        var list = server.notifications
        for (var i = list.length - 1; i >= 0; i--) list[i].dismiss()
        count = 0
        unreadCount = 0
    }

    function dismiss(notif) {
        notif.dismiss()
        count = Math.max(0, count - 1)
        if (unreadCount > 0) unreadCount--
    }
}
