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
    property var _audio:      Services.Audio
    property var _battery:    Services.Battery
    property var _network:    Services.Network
    property var _bt:         Services.Bluetooth
    property var _mango:      Services.MangoWC
    property var _brightness: Services.Brightness

    // ── Global state ───────────────────────────────────────────────────────────
    property bool controlCenterVisible: false

    IpcHandler {
        target: "main"
        function toggle() { controlCenterVisible = !controlCenterVisible }
        function open()   { controlCenterVisible = true  }
        function close()  { controlCenterVisible = false }
    }

    IpcHandler {
        target: "osd"
        function volume()     { osd.show("volume") }
        function brightness() { osd.show("brightness") }
    }

    // ── OSD ────────────────────────────────────────────────────────────────────
    Osd { id: osd }

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
        WlrLayershell.namespace: "quickshell:control-center"
        WlrLayershell.keyboardFocus: controlCenterVisible
            ? WlrKeyboardFocus.Exclusive
            : WlrKeyboardFocus.None

        anchors { top: true; bottom: true; left: true; right: true }
        color: "transparent"

        // Keyboard dismiss — active focus always returns here after interactions
        Item {
            id: escCatcher
            anchors.fill: parent
            focus: controlCenterVisible
            Keys.onEscapePressed: controlCenterVisible = false
            Keys.priority: Keys.BeforeItem
        }

        // Click-outside-to-close — TapHandler doesn't block pointer grabs,
        // so Slider drag inside ControlCenter works correctly
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
                        controlCenterVisible = false
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
