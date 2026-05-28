import Quickshell
import Quickshell.Wayland
import QtQuick
import "Sides" as Sides
import "Corners" as Corners
import "../../Services/Shell" as ShellServices

// Sprint 17 Stage 4 — one full-screen overlay PanelWindow per monitor.
// Hosts the 4 sides (Bar/Strip/none via SideLoader) + 4 CornerBlends, all as
// siblings in a single coordinate space so corner geometry stays in sync.
//
// Input passthrough = QsWindow.mask covering only the side/corner regions
// (the only reliable API — see ANALYSIS.md §15). Keyboard focus is Exclusive
// when a panel is open on this screen, None otherwise.
//
// Compositor exclusiveZone is reserved by separate thin ShellExclusions
// windows — this surface is ExclusionMode.Ignore.
Variants {
    model: Quickshell.screens

    delegate: PanelWindow {
        id: _surface
        required property var modelData

        readonly property string _screenName: modelData ? modelData.name : ""

        screen: modelData
        color: "transparent"
        exclusionMode: ExclusionMode.Ignore
        WlrLayershell.layer: WlrLayer.Overlay
        WlrLayershell.namespace: "archeotech-shell"
        WlrLayershell.keyboardFocus: ShellServices.ShellState.anyOpen(_screenName)
            ? WlrKeyboardFocus.Exclusive
            : WlrKeyboardFocus.None
        anchors { top: true; bottom: true; left: true; right: true }

        // Mask = union of the 4 side regions + 4 corner blends. Inactive sides
        // collapse to 0×0 (Loader without sourceComponent) so they contribute
        // nothing to the mask.
        mask: Region {
            Region { item: _topSide }
            Region { item: _bottomSide }
            Region { item: _rightSide }
            Region { item: _leftSide }
            Region { item: _cTL }
            Region { item: _cTR }
            Region { item: _cBL }
            Region { item: _cBR }
        }

        // Static collapsed sizes — drive corner-gap margins. The live
        // SideLoader widths can grow during strip hover, but the gap for
        // corner pieces stays at the collapsed size so the corner geometry
        // doesn't reflow and the bar pill doesn't shift.
        readonly property int _topGap:    _sideGap("top")
        readonly property int _bottomGap: _sideGap("bottom")
        readonly property int _leftGap:   _sideGap("left")
        readonly property int _rightGap:  _sideGap("right")

        function _sideGap(name) {
            var type = ShellServices.ShellConfig.sideType(name, _screenName)
            if (type === "none") return 0
            return ShellServices.ShellConfig.sideSize(name, _screenName)
        }

        // ── Sides ─────────────────────────────────────────────────────────────
        // Horizontal sides own the corners visually (they span beyond the strip
        // edges with leftMargin/rightMargin = strip collapsed size, leaving a
        // gap that CornerBlend fills).
        Sides.SideLoader {
            id: _topSide
            side: "top"
            screen: _surface.modelData
            anchors {
                top:   parent.top
                left:  parent.left
                right: parent.right
                leftMargin:  _surface._leftGap
                rightMargin: _surface._rightGap
            }
        }

        Sides.SideLoader {
            id: _bottomSide
            side: "bottom"
            screen: _surface.modelData
            anchors {
                bottom: parent.bottom
                left:   parent.left
                right:  parent.right
                leftMargin:  _surface._leftGap
                rightMargin: _surface._rightGap
            }
        }

        Sides.SideLoader {
            id: _rightSide
            side: "right"
            screen: _surface.modelData
            anchors {
                top:    parent.top
                bottom: parent.bottom
                right:  parent.right
                topMargin:    _surface._topGap
                bottomMargin: _surface._bottomGap
            }
        }

        Sides.SideLoader {
            id: _leftSide
            side: "left"
            screen: _surface.modelData
            anchors {
                top:    parent.top
                bottom: parent.bottom
                left:   parent.left
                topMargin:    _surface._topGap
                bottomMargin: _surface._bottomGap
            }
        }

        // ── Corner blends ─────────────────────────────────────────────────────
        // Render only when both adjacent sides are active. Sized by the
        // collapsed gaps so the geometry stays stable during strip hover.
        Corners.CornerBlend {
            id: _cTL
            corner: "top-left"
            hSize: _surface._topGap
            vSize: _surface._leftGap
            visible: _surface._topGap > 0 && _surface._leftGap > 0
            anchors { top: parent.top; left: parent.left }
        }
        Corners.CornerBlend {
            id: _cTR
            corner: "top-right"
            hSize: _surface._topGap
            vSize: _surface._rightGap
            visible: _surface._topGap > 0 && _surface._rightGap > 0
            anchors { top: parent.top; right: parent.right }
        }
        Corners.CornerBlend {
            id: _cBL
            corner: "bottom-left"
            hSize: _surface._bottomGap
            vSize: _surface._leftGap
            visible: _surface._bottomGap > 0 && _surface._leftGap > 0
            anchors { bottom: parent.bottom; left: parent.left }
        }
        Corners.CornerBlend {
            id: _cBR
            corner: "bottom-right"
            hSize: _surface._bottomGap
            vSize: _surface._rightGap
            visible: _surface._bottomGap > 0 && _surface._rightGap > 0
            anchors { bottom: parent.bottom; right: parent.right }
        }
    }
}
