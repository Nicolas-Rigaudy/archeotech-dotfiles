import Quickshell
import Quickshell.Wayland
import QtQuick
import "../../Services/Shell" as ShellServices

// Sprint 17 Stage 4 — thin transparent PanelWindows that reserve compositor
// exclusiveZone on each side. The full-screen ShellSurface can't claim
// exclusiveZone (it's ExclusionMode.Ignore), so these slim windows do the job.
//
// Each side spawns one PanelWindow per screen, conditional on
// `sides.<name>.type !== "none"`. `exclusiveZone = sideSize + outerGap`:
// the visible bar/strip is `sideSize` wide, the extra `outerGap` is empty
// space between the side and tiled windows — owned by Quickshell instead of
// MangoWC's `gappoh/gappov` (which would multiply between tiled windows too).
Variants {
    model: Quickshell.screens

    delegate: Scope {
        id: _row
        required property var modelData
        readonly property string _name: modelData ? modelData.name : ""

        // "holder" reserves no compositor space (hidden at rest, floats over
        // tiled windows on reveal) — so only bar/strip claim an exclusiveZone.
        function _active(side) {
            var t = ShellServices.ShellConfig.sideType(side, _name)
            return t !== "none" && t !== "holder"
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
            exclusiveZone: _row._size("top") + ShellServices.ShellConfig.outerGap()
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
            exclusiveZone: _row._size("bottom") + ShellServices.ShellConfig.outerGap()
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
            exclusiveZone: _row._size("right") + ShellServices.ShellConfig.outerGap()
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
            exclusiveZone: _row._size("left") + ShellServices.ShellConfig.outerGap()
            anchors { top: true; bottom: true; left: true }
            implicitWidth: _row._size("left")
            mask: Region { x: 0; y: 0; width: 0; height: 0 }
        }
    }
}
