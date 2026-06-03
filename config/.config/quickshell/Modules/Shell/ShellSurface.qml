import Quickshell
import Quickshell.Wayland
import QtQuick
import "Sides" as Sides
import "Corners" as Corners
import "Panels" as Panels
import "Builder" as Builder
import "../../Commons" as Commons
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
        // Exclusive focus when a panel is open OR edit mode is active (so the
        // EditOverlay receives Escape and the palette is interactive).
        WlrLayershell.keyboardFocus: (ShellServices.ShellState.anyOpen(_screenName) || Commons.State.editMode)
            ? WlrKeyboardFocus.Exclusive
            : WlrKeyboardFocus.None
        anchors { top: true; bottom: true; left: true; right: true }

        // Mask = union of the 4 side regions + 4 corner blends + (when any
        // panel is open) a full-surface region for click-outside-to-close +
        // (in edit mode) a full-surface region so the editor is interactive.
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
            Region { item: _editMask }
        }

        // Full-surface mask while editing so all of EditOverlay is clickable;
        // collapses to 0×0 otherwise.
        Item {
            id: _editMask
            x: 0; y: 0
            width:  Commons.State.editMode ? _surface.width  : 0
            height: Commons.State.editMode ? _surface.height : 0
        }

        // When any panel is open on this screen, _panelOpenMask covers the
        // whole surface so a click outside the strip/panel area can close it.
        // When no panel is open, it collapses to 0×0 and contributes nothing.
        Item {
            id: _panelOpenMask
            x: 0; y: 0
            width:  ShellServices.ShellState.anyOpen(_surface._screenName) ? _surface.width  : 0
            height: ShellServices.ShellState.anyOpen(_surface._screenName) ? _surface.height : 0

            // Click outside any side strip → close the active panel.
            TapHandler {
                enabled: ShellServices.ShellState.anyOpen(_surface._screenName)
                onTapped: point => {
                    function inside(s) {
                        return point.position.x >= s.x && point.position.x < s.x + s.width
                            && point.position.y >= s.y && point.position.y < s.y + s.height
                    }
                    if (!inside(_topSide) && !inside(_bottomSide)
                        && !inside(_leftSide) && !inside(_rightSide)) {
                        ShellServices.ShellState.close(_surface._screenName)
                    }
                }
            }
        }

        // Static collapsed sizes — drive corner-gap margins. The live
        // SideLoader widths can grow during strip hover, but the gap for
        // corner pieces stays at the collapsed size so the corner geometry
        // doesn't reflow and the bar pill doesn't shift.
        readonly property int _topGap:    ShellServices.ShellConfig.sideGap("top",    _screenName)
        readonly property int _bottomGap: ShellServices.ShellConfig.sideGap("bottom", _screenName)
        readonly property int _leftGap:   ShellServices.ShellConfig.sideGap("left",   _screenName)
        readonly property int _rightGap:  ShellServices.ShellConfig.sideGap("right",  _screenName)

        // Extended corner geometry — each corner piece extends `_r` pixels into
        // the adjacent bar/strip areas so a single concave arc (radius _r) can
        // span from the bar's edge to the strip's edge with smooth tangents.
        readonly property int _r: ShellServices.ShellConfig.cornerRadius()

        // ── Sides ─────────────────────────────────────────────────────────────
        // Horizontal sides own the corners visually (they span beyond the strip
        // edges with leftMargin/rightMargin = strip collapsed size, leaving a
        // gap that CornerBlend fills).
        // z: 10 — above panels (z:5) so strips stay visible and interactive when a panel is open.
        Sides.SideLoader {
            id: _topSide
            z: 10
            side: "top"
            screen: _surface.modelData
            anchors {
                top:   parent.top
                left:  parent.left
                right: parent.right
                leftMargin:  _surface._leftGap  + _surface._r
                rightMargin: _surface._rightGap + _surface._r
            }
        }

        Sides.SideLoader {
            id: _bottomSide
            z: 10
            side: "bottom"
            screen: _surface.modelData
            anchors {
                bottom: parent.bottom
                left:   parent.left
                right:  parent.right
                leftMargin:  _surface._leftGap  + _surface._r
                rightMargin: _surface._rightGap + _surface._r
            }
        }

        Sides.SideLoader {
            id: _rightSide
            z: 10
            side: "right"
            screen: _surface.modelData
            anchors {
                top:    parent.top
                bottom: parent.bottom
                right:  parent.right
                topMargin:    _surface._topGap    + _surface._r
                bottomMargin: _surface._bottomGap + _surface._r
            }
        }

        Sides.SideLoader {
            id: _leftSide
            z: 10
            side: "left"
            screen: _surface.modelData
            anchors {
                top:    parent.top
                bottom: parent.bottom
                left:   parent.left
                topMargin:    _surface._topGap    + _surface._r
                bottomMargin: _surface._bottomGap + _surface._r
            }
        }

        // ── Corner blends ─────────────────────────────────────────────────────
        // Render only when both adjacent sides are active. Sized by the
        // collapsed gaps so the geometry stays stable during strip hover.
        Corners.CornerBlend {
            id: _cTL
            corner: "top-left"
            hSize: _surface._topGap    + _surface._r
            vSize: _surface._leftGap   + _surface._r
            visible: _surface._topGap > 0 && _surface._leftGap > 0
            anchors { top: parent.top; left: parent.left }
        }
        Corners.CornerBlend {
            id: _cTR
            corner: "top-right"
            hSize: _surface._topGap    + _surface._r
            vSize: _surface._rightGap  + _surface._r
            visible: _surface._topGap > 0 && _surface._rightGap > 0
            anchors { top: parent.top; right: parent.right }
        }
        Corners.CornerBlend {
            id: _cBL
            corner: "bottom-left"
            hSize: _surface._bottomGap + _surface._r
            vSize: _surface._leftGap   + _surface._r
            visible: _surface._bottomGap > 0 && _surface._leftGap > 0
            anchors { bottom: parent.bottom; left: parent.left }
        }
        Corners.CornerBlend {
            id: _cBR
            corner: "bottom-right"
            hSize: _surface._bottomGap + _surface._r
            vSize: _surface._rightGap  + _surface._r
            visible: _surface._bottomGap > 0 && _surface._rightGap > 0
            anchors { bottom: parent.bottom; right: parent.right }
        }

        // ── Panels ────────────────────────────────────────────────────────────
        // Sprint 17 → S5 update: panels are now rendered INSIDE the Strip
        // popup card (Sides/Strip.qml). The strip's card grows from popup-size
        // to panel-size on activation, with the icons staying as a sidebar at
        // the strip-attached edge so the user can switch between panels (e.g.
        // CC ↔ NC) without losing them. Panels.Panel is no longer instantiated
        // here; PanelRegistry remains the source of truth for content + size.

        // ── Edit mode (Sprint 21) ──────────────────────────────────────────────
        // Full-surface visual builder, above everything. Visible only when
        // State.editMode; reads/writes ShellConfig (live shell hot-reloads).
        Builder.EditOverlay {
            z: 30
            anchors.fill: parent
        }
    }
}
