import Quickshell
import Quickshell.Wayland
import QtQuick
import "Sides" as Sides
import "Corners" as Corners
import "Panels" as Panels
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

        // Mask = union of the 4 side regions + 4 corner blends + (when any
        // panel is open) a full-surface region for click-outside-to-close.
        // Inactive sides collapse to 0×0 so they contribute nothing.
        mask: Region {
            Region { item: _topSide }
            Region { item: _bottomSide }
            Region { item: _rightSide }
            Region { item: _leftSide }
            Region { item: _cTL }
            Region { item: _cTR }
            Region { item: _cBL }
            Region { item: _cBR }
            Region { item: _panelOpenMask }
        }

        // When any panel is open on this screen, _panelOpenMask covers the
        // whole surface so the Panel's TapHandler can detect off-panel clicks.
        // When no panel is open, it collapses to 0×0 and contributes nothing.
        Item {
            id: _panelOpenMask
            x: 0; y: 0
            width:  ShellServices.ShellState.anyOpen(_surface._screenName) ? _surface.width  : 0
            height: ShellServices.ShellState.anyOpen(_surface._screenName) ? _surface.height : 0
        }

        // Static collapsed sizes — drive corner-gap margins. The live
        // SideLoader widths can grow during strip hover, but the gap for
        // corner pieces stays at the collapsed size so the corner geometry
        // doesn't reflow and the bar pill doesn't shift.
        readonly property int _topGap:    ShellServices.ShellConfig.sideGap("top",    _screenName)
        readonly property int _bottomGap: ShellServices.ShellConfig.sideGap("bottom", _screenName)
        readonly property int _leftGap:   ShellServices.ShellConfig.sideGap("left",   _screenName)
        readonly property int _rightGap:  ShellServices.ShellConfig.sideGap("right",  _screenName)

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

        // ── Panels ────────────────────────────────────────────────────────────
        // One Panel per registered ID; each renders its content from
        // PanelRegistry inside the uniform glass chrome. z-order puts panels
        // above sides+corners so they cover them when open (the strip
        // visually merges with the panel's flush edge).
        Repeater {
            model: ShellServices.PanelRegistry.panelIds
            delegate: Panels.Panel {
                required property string modelData
                panelId: modelData
                screen: _surface.modelData
                z: 5
            }
        }
    }
}
