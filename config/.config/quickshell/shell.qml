import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import QtQuick
import "." as Root
import "services" as Services
import "controls"
import "bar"

ShellRoot {
    id: shell

    // ── Singleton instantiation ────────────────────────────────────────────────
    property var _audio:   Services.Audio
    property var _battery: Services.Battery
    property var _network: Services.Network
    property var _bt:      Services.Bluetooth
    property var _mango:   Services.MangoWC

    // ── Global state ───────────────────────────────────────────────────────────
    property bool controlCenterVisible: false

    IpcHandler {
        target: "main"
        function toggle() { controlCenterVisible = !controlCenterVisible }
        function open()   { controlCenterVisible = true  }
        function close()  { controlCenterVisible = false }
    }

    // ── Bar — one instance per screen ──────────────────────────────────────────
    Variants {
        model: Quickshell.screens
        delegate: Bar {}
    }

    // ── Control Center window ──────────────────────────────────────────────────
    PanelWindow {
        id: ccWindow
        visible: controlCenterVisible
        exclusionMode: ExclusionMode.Ignore
        WlrLayershell.layer: WlrLayer.Overlay
        WlrLayershell.keyboardFocus: controlCenterVisible
            ? WlrKeyboardFocus.Exclusive
            : WlrKeyboardFocus.None

        anchors { top: true; bottom: true; left: true; right: true }
        color: "transparent"

        Item {
            anchors.fill: parent
            focus: true
            Keys.onEscapePressed: controlCenterVisible = false
        }

        MouseArea {
            anchors.fill: parent
            z: 0
            onClicked: mouse => {
                var panelRight  = parent.width - 8
                var panelLeft   = panelRight - 320
                var panelTop    = 50
                var panelBottom = panelTop + controlCenter.panelHeight
                if (mouse.x < panelLeft || mouse.x > panelRight ||
                    mouse.y < panelTop  || mouse.y > panelBottom)
                    controlCenterVisible = false
            }
        }

        ControlCenter {
            id: controlCenter
            anchors.fill: parent
            z: 1
        }
    }
}
