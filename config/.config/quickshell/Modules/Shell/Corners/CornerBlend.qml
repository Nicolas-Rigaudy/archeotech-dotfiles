import QtQuick
import QtQuick.Shapes
import "../../../Commons" as Commons
import "../../../Services/Shell" as ShellServices

// Sprint 17 Stage 3 — "goth corner" blend between two adjacent sides.
// Fills a (vSize × hSize) rectangle in the screen corner and carves a concave
// quarter-arc on the inner edge facing the content area, so the bar/strip
// junction reads as one continuous frame.
//
// Anchored by the parent (ShellSurface) — this Item just owns the shape.
// `hSize` = thickness of the adjacent horizontal side (bar height or top/bot strip).
// `vSize` = thickness of the adjacent vertical side (left/right strip).
// The arc radius is `ShellConfig.cornerRadius()`, clamped to min(hSize, vSize).
Item {
    id: blend

    required property string corner   // "top-left" | "top-right" | "bottom-left" | "bottom-right"
    required property int    hSize
    required property int    vSize

    readonly property int _r: Math.min(ShellServices.ShellConfig.cornerRadius(), Math.min(hSize, vSize))

    implicitWidth:  vSize
    implicitHeight: hSize

    // top-right corner of the screen → inner corner of the piece is bottom-left.
    // Arc from (r, h) on the bottom edge to (0, h-r) on the left edge, CCW.
    Shape {
        visible: blend.corner === "top-right"
        anchors.fill: parent
        layer.enabled: true
        layer.samples: 4
        ShapePath {
            fillColor: Commons.Appearance.colors.glassBgLight
            strokeWidth: 0
            strokeColor: "transparent"
            startX: 0; startY: 0
            PathLine { x: blend.vSize;        y: 0 }
            PathLine { x: blend.vSize;        y: blend.hSize }
            PathLine { x: blend._r;           y: blend.hSize }
            PathArc  { x: 0; y: blend.hSize - blend._r
                       radiusX: blend._r; radiusY: blend._r
                       direction: PathArc.Counterclockwise }
            PathLine { x: 0; y: 0 }
        }
    }

    // top-left corner of the screen → inner corner of the piece is bottom-right.
    // Arc from (w, h-r) on the right edge to (w-r, h) on the bottom edge, CCW.
    Shape {
        visible: blend.corner === "top-left"
        anchors.fill: parent
        layer.enabled: true
        layer.samples: 4
        ShapePath {
            fillColor: Commons.Appearance.colors.glassBgLight
            strokeWidth: 0
            strokeColor: "transparent"
            startX: 0; startY: 0
            PathLine { x: blend.vSize;              y: 0 }
            PathLine { x: blend.vSize;              y: blend.hSize - blend._r }
            PathArc  { x: blend.vSize - blend._r;   y: blend.hSize
                       radiusX: blend._r; radiusY: blend._r
                       direction: PathArc.Counterclockwise }
            PathLine { x: 0; y: blend.hSize }
            PathLine { x: 0; y: 0 }
        }
    }

    // bottom-left corner of the screen → inner corner of the piece is top-right.
    // Arc from (w-r, 0) on the top edge to (w, r) on the right edge, CCW.
    Shape {
        visible: blend.corner === "bottom-left"
        anchors.fill: parent
        layer.enabled: true
        layer.samples: 4
        ShapePath {
            fillColor: Commons.Appearance.colors.glassBgLight
            strokeWidth: 0
            strokeColor: "transparent"
            startX: 0; startY: 0
            PathLine { x: blend.vSize - blend._r;   y: 0 }
            PathArc  { x: blend.vSize; y: blend._r
                       radiusX: blend._r; radiusY: blend._r
                       direction: PathArc.Counterclockwise }
            PathLine { x: blend.vSize; y: blend.hSize }
            PathLine { x: 0;           y: blend.hSize }
            PathLine { x: 0;           y: 0 }
        }
    }

    // bottom-right corner of the screen → inner corner of the piece is top-left.
    // Arc from (0, r) on the left edge to (r, 0) on the top edge, CCW.
    Shape {
        visible: blend.corner === "bottom-right"
        anchors.fill: parent
        layer.enabled: true
        layer.samples: 4
        ShapePath {
            fillColor: Commons.Appearance.colors.glassBgLight
            strokeWidth: 0
            strokeColor: "transparent"
            startX: 0; startY: blend._r
            PathArc  { x: blend._r; y: 0
                       radiusX: blend._r; radiusY: blend._r
                       direction: PathArc.Counterclockwise }
            PathLine { x: blend.vSize; y: 0 }
            PathLine { x: blend.vSize; y: blend.hSize }
            PathLine { x: 0;           y: blend.hSize }
            PathLine { x: 0;           y: blend._r }
        }
    }
}
