import QtQuick
import QtQuick.Shapes
import "K.js" as K
// Bar widget variant v (ring | bar | text) at level lv (ok | warn | crit)
Item { id: w; property string v: "ring"; property string lv: "ok"; property real pct: lv==="ok" ? 0.62 : lv==="warn" ? 0.88 : 0.95
  property string free: lv==="ok" ? "88 G" : lv==="warn" ? "26 G" : "9.8 G"
  // monochrome has no hues: warn = bright, critical = inverted chip (colour themes use peach / red)
  property color fg: lv==="ok" ? K.ov2 : lv==="warn" ? K.text : K.base
  property color chip: lv==="crit" ? K.text : "transparent"
  implicitWidth: row.implicitWidth + 16; implicitHeight: 28
  Rectangle { anchors.fill: parent; radius: 8; color: w.chip }
  Row { id: row; anchors.centerIn: parent; spacing: 6
    Txt { visible: w.v==="dring"; m: true; text: "󰋊"; color: w.fg; font.pixelSize: 15; anchors.verticalCenter: parent.verticalCenter }
    Item { visible: w.v==="ring" || w.v==="dring"; width: 18; height: 18; anchors.verticalCenter: parent.verticalCenter
      Shape { anchors.fill: parent; preferredRendererType: Shape.CurveRenderer
        ShapePath { strokeColor: w.lv==="crit" ? "#55000000" : K.s2; strokeWidth: 3; fillColor: "transparent"; capStyle: ShapePath.RoundCap
          PathAngleArc { centerX: 9; centerY: 9; radiusX: 7.5; radiusY: 7.5; startAngle: 0; sweepAngle: 360 } }
        ShapePath { strokeColor: w.fg; strokeWidth: 3; fillColor: "transparent"; capStyle: ShapePath.RoundCap
          PathAngleArc { centerX: 9; centerY: 9; radiusX: 7.5; radiusY: 7.5; startAngle: -90; sweepAngle: 360*w.pct } } } }
    Txt { visible: w.v!=="ring" && w.v!=="dring"; m: true; text: "󰋊"; color: w.fg; font.pixelSize: 15; anchors.verticalCenter: parent.verticalCenter }
    Rectangle { visible: w.v==="bar"; width: 34; height: 8; radius: 4; color: w.lv==="crit" ? "#40000000" : K.s2; anchors.verticalCenter: parent.verticalCenter
      Rectangle { width: parent.width*w.pct; height: parent.height; radius: 4; color: w.fg } }
    Txt { visible: w.v!=="bar" || w.lv!=="ok"; m: true; font.pixelSize: 13; color: w.fg; anchors.verticalCenter: parent.verticalCenter
      text: (w.v==="ring" || w.v==="dring") ? (w.lv==="ok" ? "" : w.free) : w.v==="text" ? (w.free + " free") : w.free } } }
