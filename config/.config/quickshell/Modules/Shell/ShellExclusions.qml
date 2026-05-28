import Quickshell
import Quickshell.Wayland
import QtQuick
import "../../Services/Shell" as ShellServices

// Sprint 17 Stage 4 — thin transparent PanelWindows that reserve compositor
// exclusiveZone on each side. The full-screen ShellSurface can't claim
// exclusiveZone (it's ExclusionMode.Ignore), so these slim windows do the job.
//
// Each side spawns one PanelWindow per screen, conditional on
// `sides.<name>.type !== "none"`. `exclusiveZone` = collapsed side size, so
// apps fit around the bar/strip's resting width even when a strip hovers
// larger (the expansion overlays apps but isn't reserved).
Variants {
    model: Quickshell.screens

    delegate: Scope {
        id: _row
        required property var modelData
        readonly property string _name: modelData ? modelData.name : ""

        function _active(side) {
            return ShellServices.ShellConfig.sideType(side, _name) !== "none"
        }
        function _size(side) {
            return ShellServices.ShellConfig.sideSize(side, _name)
        }

        // Top
        PanelWindow {
            visible: _row._active("top")
            screen: _row.modelData
            color: "transparent"
            WlrLayershell.layer: WlrLayer.Top
            WlrLayershell.namespace: "archeotech-exclude-top"
            WlrLayershell.keyboardFocus: WlrKeyboardFocus.None
            exclusionMode: ExclusionMode.Normal
            exclusiveZone: _row._size("top")
            anchors { top: true; left: true; right: true }
            implicitHeight: _row._size("top")
            mask: Region { x: 0; y: 0; width: 0; height: 0 }
        }

        // Bottom
        PanelWindow {
            visible: _row._active("bottom")
            screen: _row.modelData
            color: "transparent"
            WlrLayershell.layer: WlrLayer.Top
            WlrLayershell.namespace: "archeotech-exclude-bottom"
            WlrLayershell.keyboardFocus: WlrKeyboardFocus.None
            exclusionMode: ExclusionMode.Normal
            exclusiveZone: _row._size("bottom")
            anchors { bottom: true; left: true; right: true }
            implicitHeight: _row._size("bottom")
            mask: Region { x: 0; y: 0; width: 0; height: 0 }
        }

        // Right
        PanelWindow {
            visible: _row._active("right")
            screen: _row.modelData
            color: "transparent"
            WlrLayershell.layer: WlrLayer.Top
            WlrLayershell.namespace: "archeotech-exclude-right"
            WlrLayershell.keyboardFocus: WlrKeyboardFocus.None
            exclusionMode: ExclusionMode.Normal
            exclusiveZone: _row._size("right")
            anchors { top: true; bottom: true; right: true }
            implicitWidth: _row._size("right")
            mask: Region { x: 0; y: 0; width: 0; height: 0 }
        }

        // Left
        PanelWindow {
            visible: _row._active("left")
            screen: _row.modelData
            color: "transparent"
            WlrLayershell.layer: WlrLayer.Top
            WlrLayershell.namespace: "archeotech-exclude-left"
            WlrLayershell.keyboardFocus: WlrKeyboardFocus.None
            exclusionMode: ExclusionMode.Normal
            exclusiveZone: _row._size("left")
            anchors { top: true; bottom: true; left: true }
            implicitWidth: _row._size("left")
            mask: Region { x: 0; y: 0; width: 0; height: 0 }
        }
    }
}
