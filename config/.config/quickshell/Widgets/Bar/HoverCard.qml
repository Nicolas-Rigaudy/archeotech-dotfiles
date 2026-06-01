import QtQuick
import QtQuick.Shapes
import "../../Commons" as Commons

// Hover info popup. Top edge wider than body; CCW arcs curve inward to body
// width; rounded bottom corners. Position + content driven by barRoot state
// (set by widgets via barRoot.showPopup).
Shape {
    id: card
    required property var barRoot

    property real _r:  Commons.Appearance.radius.xl
    property real _rb: Commons.Appearance.radius.md
    property real _bw: _popupCol.implicitWidth + 28

    x: Math.min(
           Math.max((barRoot ? barRoot._popupAnchorX : 0) - width / 2,
                    Commons.Appearance.bar.marginSide + 4),
           (barRoot ? barRoot.width : 0) - width - Commons.Appearance.bar.marginSide - 4
       )
    y: Commons.Appearance.bar.marginTop + Commons.Appearance.bar.height
    width:  _bw + _r * 2
    height: _popupCol.implicitHeight + Commons.Appearance.spacing.md * 2

    layer.enabled: true
    layer.samples: 8

    transformOrigin: Item.Top
    scale:   (barRoot && barRoot._popupVisible) ? 1.0 : 0.85
    opacity: (barRoot && barRoot._popupVisible) ? 1.0 : 0.0
    visible: barRoot && barRoot.side === "top" && opacity > 0.01

    Behavior on scale   { NumberAnimation { duration: 150; easing.type: Easing.OutCubic } }
    Behavior on opacity { NumberAnimation { duration: 150; easing.type: Easing.OutCubic } }

    ShapePath {
        fillColor:   Commons.Appearance.colors.glassBgLight
        strokeWidth: 0
        strokeColor: "transparent"

        startX: 0; startY: 0
        PathLine { x: card._bw + card._r * 2; y: 0 }
        PathArc  { x: card._bw + card._r; y: card._r
                   radiusX: card._r; radiusY: card._r
                   direction: PathArc.Counterclockwise }
        PathLine { x: card._bw + card._r; y: card.height - card._rb }
        PathArc  { x: card._bw + card._r - card._rb; y: card.height
                   radiusX: card._rb; radiusY: card._rb
                   direction: PathArc.Clockwise }
        PathLine { x: card._r + card._rb; y: card.height }
        PathArc  { x: card._r; y: card.height - card._rb
                   radiusX: card._rb; radiusY: card._rb
                   direction: PathArc.Clockwise }
        PathLine { x: card._r; y: card._r }
        PathArc  { x: 0; y: 0
                   radiusX: card._r; radiusY: card._r
                   direction: PathArc.Counterclockwise }
        PathLine { x: 0; y: 0 }
    }

    // Keep popup alive when cursor drifts onto it.
    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onEntered: if (card.barRoot) card.barRoot.keepPopupsAlive()
        onExited: if (card.barRoot && Date.now() - card.barRoot._lastShowTime > 200)
            card.barRoot.hidePopup()
    }

    Column {
        id: _popupCol
        x: card._r + 14; y: Commons.Appearance.spacing.md
        spacing: 3

        Text {
            visible: !!(card.barRoot && card.barRoot._popupLabel.length > 0)
            text: card.barRoot ? card.barRoot._popupLabel : ""
            color: Commons.Appearance.colors.accent
            font.pixelSize: Commons.Appearance.font.sizeSm - 1
            font.family: Commons.Appearance.font.family
            font.letterSpacing: 1.2
            font.weight: Font.DemiBold
        }
        Text {
            text: card.barRoot ? card.barRoot._popupPrimary : ""
            color: Commons.Appearance.colors.text
            font.pixelSize: Commons.Appearance.font.sizeLg
            font.family: Commons.Appearance.font.family
            font.weight: Font.Medium
        }
        Text {
            visible: !!(card.barRoot && card.barRoot._popupSecondary.length > 0)
            text: card.barRoot ? card.barRoot._popupSecondary : ""
            color: Commons.Appearance.colors.subtext0
            font.pixelSize: Commons.Appearance.font.sizeSm
            font.family: Commons.Appearance.font.family
        }
        Text {
            visible: !!(card.barRoot && card.barRoot._popupHint.length > 0)
            text: card.barRoot ? card.barRoot._popupHint : ""
            color: Commons.Appearance.colors.overlay0
            font.pixelSize: Commons.Appearance.font.sizeSm - 1
            font.family: Commons.Appearance.font.family
        }
    }
}
