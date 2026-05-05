import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import QtQuick
import "Commons" as Commons
import "Services/Media" as MediaServices
import "Services/Hardware" as HardwareServices
import "Services/Networking" as NetworkServices
import "Services/Compositor" as CompositorServices
import "Modules/Bar"
import "Modules/OSD"
import "Modules/ControlCenter"

ShellRoot {
    id: shell

    // ── Singleton instantiation ────────────────────────────────────────────────
    property var _audio:      MediaServices.Audio
    property var _battery:    HardwareServices.Battery
    property var _network:    NetworkServices.Network
    property var _bt:         NetworkServices.Bluetooth
    property var _mango:      CompositorServices.MangoWC
    property var _brightness: HardwareServices.Brightness

    IpcHandler {
        target: "main"
        function toggle() { Commons.State.controlCenterVisible = !Commons.State.controlCenterVisible }
        function open()   { Commons.State.controlCenterVisible = true  }
        function close()  { Commons.State.controlCenterVisible = false }
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

        // Click-outside-to-close using State.controlCenterVisible
        Item {
            anchors.fill: parent
            z: 0

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
