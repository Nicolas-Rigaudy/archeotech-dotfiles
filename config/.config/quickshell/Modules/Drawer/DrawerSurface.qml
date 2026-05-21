import Quickshell
import Quickshell.Wayland
import QtQuick
import "../ControlCenter"
import "../NotificationCenter"
import "../Launcher"
import "../Dashboard"
import "../../Commons" as Commons
import "." as Drawer

PanelWindow {
    id: root

    // Stay visible a bit after panels close so slide-out animation plays
    property bool _exitAnimating: false
    visible: Drawer.DrawerVisibilities.anyDrawerActive || _exitAnimating

    exclusionMode: ExclusionMode.Ignore
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.namespace: "archeotech-drawer"
    WlrLayershell.keyboardFocus: Drawer.DrawerVisibilities.anyDrawerActive
        ? WlrKeyboardFocus.Exclusive
        : WlrKeyboardFocus.None

    anchors { top: true; bottom: true; left: true; right: true }
    color: "transparent"

    Timer {
        id: _exitTimer
        // anim.base + a bit of slack so slide-out finishes before window hides
        interval: Commons.Appearance.anim.base + 80
        repeat: false
        onTriggered: root._exitAnimating = false
    }

    Connections {
        target: Drawer.DrawerVisibilities
        function onAnyDrawerActiveChanged() {
            if (Drawer.DrawerVisibilities.anyDrawerActive) {
                _exitTimer.stop()
                root._exitAnimating = false
            } else {
                root._exitAnimating = true
                _exitTimer.restart()
            }
        }
    }

    // ── Click-outside to dismiss ───────────────────────────────────────────────
    Item {
        anchors.fill: parent
        z: 0
        enabled: Drawer.DrawerVisibilities.anyDrawerActive

        TapHandler {
            onTapped: point => {
                var x = point.position.x
                var y = point.position.y
                var topMargin = Commons.Appearance.bar.marginTop
                               + Commons.Appearance.bar.height
                               + Commons.Appearance.spacing.base

                if (Drawer.DrawerVisibilities.ccVisible) {
                    var r = root.width - 8;  var l = r - 320
                    if (x < l || x > r || y < topMargin || y > topMargin + ccPanel.panelHeight)
                        Drawer.DrawerVisibilities.ccVisible = false
                } else if (Drawer.DrawerVisibilities.ncVisible) {
                    var r = root.width - 8;  var l = r - 320
                    if (x < l || x > r || y < topMargin || y > topMargin + ncPanel.panelHeight)
                        Drawer.DrawerVisibilities.ncVisible = false
                } else if (Drawer.DrawerVisibilities.launcherVisible) {
                    // Launcher handles its own click-outside
                }
                // Dashboard: click-outside handled inside Dashboard.qml
            }
        }
    }

    // ── Panels (z=1, mutually exclusive via DrawerVisibilities) ───────────────
    ControlCenter      { id: ccPanel;       anchors.fill: parent; z: 1 }
    NotificationCenter { id: ncPanel;       anchors.fill: parent; z: 1 }
    Launcher           { id: launcherPanel; anchors.fill: parent; z: 1 }
    Dashboard          { id: dashPanel;     anchors.fill: parent; z: 1 }
}
