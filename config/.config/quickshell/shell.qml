import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import QtQuick
import "Commons" as Commons
import "Services/Media" as MediaServices
import "Services/Hardware" as HardwareServices
import "Services/Networking" as NetworkServices
import "Services/Compositor" as CompositorServices
import "Services/System" as SystemServices
import "Modules/Bar"
import "Modules/OSD"
import "Modules/ControlCenter"
import "Modules/NotificationCenter"

ShellRoot {
    id: shell

    // ── Singleton instantiation ────────────────────────────────────────────────
    property var _audio:         MediaServices.Audio
    property var _battery:       HardwareServices.Battery
    property var _network:       NetworkServices.Network
    property var _bt:            NetworkServices.Bluetooth
    property var _mango:         CompositorServices.MangoWC
    property var _brightness:    HardwareServices.Brightness
    property var _mpris:         MediaServices.MprisService
    property var _notifications: SystemServices.Notifications

    IpcHandler {
        target: "main"
        function toggle() { Commons.State.controlCenterVisible = !Commons.State.controlCenterVisible }
        function open()   { Commons.State.controlCenterVisible = true  }
        function close()  { Commons.State.controlCenterVisible = false }
    }

    IpcHandler {
        target: "notifications"
        function toggle() { Commons.State.notificationCenterVisible = !Commons.State.notificationCenterVisible }
        function open()   { Commons.State.notificationCenterVisible = true  }
        function close()  { Commons.State.notificationCenterVisible = false }
    }

    // ── Mutual exclusion: CC and NC close each other; NC resets unread ─────────
    Connections {
        target: Commons.State
        function onNotificationCenterVisibleChanged() {
            if (Commons.State.notificationCenterVisible) {
                Commons.State.controlCenterVisible = false
                SystemServices.Notifications.unreadCount = 0
            }
        }
        function onControlCenterVisibleChanged() {
            if (Commons.State.controlCenterVisible)
                Commons.State.notificationCenterVisible = false
        }
    }

    // ── Toast queue ────────────────────────────────────────────────────────────
    property var _toastQueue: []

    Connections {
        target: SystemServices.Notifications
        function onArrived(notification) {
            if (!SystemServices.Notifications.dndEnabled)
                shell._toastQueue = shell._toastQueue.concat([notification])
        }
    }

    // ── OSD — one per screen, IPC triggers on primary screen ─────────────────
    Variants {
        id: osdVariants
        model: Quickshell.screens
        delegate: Osd {
            required property var modelData
            screen: modelData
        }
    }

    function _osdShow(type) {
        var items = osdVariants.instances
        for (var i = 0; i < items.length; i++)
            items[i].show(type)
    }

    IpcHandler {
        target: "osd"
        function volume()     { shell._osdShow("volume") }
        function brightness() { shell._osdShow("brightness") }
    }

    // ── Bar — one instance per screen ──────────────────────────────────────────
    Variants {
        model: Quickshell.screens
        delegate: Bar {}
    }

    // ── Toast layer ───────────────────────────────────────────────────────────
    PanelWindow {
        id: toastWindow
        visible: shell._toastQueue.length > 0
        exclusionMode: ExclusionMode.Ignore
        WlrLayershell.layer: WlrLayer.Overlay
        WlrLayershell.namespace: "quickshell:toasts"
        WlrLayershell.keyboardFocus: WlrKeyboardFocus.None

        anchors { top: true; right: true }
        implicitWidth:  316 + 16
        implicitHeight: toastStack.implicitHeight
                      + Commons.Appearance.bar.marginTop
                      + Commons.Appearance.bar.height
                      + 16
        color: "transparent"

        Column {
            id: toastStack
            anchors.right:      parent.right
            anchors.rightMargin: 8
            anchors.top:        parent.top
            anchors.topMargin:  Commons.Appearance.bar.marginTop + Commons.Appearance.bar.height + 8
            width: 316
            spacing: 8

            Repeater {
                model: shell._toastQueue
                delegate: Item {
                    required property int index
                    required property var modelData
                    width: 316
                    height: _toast.height

                    NotifToast {
                        id: _toast
                        width: 316
                        notification: parent.modelData
                        onDismissClicked: {
                            var q = shell._toastQueue.slice()
                            q.splice(parent.index, 1)
                            shell._toastQueue = q
                        }
                        onTimedOut: {
                            var q = shell._toastQueue.slice()
                            q.splice(parent.index, 1)
                            shell._toastQueue = q
                        }
                    }
                }
            }
        }
    }

    // ── Notification Center window ─────────────────────────────────────────────
    PanelWindow {
        id: ncWindow
        visible: Commons.State.notificationCenterVisible
        exclusionMode: ExclusionMode.Ignore
        WlrLayershell.layer: WlrLayer.Overlay
        WlrLayershell.namespace: "quickshell:notification-center"
        WlrLayershell.keyboardFocus: Commons.State.notificationCenterVisible
            ? WlrKeyboardFocus.Exclusive
            : WlrKeyboardFocus.None

        anchors { top: true; bottom: true; left: true; right: true }
        color: "transparent"

        Item {
            anchors.fill: parent
            focus: Commons.State.notificationCenterVisible
            Keys.onEscapePressed: Commons.State.notificationCenterVisible = false
            Keys.priority: Keys.BeforeItem
        }

        Item {
            anchors.fill: parent
            z: 0
            enabled: Commons.State.notificationCenterVisible

            TapHandler {
                onTapped: point => {
                    var panelRight  = ncWindow.width - 8
                    var panelLeft   = panelRight - 320
                    var panelTop    = 50
                    var panelBottom = panelTop + notifCenter.panelHeight
                    var x = point.position.x
                    var y = point.position.y
                    if (x < panelLeft || x > panelRight || y < panelTop || y > panelBottom)
                        Commons.State.notificationCenterVisible = false
                }
            }
        }

        NotificationCenter {
            id: notifCenter
            anchors.fill: parent
            z: 1
        }
    }

    // ── Control Center window ──────────────────────────────────────────────────
    PanelWindow {
        id: ccWindow
        visible: Commons.State.controlCenterVisible
        exclusionMode: ExclusionMode.Ignore
        WlrLayershell.layer: WlrLayer.Overlay
        WlrLayershell.namespace: "quickshell:control-center"
        WlrLayershell.keyboardFocus: Commons.State.controlCenterVisible
            ? WlrKeyboardFocus.Exclusive
            : WlrKeyboardFocus.None

        anchors { top: true; bottom: true; left: true; right: true }
        color: "transparent"

        // Keyboard dismiss
        Item {
            id: escCatcher
            anchors.fill: parent
            focus: Commons.State.controlCenterVisible
            Keys.onEscapePressed: Commons.State.controlCenterVisible = false
            Keys.priority: Keys.BeforeItem
        }

        // Click-outside-to-close — only active when CC is open
        Item {
            anchors.fill: parent
            z: 0
            enabled: Commons.State.controlCenterVisible

            TapHandler {
                onTapped: point => {
                    var panelRight  = ccWindow.width - 8
                    var panelLeft   = panelRight - 320
                    var panelTop    = 50
                    var panelBottom = panelTop + controlCenter.panelHeight
                    var x = point.position.x
                    var y = point.position.y
                    if (x < panelLeft || x > panelRight || y < panelTop || y > panelBottom)
                        Commons.State.controlCenterVisible = false
                }
            }
        }

        ControlCenter {
            id: controlCenter
            anchors.fill: parent
            z: 1
        }
    }
}
