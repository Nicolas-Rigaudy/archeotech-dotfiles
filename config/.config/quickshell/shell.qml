import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import QtQuick
import "controls"

ShellRoot {
    // Global visibility state — toggled via: qs msg -i main toggle
    property bool controlCenterVisible: false

    IpcHandler {
        target: "main"

        function toggle() {
            controlCenterVisible = !controlCenterVisible
        }

        function open() {
            controlCenterVisible = true
        }

        function close() {
            controlCenterVisible = false
        }
    }

    PanelWindow {
        id: ccWindow
        visible: controlCenterVisible
        exclusionMode: ExclusionMode.Ignore

        // Covers the full screen so we can anchor content top-right
        // and catch outside clicks to dismiss
        WlrLayershell.layer: WlrLayer.Overlay
        WlrLayershell.keyboardFocus: controlCenterVisible ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None

        anchors {
            top: true
            bottom: true
            left: true
            right: true
        }

        color: "transparent"

        // Focused item to capture key events
        Item {
            anchors.fill: parent
            focus: true
            Keys.onEscapePressed: controlCenterVisible = false
        }

        // Click outside panel to dismiss
        MouseArea {
            anchors.fill: parent
            z: 0
            onClicked: mouse => {
                var panelRight = parent.width - 8
                var panelLeft = panelRight - 320
                var panelTop = 50
                var panelBottom = panelTop + controlCenter.panelHeight
                if (mouse.x < panelLeft || mouse.x > panelRight ||
                    mouse.y < panelTop  || mouse.y > panelBottom) {
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
