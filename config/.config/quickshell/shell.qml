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
import "Services/Persistence" as Persistence
import "Modules/Bar"
import "Modules/OSD"
import "Modules/Settings"
import "Modules/Drawer" as Drawer
import "Modules/NotificationCenter"

ShellRoot {
    id: shell

    // ── Singleton instantiation ────────────────────────────────────────────────
    property var _audio:         MediaServices.Audio
    property var _battery:       HardwareServices.Battery
    property var _network:       NetworkServices.Network
    property var _bt:            NetworkServices.Bluetooth
    property var _vpn:           NetworkServices.VPN
    property var _mango:         CompositorServices.MangoWC
    property var _brightness:    HardwareServices.Brightness
    property var _mpris:         MediaServices.MprisService
    property var _notifications: SystemServices.Notifications
    property var _config:        Persistence.Config
    property var _persistent:    Persistence.Persistent
    property var _drawerCfg:     Drawer.DrawerConfig  // force singleton instantiation

    // ── IPC handlers ───────────────────────────────────────────────────────────

    IpcHandler {
        target: "theme"
        function reload() { Commons.Appearance.reload() }
    }

    IpcHandler {
        target: "main"
        function toggle() { Drawer.DrawerVisibilities.ccVisible = !Drawer.DrawerVisibilities.ccVisible }
        function open()   { Drawer.DrawerVisibilities.ccVisible = true  }
        function close()  { Drawer.DrawerVisibilities.ccVisible = false }
    }

    IpcHandler {
        target: "notifications"
        function toggle() {
            if (Drawer.DrawerVisibilities.ncVisible) {
                Drawer.DrawerVisibilities.ncVisible = false
            } else {
                Drawer.DrawerVisibilities.ncVisible = true
                SystemServices.Notifications.unreadCount = 0
            }
        }
        function open() {
            Drawer.DrawerVisibilities.ncVisible = true
            SystemServices.Notifications.unreadCount = 0
        }
        function close() { Drawer.DrawerVisibilities.ncVisible = false }
    }

    IpcHandler {
        target: "launcher"
        function toggle() { Drawer.DrawerVisibilities.launcherVisible = !Drawer.DrawerVisibilities.launcherVisible }
        function open()   { Drawer.DrawerVisibilities.launcherVisible = true  }
        function close()  { Drawer.DrawerVisibilities.launcherVisible = false }
    }

    IpcHandler {
        target: "settings"
        function toggle()               { Commons.State.settingsVisible = !Commons.State.settingsVisible }
        function open()                 { Commons.State.settingsVisible = true  }
        function close()                { Commons.State.settingsVisible = false }
        function openPane(pane: string) { Commons.State.settingsOpenPane = pane; Commons.State.settingsVisible = true }
    }

    IpcHandler {
        target: "dashboard"
        function toggle()   { Drawer.DrawerVisibilities.dashboardVisible = !Drawer.DrawerVisibilities.dashboardVisible }
        function open()     { Drawer.DrawerVisibilities.dashboardVisible = true  }
        function close()    { Drawer.DrawerVisibilities.dashboardVisible = false }
        function openAuto() { Commons.State.dashboardAutoOpen = true; Drawer.DrawerVisibilities.dashboardVisible = true }
    }

    // ── Mutual exclusion: drawer ↔ settings ───────────────────────────────────
    Connections {
        target: Drawer.DrawerVisibilities
        function onAnyDrawerActiveChanged() {
            if (Drawer.DrawerVisibilities.anyDrawerActive)
                Commons.State.settingsVisible = false
        }
    }

    Connections {
        target: Commons.State
        function onSettingsVisibleChanged() {
            if (Commons.State.settingsVisible)
                Drawer.DrawerVisibilities.hideAll()
        }
    }

    // ── Toast queue ────────────────────────────────────────────────────────────
    property var _toastQueue: []

    Connections {
        target: SystemServices.Notifications
        function onArrived(notification) {
            if (!SystemServices.Notifications.dndEnabled) {
                shell._toastQueue = shell._toastQueue.concat([{
                    appIcon:       notification.appIcon       || "",
                    appName:       notification.appName       || "",
                    summary:       notification.summary       || "",
                    body:          notification.body          || "",
                    urgency:       notification.urgency       || 0,
                    expireTimeout: notification.expireTimeout || -1
                }])
            }
        }
    }

    // ── OSD — one per screen ──────────────────────────────────────────────────
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

    // ── Bar — one instance per screen ─────────────────────────────────────────
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

    // ── Settings window ────────────────────────────────────────────────────────
    Settings {}

    // ── Drawer surface — CC, NC, Launcher, Dashboard ──────────────────────────
    Drawer.DrawerSurface {}

    // ── Edge hover zones — one instance per screen ───────────────────────────
    // Right edge → Control Center
    Variants {
        model: Quickshell.screens
        delegate: PanelWindow {
            required property var modelData
            screen: modelData
            exclusionMode: ExclusionMode.Ignore
            WlrLayershell.layer: WlrLayer.Top
            WlrLayershell.namespace: "archeotech-edge-right"
            WlrLayershell.keyboardFocus: WlrKeyboardFocus.None
            anchors { top: true; bottom: true; right: true }
            implicitWidth: 4
            color: "transparent"
            HoverHandler { onHoveredChanged: if (hovered) Drawer.DrawerVisibilities.ccVisible = true }
        }
    }

    // Top-right corner → Notification Center
    Variants {
        model: Quickshell.screens
        delegate: PanelWindow {
            required property var modelData
            screen: modelData
            exclusionMode: ExclusionMode.Ignore
            WlrLayershell.layer: WlrLayer.Top
            WlrLayershell.namespace: "archeotech-edge-nc"
            WlrLayershell.keyboardFocus: WlrKeyboardFocus.None
            anchors { top: true; right: true }
            implicitWidth: 160
            implicitHeight: 4
            color: "transparent"
            HoverHandler {
                onHoveredChanged: if (hovered) {
                    Drawer.DrawerVisibilities.ncVisible = true
                    SystemServices.Notifications.unreadCount = 0
                }
            }
        }
    }

    // Bottom edge → Dashboard
    Variants {
        model: Quickshell.screens
        delegate: PanelWindow {
            required property var modelData
            screen: modelData
            exclusionMode: ExclusionMode.Ignore
            WlrLayershell.layer: WlrLayer.Top
            WlrLayershell.namespace: "archeotech-edge-bottom"
            WlrLayershell.keyboardFocus: WlrKeyboardFocus.None
            anchors { bottom: true; left: true; right: true }
            implicitHeight: 4
            color: "transparent"
            HoverHandler { onHoveredChanged: if (hovered) Drawer.DrawerVisibilities.dashboardVisible = true }
        }
    }
}
